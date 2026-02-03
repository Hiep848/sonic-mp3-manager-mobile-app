import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/album_repository.dart';
import 'my_albums_controller.dart';
import 'album_detail_controller.dart';

part 'album_actions_controller.g.dart';

@riverpod
class AlbumActionsController extends _$AlbumActionsController {
  @override
  FutureOr<void> build() {
    // nothing to init
  }

  Future<void> createAlbum(String title) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(albumRepositoryProvider);
      await repository.createAlbum(title: title);
      // Refresh list
      ref.invalidate(myAlbumsControllerProvider);
    });
  }

  Future<void> renameAlbum({required String id, required String title}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(albumRepositoryProvider);
      await repository.updateAlbum(id: id, title: title);
      ref.invalidate(myAlbumsControllerProvider);
      ref.invalidate(albumDetailControllerProvider(id));
    });
  }

  Future<void> deleteAlbum(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(albumRepositoryProvider);
      await repository.deleteAlbum(id);
      ref.invalidate(myAlbumsControllerProvider);
    });
  }

  Future<void> addPostToAlbum(
      {required String albumId, required String postId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(albumRepositoryProvider);
      await repository.addPostToAlbum(albumId: albumId, postId: postId);
      // Optional: Refresh album detail if we are adding from a specific context
      // But usually this happens from Feed or Player, so maybe we don't need to refresh details immediately unless we are viewing it.
      // Refreshing 'My Albums' mostly updates post count
      ref.invalidate(myAlbumsControllerProvider);
      if (ref.exists(albumDetailControllerProvider(albumId))) {
        ref.invalidate(albumDetailControllerProvider(albumId));
      }
    });
  }

  Future<void> removePostFromAlbum(
      {required String albumId, required String postId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(albumRepositoryProvider);
      await repository.removePostFromAlbum(albumId: albumId, postId: postId);
      ref.invalidate(albumDetailControllerProvider(albumId));
      ref.invalidate(myAlbumsControllerProvider);
    });
  }
}
