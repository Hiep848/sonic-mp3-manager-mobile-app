import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/dio_provider.dart';
import '../../domain/models/post_model.dart'; // Import model của bạn

part 'post_remote_datasource.g.dart';

class PostRemoteDataSource {
  final Dio _dio;
  PostRemoteDataSource(this._dio);

  Future<List<AudioPost>> getFeed({
    int limit = 10,
    int skip = 0,
    String sortBy = 'newest',
  }) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.baseUrl}/posts', // Đảm bảo endpoint đúng trong constants
        queryParameters: {
          'limit': limit,
          'skip': skip,
          'sort_by': sortBy,
        },
      );

      if (response.statusCode == 204) {
        return [];
      }

      final data = response.data;
      if (data is List) {
        return data.map((e) => AudioPost.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
PostRemoteDataSource postRemoteDataSource(PostRemoteDataSourceRef ref) {
  return PostRemoteDataSource(ref.watch(dioProvider));
}
