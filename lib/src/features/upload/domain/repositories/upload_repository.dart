import 'dart:io';
import 'package:dio/dio.dart';
import '../../data/datasources/upload_remote_datasource.dart';

abstract class UploadRepository {
  Future<InitUploadResponse> initUpload(String fileName);

  Future<void> uploadFile(String url, File file, CancelToken cancelToken, Function(double) onProgress);

  Future<void> confirmUpload(String jobId);
}
