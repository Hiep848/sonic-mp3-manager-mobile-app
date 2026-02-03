import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
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

      if (response.statusCode == 204 || response.data == null) {
        return [];
      }
      if (response.data is String && (response.data as String).isEmpty) {
        return [];
      }

      if (response.data is List) {
        return (response.data as List).map((e) {
          try {
            return AudioPost.fromJson(e);
          } catch (err) {
            print("Error parsing post: $err");
            print("Problematic JSON: $e");
            rethrow;
          }
        }).toList();
      } else {
        print("Unexpected response format: ${response.data.runtimeType}");
        return [];
      }
    } catch (e, stackTrace) {
      print("Error: $e, at \n $stackTrace");
      rethrow;
    }
  }

  Future<AudioPost> getPostById(String id) async {
    final response = await _dio.get('/posts/$id');
    return AudioPost.fromJson(response.data);
  }

  Future<void> updatePost(String id, AudioPost updatedPost) async {
    await _dio.put(
      '/posts/$id',
      data: {
        'title': updatedPost.title,
        'text_content': updatedPost.textContent,
        'mood': updatedPost.mood?.name,
        'hashtags': updatedPost.hashtags,
      },
    );
  }

  Future<String> downloadTranscript(String postId, String format) async {
    // Map 'word' to 'docx' for the API if needed, usually 'docx' is the standard extension/format key
    final requestFormat = format == 'word' ? 'docx' : format;
    final endpoint = '/media/$postId/export/$requestFormat';

    final directory = await getApplicationDocumentsDirectory();
    final extension = requestFormat == 'docx' ? 'docx' : 'pdf';
    final savePath = '${directory.path}/transcript_$postId.$extension';
    try {
      await _dio.download(
        endpoint,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
                'Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );
      return savePath;
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is ResponseBody) {
        try {
          final responseBody = e.response!.data as ResponseBody;
          final errorBytes = await responseBody.stream.toList();
          final errorList = errorBytes.expand((x) => x).toList();
          final errorText = String.fromCharCodes(errorList);
          print('Server Error Body: $errorText');
        } catch (readError) {
          print('Failed to read error body: $readError');
        }
      }
      rethrow;
    }
  }
}

@riverpod
PostRemoteDataSource postRemoteDataSource(PostRemoteDataSourceRef ref) {
  return PostRemoteDataSource(ref.watch(dioProvider));
}
