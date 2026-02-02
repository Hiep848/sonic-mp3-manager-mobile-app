import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import 'controllers/feed_controller.dart';
import 'widgets/audio_post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () => context.push('/search'),
              icon: const Icon(Icons.search)),
          // [UI Mới] Nút Filter Sắp xếp
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              ref.read(feedControllerProvider.notifier).changeSort(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'newest',
                child: Text('Mới nhất'),
              ),
              const PopupMenuItem(
                value: 'popular',
                child: Text('Nghe nhiều nhất'),
              ),
            ],
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          // Logic trigger Load More khi cuộn gần đáy (còn 200px)
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
              if (posts.isEmpty) {
                return const Center(child: Text("Chưa có bài đăng nào"));
              }
              return ListView.builder(
                // +1 item để hiện loading indicator ở đáy
                itemCount: posts.length + 1,
                padding: const EdgeInsets.only(bottom: 80),
                itemBuilder: (context, index) {
                  // Item cuối cùng: Loading spinner khi đang fetch thêm
                  if (index == posts.length) {
                    // Kiểm tra xem có đang loading không bằng cách check state
                    // (Lưu ý: AsyncValue có thuộc tính isRefreshing / isLoading)
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi tải dữ liệu: $err'),
                  const Gap(8),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(feedControllerProvider.notifier).refresh(),
                    child: const Text("Thử lại"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
