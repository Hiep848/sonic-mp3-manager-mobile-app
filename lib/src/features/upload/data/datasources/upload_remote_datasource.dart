import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/dio_provider.dart';

// Dòng này cực quan trọng để sinh code provider
part 'upload_remote_datasource.g.dart';

abstract class UploadRemoteDataSource {
  // Bước 1: Khởi tạo, trả về uploadId
  Future<String> initUpload(String fileName, int fileSize);

  // Bước 2: Gửi từng mảnh
  Future<void> uploadChunk({
    required String uploadId,
    required int chunkIndex,
    required List<int> data, // Binary data
  });

  // Bước 3: Hoàn tất, trả về URL file
  Future<String> completeUpload(String uploadId);
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final Dio _dio;

  UploadRemoteDataSourceImpl(this._dio);

  @override
  Future<String> initUpload(String fileName, int fileSize) async {
    final response = await _dio.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.uploadInit}',
      data: {
        'fileName': fileName,
        'fileSize': fileSize,
      },
    );
    // Giả sử server trả về: { "uploadId": "xyz-123" }
    return response.data['uploadId'];
  }

  @override
  Future<void> uploadChunk({
    required String uploadId,
    required int chunkIndex,
    required List<int> data,
  }) async {
    // Gửi binary thường dùng FormData
    final formData = FormData.fromMap({
      'uploadId': uploadId,
      'chunkIndex': chunkIndex,
      // MultipartFile.fromBytes là cách gửi binary chuẩn trong Dio
      'chunkData': MultipartFile.fromBytes(data, filename: 'chunk_$chunkIndex'),
    });

    await _dio.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.uploadChunk}',
      data: formData,
    );
  }

  @override
  Future<String> completeUpload(String uploadId) async {
    final response = await _dio.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.uploadComplete}',
      data: {'uploadId': uploadId},
    );
    // Giả sử server trả về: { "fileUrl": "https://..." }
    return response.data['fileUrl'];
  }
}

// Đây là Provider sẽ được sinh ra
@riverpod
UploadRemoteDataSource uploadRemoteDataSource(UploadRemoteDataSourceRef ref) {
  return UploadRemoteDataSourceImpl(ref.watch(dioProvider));
}
