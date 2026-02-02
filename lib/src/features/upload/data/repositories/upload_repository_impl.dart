import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart'; // [Cần thêm vào pubspec.yaml]
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/upload_repository.dart';
import '../datasources/upload_remote_datasource.dart';

part 'upload_repository_impl.g.dart';

@riverpod
UploadRepository uploadRepository(Ref ref) {
  return UploadRepositoryImpl(ref.watch(uploadRemoteDataSourceProvider));
}

class UploadRepositoryImpl implements UploadRepository {
  final UploadRemoteDataSource _remoteDataSource;

  UploadRepositoryImpl(this._remoteDataSource);

  @override
  Future<InitUploadResponse> initUpload(String fileName) {
    // [FIX] Dùng thư viện mime để detect chuẩn hơn
    final contentType = lookupMimeType(fileName) ?? 'application/octet-stream';
    return _remoteDataSource.initUpload(fileName, contentType);
  }

  @override
  Future<void> uploadFile(String url, File file, CancelToken cancelToken,
      Function(double) onProgress) async {
    final contentType = lookupMimeType(file.path) ?? 'application/octet-stream';
    await _remoteDataSource.uploadFileToS3(
      url: url,
      file: file, // Truyền file vào đây
      contentType: contentType,
      cancelToken: cancelToken,
      onSendProgress: (sent, total) {
        if (total > 0) {
          onProgress(sent / total);
        }
      },
    );
  }

  @override
  Future<void> confirmUpload(
      String jobId, String fileName, double duration, int fileSize) {
    return _remoteDataSource.confirmUpload(jobId, fileName, duration, fileSize);
  }

  @override
  Future<void> cancelJob(String jobId) {
    return _remoteDataSource.cancelJob(jobId);
  }
}
