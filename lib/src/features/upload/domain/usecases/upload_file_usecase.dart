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

  /// Trả về một Stream tiến độ từ 0.0 đến 1.0
  Stream<double> call(File file, CancelToken cancelToken) {
    // 1. Tạo StreamController để điều khiển dòng dữ liệu
    final controller = StreamController<double>();

    // 2. Thực hiện logic trong background
    _executeUploadFlow(controller, file, cancelToken);

    // 3. Trả về stream ngay lập tức cho UI lắng nghe
    return controller.stream;
  }

  Future<void> _executeUploadFlow(
    StreamController<double> controller,
    File file,
    CancelToken cancelToken,
  ) async {
    try {
      // Bắt đầu
      controller.add(0.0);

      // --- BƯỚC 1: Init Upload ---
      final fileName = file.path.split('/').last;
      final initResponse = await _repository.initUpload(fileName);

      if (cancelToken.isCancelled) throw cancelToken.cancelError!;

      // --- BƯỚC 2: Upload to S3 ---
      // Tiến trình upload chiếm 95% tổng quá trình
      await _repository.uploadFile(
        initResponse
            .uploadUrl, // [Lưu ý] Đảm bảo field này khớp với InitUploadResponse (uploadUrl)
        file,
        cancelToken,
        (progress) {
          // Callback cập nhật tiến độ vào stream
          if (!controller.isClosed && !cancelToken.isCancelled) {
            controller.add(progress * 0.95);
          }
        },
      );

      if (cancelToken.isCancelled) throw cancelToken.cancelError!;

      // --- BƯỚC 3: Confirm Upload ---
      // Lúc này file đã lên S3, gọi confirm để trigger worker
      controller.add(0.99); // Gần xong
      await _repository.confirmUpload(initResponse.jobId);

      // Hoàn tất
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
