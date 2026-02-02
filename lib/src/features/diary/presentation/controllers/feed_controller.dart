import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/post_repository.dart';
import '../../domain/models/post_model.dart';

part 'feed_controller.g.dart';

@riverpod
class FeedController extends _$FeedController {
  // Trạng thái hiện tại của Sort
  String _currentSort = 'newest';
  int _currentSkip = 0;
  bool _hasMore = true; // Cờ kiểm tra còn dữ liệu không

  @override
  FutureOr<List<AudioPost>> build() async {
    // Load trang đầu tiên khi init
    _currentSkip = 0;
    _hasMore = true;
    return _fetchPosts(skip: 0);
  }

  Future<List<AudioPost>> _fetchPosts({required int skip}) async {
    final repository = ref.read(postRepositoryProvider);
    final newPosts = await repository.getFeed(skip: skip, sortBy: _currentSort);

    // Nếu số lượng trả về < limit (10) -> Hết dữ liệu
    if (newPosts.length < 10) {
      _hasMore = false;
    }
    return newPosts;
  }

  // Hàm load thêm (Pagination)
  Future<void> loadMore() async {
    // Nếu đang loading hoặc đã hết dữ liệu -> Dừng
    if (state.isLoading || !_hasMore) return;

    // Giữ data cũ, set trạng thái loading background
    final currentPosts = state.value ?? [];

    // Tăng skip
    _currentSkip = currentPosts.length;

    try {
      final nextPosts = await _fetchPosts(skip: _currentSkip);
      // Nối list mới vào list cũ
      state = AsyncData([...currentPosts, ...nextPosts]);
    } catch (e, st) {
      // Có thể xử lý lỗi riêng cho pagination mà không làm crash cả màn hình
      state = AsyncError(e, st);
    }
  }

  // Hàm đổi kiểu sắp xếp
  Future<void> changeSort(String sortBy) async {
    if (_currentSort == sortBy) return;

    _currentSort = sortBy;
    _currentSkip = 0;
    _hasMore = true;

    state = const AsyncLoading(); // Reset UI về loading
    state = await AsyncValue.guard(() => _fetchPosts(skip: 0));
  }

  // Hàm Refresh (kéo để reload)
  Future<void> refresh() async {
    _currentSkip = 0;
    _hasMore = true;
    state = await AsyncValue.guard(() => _fetchPosts(skip: 0));
  }
}
