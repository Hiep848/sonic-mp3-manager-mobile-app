import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart'; // Import Dio
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/usecases/upload_file_usecase.dart';

part 'upload_controller.g.dart';

@riverpod
class UploadController extends _$UploadController {
  // Giữ token để có thể hủy khi cần
  CancelToken? _cancelToken;

  @override
  FutureOr<double?> build() {
    return null; // Initial state: null (Idle) -> Shows "Select File" button
  }

  Future<void> uploadFile(File file) async {
    // 1. Reset state & Tạo token  mới
    state = const AsyncData(0.0);
    _cancelToken = CancelToken();

    try {
      final useCase = ref.read(uploadFileUseCaseProvider);

      // 2. Gọi UseCase kèm Token
      final stream = useCase.call(file, _cancelToken!);

      // 3. Lắng nghe tiến độ
      await for (final progress in stream) {
        state = AsyncData(progress);
      }

      // Upload xong
      state = const AsyncData(1.0);
    } catch (e, st) {
      // 4. Nếu lỗi do user bấm Cancel -> Reset về null (Idle) hoặc 0.0
      if (e is DioException && e.type == DioExceptionType.cancel) {
        state = const AsyncData(null); // Reset to idle on cancel
      } else {
        state = AsyncError(e, st);
      }
    } finally {
      _cancelToken = null; // Dọn dẹp
    }
  }

  // Hàm Hủy
  void cancelUpload() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel("Người dùng hủy upload");
    }
  }
}
