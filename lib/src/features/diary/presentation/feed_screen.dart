import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../upload/domain/models/upload_state.dart';
import '../../upload/presentation/controllers/upload_controller.dart';
import 'controllers/feed_controller.dart';
import 'widgets/audio_post_card.dart';
import 'widgets/uploading_post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedControllerProvider);
    final uploadState = ref.watch(uploadControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(uploadControllerProvider, (previous, next) {
      if (next.stage == UploadStage.completed &&
          previous?.stage != UploadStage.completed) {
        ref.invalidate(feedControllerProvider);
      }
    });

    final isUploading = uploadState.stage != UploadStage.idle;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () => context.push('/search'),
              icon: const Icon(Icons.search)),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              ref.read(feedControllerProvider.notifier).changeSort(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'newest', child: Text('Mới nhất')),
              const PopupMenuItem(
                  value: 'popular', child: Text('Nghe nhiều nhất')),
            ],
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 200) {
            ref.read(feedControllerProvider.notifier).loadMore();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => ref.read(feedControllerProvider.notifier).refresh(),
          child: feedState.when(
            data: (posts) {
              final hasPosts = posts.isNotEmpty;
              final bool hasMoreData = posts.length >= 10;
              final itemCount =
                  posts.length + (hasMoreData ? 1 : 0) + (isUploading ? 1 : 0);
              if (!hasPosts && !isUploading) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.7, // Chiều cao ảo để căn giữa
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.feed_outlined,
                                size: 64, color: Colors.grey),
                            Text("Chưa có bài đăng nào"),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (isUploading) {
                    if (index == 0) {
                      return UploadingPostCard(
                        uploadState: uploadState,
                      );
                    }
                    index -= 1;
                  }
                  if (index == posts.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                          child: SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))),
                    );
                  }
                  return AudioPostCard(
                    post: posts[index],
                    onTap: () => context.push('/detail/${posts[index].id}'),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text('Lỗi tải dữ liệu: $err'),
            ),
          ),
        ),
      ),
    );
  }
}
