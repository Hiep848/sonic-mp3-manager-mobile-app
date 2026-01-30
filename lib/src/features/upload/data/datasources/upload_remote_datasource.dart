import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/dio_provider.dart';

part 'upload_remote_datasource.g.dart';

// Provider definition
@riverpod
UploadRemoteDataSource uploadRemoteDataSource(UploadRemoteDataSourceRef ref) {
  return UploadRemoteDataSourceImpl(ref.watch(dioProvider));
}

class InitUploadResponse {
  final String jobId;
  final String presignedUrl;

  InitUploadResponse({required this.jobId, required this.presignedUrl});
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
      ApiEndpoints.uploadInit,
      data: {
        'filename': fileName,
        'content_type': contentType,
      },
    );
    return InitUploadResponse(
      jobId: response.data['job_id'],
      presignedUrl: response.data['presigned_url'],
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
    // USE A FRESH DIO for S3 upload to avoid default BaseURL/Headers interfering
    final s3Dio = Dio();

    await s3Dio.put(
      url,
      data: fileStream,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      options: Options(
        headers: {
          'Content-Length': length,
          'Content-Type': contentType,
        },
      ),
    );
  }

  @override
  Future<void> confirmUpload(String jobId) async {
    await _dio.post(ApiEndpoints.uploadConfirm(jobId));
  }
}
