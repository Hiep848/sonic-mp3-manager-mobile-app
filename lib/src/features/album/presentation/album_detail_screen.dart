import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Delete Album'),
                content:
                    const Text('Are you sure you want to delete this album?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.red))),
                ],
              ));

      if (confirm == true) {
        await ref
            .read(albumActionsControllerProvider.notifier)
            .deleteAlbum(albumId);
        if (context.mounted) Navigator.pop(context); // Go back
      }
    } else if (action == 'rename') {
      // Show rename dialog
      _showRenameDialog(context, ref);
    }
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: albumName);
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Rename Album'),
              content: TextField(controller: controller),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () async {
                      final newTitle = controller.text.trim();
                      if (newTitle.isNotEmpty) {
                        await ref
                            .read(albumActionsControllerProvider.notifier)
                            .renameAlbum(id: albumId, title: newTitle);
                        if (context.mounted) Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Save')),
              ],
            ));
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
}
