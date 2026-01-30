import 'package:flutter/material.dart';
import 'package:mp3_management/src/features/diary/domain/models/post_model.dart';
import 'package:mp3_management/src/features/diary/presentation/widgets/mood_chip.dart';
import 'package:mp3_management/src/features/diary/presentation/widgets/quick_audio_player.dart';

class AudioPostCard extends StatelessWidget {
  final AudioPost post;
  final VoidCallback? onTap;

  const AudioPostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final hasBackground = post.thumbnailUrl != null;

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
                // Header: Date & Mood
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
                    MoodChip(mood: post.mood),
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
                  isLight: hasBackground,
                ),

                const SizedBox(height: 12),

                // Footer: Hashtags & File Size
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
