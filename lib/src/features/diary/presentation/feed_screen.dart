import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../data/mock_post_repository.dart';
import '../domain/models/post_model.dart';
import 'widgets/audio_post_card.dart';

final feedProvider = FutureProvider<List<AudioPost>>((ref) async {
  final repository = ref.watch(mockPostRepositoryProvider);
  return repository.getAllPosts();
});

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () => context.push('/search'),
              icon: const Icon(Icons.search)),
        ],
      ),
      body: feedAsync.when(
        data: (posts) => ListView.builder(
          itemCount: posts.length,
          padding: const EdgeInsets.only(bottom: 80),
          itemBuilder: (context, index) {
            return AudioPostCard(
              post: posts[index],
              onTap: () => context.push('/detail/${posts[index].id}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
