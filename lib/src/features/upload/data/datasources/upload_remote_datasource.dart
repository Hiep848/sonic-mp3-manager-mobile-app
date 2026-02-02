import 'dart:convert';
import 'dart:io';

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
  final String fileName;
  final String uploadUrl;

  InitUploadResponse(
      {required this.jobId, required this.uploadUrl, required this.fileName});
}

abstract class UploadRemoteDataSource {
  Future<InitUploadResponse> initUpload(String fileName, String contentType);

  Future<void> uploadFileToS3({
    required String url,
    required File file,
    required String contentType,
    CancelToken? cancelToken,
    required Function(int, int)? onSendProgress,
  });

  Future<void> confirmUpload(
      String jobId, String fileName, double duration, int fileSize);

  Stream<Map<String, dynamic>> listenToProcessingProgress(String jobId);

  Future<void> cancelJob(String jobId);
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final Dio _dio;

  UploadRemoteDataSourceImpl(this._dio);

  @override
  Future<InitUploadResponse> initUpload(
      String fileName, String contentType) async {
    final response = await _dio.post(
      '/upload/init',
      data: {
        'filename': fileName,
        'contentType': contentType,
      },
    );
    return InitUploadResponse(
      jobId: response.data['jobId'],
      uploadUrl: response.data['presignedUrl'],
      fileName: response.data['fileName'],
    );
  }

  @override
  Future<void> uploadFileToS3({
    required String url,
    required File file,
    required String contentType,
    CancelToken? cancelToken,
    required Function(int, int)? onSendProgress,
  }) async {
    final s3Dio = Dio();
    final length = await file.length();
    final stream = file.openRead();
    await s3Dio.put(
      url,
      data: stream,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      options: Options(
        headers: {
          Headers.contentLengthHeader: length,
          Headers.contentTypeHeader: contentType,
        },
      ),
    );
  }

  @override
  Future<void> confirmUpload(
      String jobId, String fileName, double duration, int fileSize) async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        await _dio.post('/upload/confirm', data: {
          'jobId': jobId,
          'title': fileName,
          'duration': duration,
          'fileSize': fileSize,
        });
        return; // Thành công thì thoát
      } catch (e) {
        retryCount++;
        print("Confirm failed ($retryCount/$maxRetries). Error: $e");
        if (retryCount >= maxRetries) {
          rethrow;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  @override
  Stream<Map<String, dynamic>> listenToProcessingProgress(String jobId) async* {
    try {
      final response = await _dio.get(
        '/upload/progress/$jobId/stream',
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: Duration.zero,
        ),
      );
      final stream = response.data.stream as Stream<List<int>>;
      await for (final bytes in stream) {
        final String chunk = utf8.decode(bytes);
        final lines = chunk.split('\n');

        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final dataStr = line.substring(6).trim();
            if (dataStr == "Stream closed") continue;

            try {
              final json = jsonDecode(dataStr) as Map<String, dynamic>;
              yield json;
            } catch (_) {}
          }
        }
      }
    } catch (e) {
      throw Exception("SSE Connection failed: $e");
    }
  }

  @override
  Future<void> cancelJob(String jobId) async {
    try {
      await _dio.post('/upload/$jobId/cancel');
    } catch (e, st) {
      print("Error cancelling job $jobId: $e at\n $st");
    }
  }
}
