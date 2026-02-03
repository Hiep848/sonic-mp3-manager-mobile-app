import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../l10n/app_localizations.dart';
import '../data/repositories/post_repository.dart';
import '../domain/models/mood.dart';
import '../domain/models/post_model.dart';
import 'widgets/mood_chip.dart';
import 'widgets/quick_audio_player.dart';

// Provider lấy chi tiết bài viết (Dùng autoDispose để luôn refresh khi vào lại)
final postDetailProvider =
    FutureProvider.autoDispose.family<AudioPost, String>((ref, id) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostById(id);
});

class DetailScreen extends ConsumerStatefulWidget {
  final String postId;
  const DetailScreen({super.key, required this.postId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool _isEditing = false;
  bool _isSaving = false;
  bool _isDownloading = false;

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _hashtagsController;
  Mood? _selectedMood;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _hashtagsController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _hashtagsController.dispose();
    super.dispose();
  }

  // Hàm điền dữ liệu vào Controller khi mới load xong
  void _populateControllers(AudioPost post) {
    if (_titleController.text.isEmpty) {
      _titleController.text = post.title;
      _contentController.text = post.textContent ?? '';
      _hashtagsController.text = post.hashtags.join(" ");
      _selectedMood = post.mood ?? Mood.neutral;
    }
  }

  Future<void> _saveChanges(AudioPost originalPost) async {
    setState(() => _isSaving = true);
    try {
      final updatedPost = originalPost.copyWith(
        title: _titleController.text.trim(),
        textContent: _contentController.text.trim(),
        mood: _selectedMood ?? originalPost.mood,
        hashtags: _hashtagsController.text
            .trim()
            .split(' ')
            .where((s) => s.isNotEmpty)
            .toList(),
      );

      await ref
          .read(postRepositoryProvider)
          .updatePost(widget.postId, updatedPost);

      // Refresh lại dữ liệu để hiển thị cái mới nhất
      ref.invalidate(postDetailProvider(widget.postId));

      setState(() {
        _isEditing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.detailSaveSuccess)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _handleDownload(String postId, String format) async {
    setState(() => _isDownloading = true);
    try {
      final repo = ref.read(postRepositoryProvider);

      // Gọi hàm repository đã tạo ở bước trên
      final filePath = await repo.downloadTranscript(postId, format);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.detailDownloadSuccess(format)),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.commonOpen,
              onPressed: () => OpenFilex.open(filePath),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.detailDownloadError(e))),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postDetailProvider(widget.postId));
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: postAsync.when(
        data: (post) {
          if (!_isEditing) _populateControllers(post);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(
                      left: 16, bottom: 16, right: 100), // Né nút Action
                  title: _isEditing
                      ? null // Ẩn title trên Appbar khi edit để user sửa ở dưới body
                      : Text(
                          post.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 4)
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                  background: post.thumbnailUrl != null
                      ? Image.network(
                          post.thumbnailUrl!,
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.darken,
                          color: Colors.black.withOpacity(0.3),
                        )
                      : Container(color: theme.colorScheme.primary),
                ),
                actions: [
                  if (_isEditing) ...[
                    IconButton(
                      icon: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.save),
                      onPressed: _isSaving ? null : () => _saveChanges(post),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _isEditing = false),
                    )
                  ] else ...[
                    if (_isDownloading)
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)),
                      )
                    else
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.download),
                        tooltip: l10n.detailDownloadTooltip,
                        onSelected: (format) =>
                            _handleDownload(post.id, format),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'word',
                            child: Row(
                              children: [
                                const Icon(Icons.description,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(l10n.detailDownloadWord),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'pdf',
                            child: Row(
                              children: [
                                const Icon(Icons.picture_as_pdf,
                                    color: Colors.red),
                                const SizedBox(width: 8),
                                Text(l10n.detailDownloadPdf),
                              ],
                            ),
                          ),
                        ],
                      ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() => _isEditing = true);
                      },
                    ),
                  ],
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- SECTION 1: TITLE & MOOD ---
                      if (_isEditing) ...[
                        TextField(
                          controller: _titleController,
                          decoration:
                              InputDecoration(labelText: l10n.detailEditTitle),
                          style: theme.textTheme.headlineSmall,
                        ),
                        const Gap(16),
                        Text(l10n.detailEditMood,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const Gap(8),
                        Wrap(
                          spacing: 8,
                          children: Mood.values
                              .map((m) => ChoiceChip(
                                    label: Text(m.label),
                                    selected: _selectedMood == m,
                                    onSelected: (val) =>
                                        setState(() => _selectedMood = m),
                                  ))
                              .toList(),
                        )
                      ] else ...[
                        Row(
                          children: [
                            MoodChip(mood: post.mood),
                            const Gap(12),
                            Text(
                              '${l10n.detailRecorded} ${post.uploadDate.day}/${post.uploadDate.month}/${post.uploadDate.year}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],

                      const Gap(24),

                      Text(l10n.detailRecording,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Gap(8),
                      QuickAudioPlayer(
                        duration: post.duration,
                        audioUrl: post.streamUrl,
                        post: post,
                      ),

                      const Gap(24),

                      if (_isEditing)
                        TextField(
                          controller: _hashtagsController,
                        )
                      else
                        Wrap(
                          spacing: 8,
                          children: post.hashtags
                              .map((tag) => Chip(
                                    label: Text(tag,
                                        style: TextStyle(
                                            color: theme.colorScheme.primary)),
                                    backgroundColor: theme
                                        .colorScheme.primaryContainer
                                        .withOpacity(0.3),
                                  ))
                              .toList(),
                        ),

                      const Gap(24),

                      // --- SECTION 4: TRANSCRIPT / CONTENT ---
                      Text(l10n.detailJournal,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const Gap(8),

                      if (_isEditing)
                        TextField(
                          controller: _contentController,
                          maxLines: null, // Cho phép xuống dòng thoải mái
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: l10n.detailEditContentHint),
                          style:
                              theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                        )
                      else
                        SelectableText(
                          // Dùng SelectableText để user có thể copy
                          post.textContent ?? l10n.detailNoContent,
                          style:
                              theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                        ),

                      const Gap(40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(l10n.commonError(err))),
      ),
    );
  }
}
