import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/app_toast.dart';
import '../../diary/data/repositories/post_repository.dart';
import '../../diary/domain/models/post_model.dart';
import '../domain/models/playlist_models.dart';
import 'controllers/album_actions_controller.dart';
import 'controllers/album_detail_controller.dart';
import '../../../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
              PopupMenuItem(
                value: 'rename',
                child: Text(l10n.albumRename),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(l10n.albumDelete,
                    style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: playlistAsync.when(
        data: (playlist) => _buildBody(context, ref, playlist),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(l10n.commonError(err))),
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
            title: Text(AppLocalizations.of(context)!.albumDeleteTitle),
            content: Text(AppLocalizations.of(context)!.albumDeleteConfirm),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => Navigator.pop(dialogContext, false),
                child: Text(AppLocalizations.of(context)!.commonCancel),
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
            title: Text(AppLocalizations.of(context)!.albumRenameTitle),
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
                    : Text(AppLocalizations.of(context)!.commonSave),
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
      return Center(child: Text(AppLocalizations.of(context)!.albumNoTracks));
    }

    return ListView.builder(
      itemCount: playlist.tracks.length,
      itemBuilder: (context, index) {
        final track = playlist.tracks[index];
        return ListTile(
          leading: const Icon(Icons.music_note),
          title: Text(track.title),
          subtitle: Text(track.meta.artist ??
              AppLocalizations.of(context)!.albumUnknownArtist),
          onTap: () {
            // Navigate to Detail Screen only, as requested
            context.push('/detail/${track.meta.postId}');
          },
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
  final Set<String> _addingPostIds = {};

  @override
  void initState() {
    super.initState();
    _postsFuture = ref.read(postRepositoryProvider).getFeed(limit: 50);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the controller to keep it alive
    ref.watch(albumActionsControllerProvider);

    return Column(
      children: [
        AppBar(
          title: Text(AppLocalizations.of(context)!.albumAddMp3Title),
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
                return Center(
                    child: Text(AppLocalizations.of(context)!.albumNoMp3s));
              }
              return ListView.builder(
                controller: widget.scrollController,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  final isItemLoading = _addingPostIds.contains(post.id);

                  return ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(post.title),
                    subtitle: Text(post.textContent ??
                        AppLocalizations.of(context)!.albumNoDescription),
                    trailing: IconButton(
                      icon: isItemLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.add_circle_outline),
                      onPressed: isItemLoading ? null : () => _addPost(post),
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
    setState(() {
      _addingPostIds.add(post.id);
    });

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
    } finally {
      if (mounted) {
        setState(() {
          _addingPostIds.remove(post.id);
        });
      }
    }
  }
}
