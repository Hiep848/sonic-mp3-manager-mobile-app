import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp3_management/src/features/diary/data/mock_album_repository.dart';
import 'package:mp3_management/src/features/diary/domain/models/album_model.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';

final albumsProvider = FutureProvider<List<Album>>((ref) async {
  final repository = ref.watch(mockAlbumRepositoryProvider);
  return repository.getAllAlbums();
});

class AlbumScreen extends ConsumerWidget {
  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(albumsProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.albumTitle),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
      ),
      body: albumsAsync.when(
        data: (albums) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to album detail (filtered list) - Placeholder
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening ${album.name}...')),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            image: album.coverUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(album.coverUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: album.coverUrl == null
                              ? Center(
                                  child: Icon(Icons.album,
                                      size: 40,
                                      color:
                                          theme.colorScheme.onSurfaceVariant),
                                )
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              album.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${album.postCount} ${l10n.albumAudios}',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
