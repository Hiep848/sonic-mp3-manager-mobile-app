import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../domain/models/album_model.dart';
import 'controllers/my_albums_controller.dart';

class AlbumScreen extends ConsumerWidget {
  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(myAlbumsControllerProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.albumTitle),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(myAlbumsControllerProvider.notifier).refresh(),
        child: albumsAsync.when(
          data: (albums) {
            if (albums.isEmpty) {
              return Center(
                child: Text(
                  'No albums found',
                  style: theme.textTheme.bodyLarge,
                ),
              );
            }
            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
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
                    // Navigate to album detail
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
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              image: album.coverUrl != null &&
                                      album.coverUrl!.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(album.coverUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: (album.coverUrl == null ||
                                    album.coverUrl!.isEmpty)
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
      ),
    );
  }
}
