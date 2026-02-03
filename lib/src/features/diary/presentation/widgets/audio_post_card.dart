import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/app_toast.dart';
import '../../data/repositories/post_repository.dart';
import '../../../upload/domain/models/upload_state.dart';
import '../../domain/models/post_model.dart';
import 'mood_chip.dart';
import 'quick_audio_player.dart';

class AudioPostCard extends ConsumerWidget {
  final AudioPost post;
  final VoidCallback? onTap;
  final UploadState? uploadState;
  final VoidCallback? onCancel;

  const AudioPostCard({
    super.key,
    required this.post,
    this.onTap,
    this.uploadState,
    this.onCancel,
  });

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hủy đăng bài?'),
        content:
            const Text('Tiến trình tải lên sẽ bị hủy và không thể khôi phục.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onCancel?.call();
            },
            child: const Text('Hủy bỏ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadTranscript(
      BuildContext context, WidgetRef ref, String format) async {
    try {
      AppToast.showLoading(context, message: 'Downloading $format...');
      final path = await ref
          .read(postRepositoryProvider)
          .downloadTranscript(post.id, format);

      // Hide loading dialog
      if (context.mounted) {
        AppToast.hideLoading(context);
        AppToast.showSuccess(context, 'Saved to $path');
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.hideLoading(context);
        AppToast.showError(context, 'Failed to download: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final hasBackground = post.thumbnailUrl != null;
    String? streamUrl = post.streamUrl;
    bool isProcessing = false;
    double currentProgress = 0.0;
    String? statusText;

    if (uploadState != null && uploadState!.stage != UploadStage.idle) {
      streamUrl = null;
      currentProgress = uploadState!.progress;
      isProcessing = true;
      switch (uploadState!.stage) {
        case UploadStage.uploading:
          statusText = "Đang tải lên...";
          break;
        case UploadStage.confirming:
          statusText = "Đang đồng bộ...";
          break;
        case UploadStage.processing:
          statusText = "AI đang xử lý...";
          break;
        case UploadStage.failed:
          statusText = "Lỗi xử lý";
          break;
        default:
          statusText = "Đang xử lý...";
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          image: hasBackground
              ? DecorationImage(
                  image: NetworkImage(post.thumbnailUrl!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Date & Mood & Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(post.recordDate),
                      style: textTheme.labelMedium?.copyWith(
                        color: hasBackground
                            ? Colors.white70
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MoodChip(mood: post.mood),
                        if (!isProcessing)
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: hasBackground
                                  ? Colors.white70
                                  : colorScheme.onSurfaceVariant,
                            ),
                            onSelected: (value) =>
                                _downloadTranscript(context, ref, value),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'word',
                                child: Row(
                                  children: [
                                    Icon(Icons.description, size: 20),
                                    SizedBox(width: 8),
                                    Text('Download Word'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'pdf',
                                child: Row(
                                  children: [
                                    Icon(Icons.picture_as_pdf, size: 20),
                                    SizedBox(width: 8),
                                    Text('Download PDF'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (isProcessing) ...[
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.close, size: 20),
                              color:
                                  hasBackground ? Colors.white70 : Colors.grey,
                              tooltip: "Hủy tải lên",
                              onPressed: () => _showCancelDialog(context),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineSmall?.copyWith(
                    color: hasBackground ? Colors.white : colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Content Preview
                if (post.textContent != null)
                  Text(
                    post.textContent!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: hasBackground
                          ? Colors.white.withOpacity(0.9)
                          : colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                const SizedBox(height: 16),

                // Audio Player
                QuickAudioPlayer(
                  duration: post.duration,
                  audioUrl: streamUrl,
                  isLight: hasBackground,
                  progress: isProcessing ? currentProgress : null,
                  statusText: statusText,
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    ...post.hashtags.take(2).map((tag) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            tag,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                    const Spacer(),
                    if (isProcessing)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${(currentProgress * 100).toInt()}%', // Hiển thị % thực
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      Text(
                        '${(post.fileSize / 1024 / 1024).toStringAsFixed(1)} MB',
                        style: textTheme.labelSmall?.copyWith(
                          color: hasBackground
                              ? Colors.white54
                              : colorScheme.outline,
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }
}
