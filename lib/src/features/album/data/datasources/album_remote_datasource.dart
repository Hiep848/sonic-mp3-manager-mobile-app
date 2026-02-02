import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/dio_provider.dart';
import '../../domain/models/album_model.dart';
import '../../domain/models/playlist_models.dart';

part 'album_remote_datasource.g.dart';

class AlbumRemoteDataSource {
  final Dio _dio;
  AlbumRemoteDataSource(this._dio);

  Future<void> createAlbum({required String title}) async {
    await _dio.post(ApiEndpoints.albums, data: {'title': title});
  }

  Future<List<Album>> getMyAlbums() async {
    final response = await _dio.get(ApiEndpoints.myAlbums);
    final List data = response.data;
    return data.map((e) => Album.fromJson(e)).toList();
  }

  Future<List<Album>> searchAlbums({String? keyword, int limit = 10}) async {
    final response = await _dio.get(
      ApiEndpoints.searchAlbums,
      queryParameters: {
        if (keyword != null) 'keyword': keyword,
        'limit': limit,
      },
    );
    final List data = response.data;
    return data.map((e) => Album.fromJson(e)).toList();
  }

  Future<Album> getAlbumDetail(String id) async {
    final response = await _dio.get(ApiEndpoints.albumDetail(id));
    return Album.fromJson(response.data);
  }

  Future<void> updateAlbum({required String id, required String title}) async {
    await _dio.patch(
      ApiEndpoints.albumDetail(id),
      data: {'title': title},
    );
  }

  Future<void> deleteAlbum(String id) async {
    await _dio.delete(ApiEndpoints.albumDetail(id));
  }

  Future<void> addPostToAlbum(
      {required String albumId, required String postId}) async {
    await _dio.post(
      ApiEndpoints.albumPosts(albumId),
      data: {'postId': postId},
    );
  }

  Future<void> removePostFromAlbum(
      {required String albumId, required String postId}) async {
    await _dio.delete(ApiEndpoints.albumPost(albumId, postId));
  }

  Future<AlbumPlaylist> getPlaylist(String albumId) async {
    final response = await _dio.get(ApiEndpoints.albumPlaylist(albumId));
    return AlbumPlaylist.fromJson(response.data);
  }

  Future<AlbumPlaylist> shuffle(String albumId) async {
    final response = await _dio.get(ApiEndpoints.albumShuffle(albumId));
    return AlbumPlaylist.fromJson(response.data);
  }
}

@riverpod
AlbumRemoteDataSource albumRemoteDataSource(AlbumRemoteDataSourceRef ref) {
  return AlbumRemoteDataSource(ref.watch(dioProvider));
}
