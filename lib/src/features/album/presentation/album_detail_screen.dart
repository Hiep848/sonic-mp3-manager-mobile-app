import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/app_toast.dart';
import '../../diary/data/repositories/post_repository.dart';
import '../../diary/domain/models/post_model.dart';
import '../domain/models/playlist_models.dart';
import 'controllers/album_actions_controller.dart';
import 'controllers/album_detail_controller.dart';

class AlbumDetailScreen extends ConsumerWidget {
  final String albumId;
  final String albumName; // Passed for initial title

  const AlbumDetailScreen({
    super.key,
    required this.albumId,
    required this.albumName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistAsync = ref.watch(albumDetailControllerProvider(albumId));

    return Scaffold(
      appBar: AppBar(
        title: Text(playlistAsync.valueOrNull?.album ?? albumName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddPostBottomSheet(context, ref),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleAction(context, ref, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'rename',
                child: Text('Rename Album'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child:
                    Text('Delete Album', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: playlistAsync.when(
        data: (playlist) => _buildBody(context, ref, playlist),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) async {
    if (action == 'delete') {
      _showDeleteDialog(context, ref);
    } else if (action == 'rename') {
      // Show rename dialog
      _showRenameDialog(context, ref);
    }
  }

  void _showDeleteDialog(BuildContext parentContext, WidgetRef ref) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(albumActionsControllerProvider);
          final isLoading = state.isLoading;

          return AlertDialog(
            title: const Text('Delete Album'),
            content: const Text('Are you sure you want to delete this album?'),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        try {
                          await ref
                              .read(albumActionsControllerProvider.notifier)
                              .deleteAlbum(albumId);

                          if (!context.mounted) return;

                          final currentState =
                              ref.read(albumActionsControllerProvider);
                          if (currentState.hasError) {
                            AppToast.showError(dialogContext,
                                'Failed to delete: ${currentState.error}');
                          } else {
                            Navigator.pop(dialogContext); // Close dialog
                            if (parentContext.mounted) {
                              AppToast.showSuccess(
                                  parentContext, 'Delete album successfully');
                              Navigator.pop(parentContext); // Pop screen
                            }
                          }
                        } catch (e) {
                          if (dialogContext.mounted) {
                            AppToast.showError(dialogContext,
                                'An unexpected error occurred: $e');
                          }
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showRenameDialog(BuildContext parentContext, WidgetRef ref) {
    final controller = TextEditingController(text: albumName);
    showDialog(
      context: parentContext,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(albumActionsControllerProvider);
          final isLoading = state.isLoading;

          return AlertDialog(
            title: const Text('Rename Album'),
            content: TextField(
              controller: controller,
              enabled: !isLoading,
            ),
            actions: [
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final newTitle = controller.text.trim();
                        if (newTitle.isNotEmpty) {
                          try {
                            await ref
                                .read(albumActionsControllerProvider.notifier)
                                .renameAlbum(id: albumId, title: newTitle);

                            if (!context.mounted) return;

                            final currentState =
                                ref.read(albumActionsControllerProvider);
                            if (currentState.hasError) {
                              AppToast.showError(dialogContext,
                                  'Failed to rename: ${currentState.error}');
                            } else {
                              Navigator.pop(dialogContext); // Close dialog
                              if (parentContext.mounted) {
                                AppToast.showSuccess(
                                    parentContext, 'Rename album successfully');
                                Navigator.pop(parentContext); // Pop screen
                              }
                            }
                          } catch (e) {
                            if (dialogContext.mounted) {
                              AppToast.showError(dialogContext,
                                  'An unexpected error occurred: $e');
                            }
                          }
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, WidgetRef ref, AlbumPlaylist playlist) {
    if (playlist.tracks.isEmpty) {
      return const Center(child: Text('No tracks in this album'));
    }

    return ListView.builder(
      itemCount: playlist.tracks.length,
      itemBuilder: (context, index) {
        final track = playlist.tracks[index];
        return ListTile(
          leading: const Icon(Icons.music_note),
          title: Text(track.title),
          subtitle: Text(track.meta.artist ?? 'Unknown Artist'),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              ref
                  .read(albumActionsControllerProvider.notifier)
                  .removePostFromAlbum(
                      albumId: albumId, postId: track.meta.postId);
            },
          ),
        );
      },
    );
  }

  void _showAddPostBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return _PostSelectionList(
            scrollController: scrollController,
            albumId: albumId,
          );
        },
      ),
    );
  }
}

class _PostSelectionList extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final String albumId;
  const _PostSelectionList(
      {required this.scrollController, required this.albumId});

  @override
  ConsumerState<_PostSelectionList> createState() => _PostSelectionListState();
}

class _PostSelectionListState extends ConsumerState<_PostSelectionList> {
  late Future<List<AudioPost>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = ref.read(postRepositoryProvider).getFeed(limit: 50);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the controller to keep it alive and get loading state
    final actionState = ref.watch(albumActionsControllerProvider);
    final isLoading = actionState.isLoading;

    return Column(
      children: [
        AppBar(
          title: const Text('Add MP3 to Album'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
        Expanded(
          child: FutureBuilder<List<AudioPost>>(
            future: _postsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final posts = snapshot.data ?? [];
              if (posts.isEmpty) {
                return const Center(child: Text('No MP3s found'));
              }
              return ListView.builder(
                controller: widget.scrollController,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(post.title),
                    subtitle: Text(post.textContent ?? 'No description'),
                    trailing: IconButton(
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.add_circle_outline),
                      onPressed: isLoading ? null : () => _addPost(post),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _addPost(AudioPost post) async {
    try {
      await ref.read(albumActionsControllerProvider.notifier).addPostToAlbum(
            albumId: widget.albumId,
            postId: post.id,
          );
      if (mounted) {
        AppToast.showSuccess(context, 'Added "${post.title}" to album');
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, 'Failed to add: $e');
      }
    }
  }
}
