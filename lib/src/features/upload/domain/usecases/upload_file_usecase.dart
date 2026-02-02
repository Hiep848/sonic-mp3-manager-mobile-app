import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/upload_repository_impl.dart';
import '../repositories/upload_repository.dart';

part 'upload_file_usecase.g.dart';

@riverpod
UploadFileUseCase uploadFileUseCase(UploadFileUseCaseRef ref) {
  final repository = ref.watch(uploadRepositoryProvider);
  return UploadFileUseCase(repository);
}

class UploadFileUseCase {
  final UploadRepository _repository;

  UploadFileUseCase(this._repository);
  Stream<double> call(File file, CancelToken cancelToken) {
    final controller = StreamController<double>();
    _executeUploadFlow(controller, file, cancelToken);
    return controller.stream;
  }

  Future<void> _executeUploadFlow(
    StreamController<double> controller,
    File file,
    CancelToken cancelToken,
  ) async {
    try {
      controller.add(0.0);
      final fileName = file.path.split('/').last;
      final initResponse = await _repository.initUpload(fileName);
      if (cancelToken.isCancelled) throw cancelToken.cancelError!;
      await _repository.uploadFile(
        initResponse.uploadUrl,
        file,
        cancelToken,
        (progress) {
          if (!controller.isClosed && !cancelToken.isCancelled) {
            controller.add(progress * 0.95);
          }
        },
      );

      if (cancelToken.isCancelled) throw cancelToken.cancelError!;
      controller.add(0.99);
      await _repository.confirmUpload(
          initResponse.jobId, initResponse.fileName, 0, 0);
      if (!controller.isClosed) {
        controller.add(1.0);
        await controller.close();
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
        await controller.close();
      }
    }
  }
}
