import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mp3_management/src/features/diary/data/mock_post_repository.dart';
import 'package:mp3_management/src/features/diary/domain/models/post_model.dart';
import 'package:mp3_management/src/features/diary/presentation/widgets/mood_chip.dart';
import 'package:mp3_management/src/features/diary/presentation/widgets/quick_audio_player.dart';

import '../../../../l10n/app_localizations.dart';

final postDetailProvider =
    FutureProvider.family<AudioPost?, String>((ref, id) async {
  final repository = ref.watch(mockPostRepositoryProvider);
  return repository.getPostById(id);
});

class DetailScreen extends ConsumerWidget {
  final String postId;

  const DetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailProvider(postId));
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Mock WebView opening
    void openFullText() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.detailFullScreen)),
      );
    }

    return Scaffold(
      body: postAsync.when(
        data: (post) {
          if (post == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Post not found')),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
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
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.detailEdit)),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Mock delete
                      context.pop();
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mood & Date
                      Row(
                        children: [
                          MoodChip(mood: post.mood),
                          const SizedBox(width: 12),
                          Text(
                            '${l10n.detailRecorded} ${post.recordDate.day}/${post.recordDate.month}/${post.recordDate.year}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Audio Player
                      Text(l10n.detailRecording,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      QuickAudioPlayer(duration: post.duration),
                      const SizedBox(height: 24),

                      // Hashtags
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
                      const SizedBox(height: 24),

                      // Text Content
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.detailJournal,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          TextButton(
                              onPressed: openFullText,
                              child: Text(l10n.detailFullScreen)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.textContent ?? 'No content.',
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                      ),
                      const SizedBox(height: 24),

                      // Photos
                      if (post.attachedImageUrls.isNotEmpty) ...[
                        Text(l10n.detailPhotos,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: post.attachedImageUrls.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        post.attachedImageUrls[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) =>
            Scaffold(body: Center(child: Text('Error: $err'))),
      ),
    );
  }
}
