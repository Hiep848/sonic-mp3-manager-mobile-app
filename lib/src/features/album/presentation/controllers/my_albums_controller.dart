import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/album_model.dart';
import '../../data/repositories/album_repository.dart';

part 'my_albums_controller.g.dart';

@riverpod
class MyAlbumsController extends _$MyAlbumsController {
  @override
  FutureOr<List<Album>> build() async {
    return _fetchAlbums();
  }

  Future<List<Album>> _fetchAlbums() async {
    final repository = ref.watch(albumRepositoryProvider);
    return repository.getMyAlbums();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchAlbums());
  }

  // Add create album method here if needed for UI, or use keeping it simple
}
