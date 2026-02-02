import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/album_model.dart';
import '../../domain/models/playlist_models.dart';
import '../datasources/album_remote_datasource.dart';

part 'album_repository.g.dart';

class AlbumRepository {
  final AlbumRemoteDataSource _dataSource;
  AlbumRepository(this._dataSource);

  Future<void> createAlbum({required String title}) =>
      _dataSource.createAlbum(title: title);

  Future<List<Album>> getMyAlbums() => _dataSource.getMyAlbums();

  Future<List<Album>> searchAlbums({String? keyword, int limit = 10}) =>
      _dataSource.searchAlbums(keyword: keyword, limit: limit);

  Future<Album> getAlbumDetail(String id) => _dataSource.getAlbumDetail(id);

  Future<void> updateAlbum({required String id, required String title}) =>
      _dataSource.updateAlbum(id: id, title: title);

  Future<void> deleteAlbum(String id) => _dataSource.deleteAlbum(id);

  Future<void> addPostToAlbum(
          {required String albumId, required String postId}) =>
      _dataSource.addPostToAlbum(albumId: albumId, postId: postId);

  Future<void> removePostFromAlbum(
          {required String albumId, required String postId}) =>
      _dataSource.removePostFromAlbum(albumId: albumId, postId: postId);

  Future<AlbumPlaylist> getPlaylist(String albumId) =>
      _dataSource.getPlaylist(albumId);

  Future<AlbumPlaylist> shuffle(String albumId) => _dataSource.shuffle(albumId);
}

@riverpod
AlbumRepository albumRepository(AlbumRepositoryRef ref) {
  return AlbumRepository(ref.watch(albumRemoteDataSourceProvider));
}
