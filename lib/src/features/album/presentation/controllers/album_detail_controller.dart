import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/playlist_models.dart';
import '../../data/repositories/album_repository.dart';

part 'album_detail_controller.g.dart';

@riverpod
class AlbumDetailController extends _$AlbumDetailController {
  @override
  FutureOr<AlbumPlaylist> build(String albumId) async {
    final repository = ref.watch(albumRepositoryProvider);
    return repository.getPlaylist(albumId);
  }
}
