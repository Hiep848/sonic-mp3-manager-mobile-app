import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // Determine content type simply based on extension or default to binary
    // Better implementation would use mime package
    String contentType = 'application/octet-stream';
    if (fileName.endsWith('.mp3')) {
      contentType = 'audio/mpeg';
    } else if (fileName.endsWith('.m4a')) {
      contentType = 'audio/mp4';
    } else if (fileName.endsWith('.wav')) {
      contentType = 'audio/wav';
    }
    
    return _remoteDataSource.initUpload(fileName, contentType);
  }

  @override
  Future<void> uploadFile(
      String url, File file, CancelToken cancelToken, Function(double) onProgress) async {
    final length = await file.length();
    final stream = file.openRead();

    // Determine content type again (should match init)
    String contentType = 'application/octet-stream';
    final path = file.path;
    if (path.endsWith('.mp3')) {
      contentType = 'audio/mpeg';
    } else if (path.endsWith('.m4a')) {
      contentType = 'audio/mp4';
    } else if (path.endsWith('.wav')) {
      contentType = 'audio/wav';
    }

    await _remoteDataSource.uploadFileToS3(
      url: url,
      fileStream: stream,
      length: length,
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
  Future<void> confirmUpload(String jobId) {
    return _remoteDataSource.confirmUpload(jobId);
  }
}
