import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/dio_provider.dart';

part 'upload_remote_datasource.g.dart';

@riverpod
UploadRemoteDataSource uploadRemoteDataSource(UploadRemoteDataSourceRef ref) {
  return UploadRemoteDataSourceImpl(ref.watch(dioProvider));
}

class InitUploadResponse {
  final String jobId;
  final String uploadUrl; // [FIX] Đổi tên cho khớp backend

  InitUploadResponse({required this.jobId, required this.uploadUrl});
}

abstract class UploadRemoteDataSource {
  Future<InitUploadResponse> initUpload(String fileName, String contentType);

  Future<void> uploadFileToS3({
    required String url,
    required Stream<List<int>> fileStream,
    required int length,
    required String contentType,
    CancelToken? cancelToken,
    required Function(int, int)? onSendProgress,
  });

  Future<void> confirmUpload(String jobId);
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final Dio _dio;

  UploadRemoteDataSourceImpl(this._dio);

  @override
  Future<InitUploadResponse> initUpload(
      String fileName, String contentType) async {
    final response = await _dio.post(
      '/upload/init', // [FIX] Sử dụng đường dẫn tương đối nếu baseUrl đã cấu hình
      data: {
        'filename': fileName,
        'content_type': contentType,
      },
    );
    return InitUploadResponse(
      jobId: response.data['job_id'],
      // [FIX] Backend trả về 'upload_url', không phải 'presigned_url'
      uploadUrl: response.data['upload_url'],
    );
  }

  @override
  Future<void> uploadFileToS3({
    required String url,
    required Stream<List<int>> fileStream,
    required int length,
    required String contentType,
    CancelToken? cancelToken,
    required Function(int, int)? onSendProgress,
  }) async {
    // [QUAN TRỌNG] Dùng instance Dio mới hoàn toàn để tránh dính Header Auth của App
    final s3Dio = Dio();

    await s3Dio.put(
      url,
      data: fileStream,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      options: Options(
        headers: {
          Headers.contentLengthHeader: length, // Bắt buộc với S3 PUT
          Headers.contentTypeHeader: contentType,
        },
      ),
    );
  }

  @override
  Future<void> confirmUpload(String jobId) async {
    await _dio.post('/upload/$jobId/confirm');
  }
}
