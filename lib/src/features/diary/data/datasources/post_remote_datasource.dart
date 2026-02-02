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

      // Handle 204 No Content or empty body
      if (response.statusCode == 204 || response.data == null) {
        return [];
      }

      // Handle case where response.data might be a String (empty string from some servers)
      if (response.data is String && (response.data as String).isEmpty) {
        return [];
      }

      // Check if data is actually a List before casting
      if (response.data is List) {
        return (response.data as List)
            .map((e) => AudioPost.fromJson(e))
            .toList();
      } else {
        // If it's not a list (e.g. a Map or String error), log and return empty or throw
        print("Unexpected response format: ${response.data.runtimeType}");
        return [];
      }
    } catch (e, stackTrace) {
      print("Error: $e, at \n $stackTrace");
      rethrow;
    }
  }
}

@riverpod
PostRemoteDataSource postRemoteDataSource(PostRemoteDataSourceRef ref) {
  return PostRemoteDataSource(ref.watch(dioProvider));
}
