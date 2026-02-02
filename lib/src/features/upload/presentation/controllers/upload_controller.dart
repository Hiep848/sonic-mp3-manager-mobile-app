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
    return null; // State null = Chưa upload (Hiện nút chọn file)
  }

  Future<void> uploadFile(File file) async {
    // 1. Reset state & Tạo token mới
    state = const AsyncData(0.0);
    _cancelToken = CancelToken();

    try {
      final useCase = ref.read(uploadFileUseCaseProvider);

      // 2. Gọi UseCase và lắng nghe Stream
      final stream = useCase.call(file, _cancelToken!);

      // 3. Vòng lặp lắng nghe từng sự kiện progress bắn ra từ UseCase
      await for (final progress in stream) {
        // Cập nhật UI
        state = AsyncData(progress);
      }

      // Khi vòng lặp kết thúc mà không lỗi -> Thành công
      state = const AsyncData(1.0);
    } catch (e, st) {
      // 4. Xử lý lỗi
      if (e is DioException && e.type == DioExceptionType.cancel) {
        state = const AsyncData(null); // Reset về trạng thái chờ nếu hủy
      } else {
        state = AsyncError(e, st);
      }
    } finally {
      _cancelToken = null; // Dọn dẹp
    }
  }

  // Hàm Hủy upload từ UI
  void cancelUpload() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel("Người dùng hủy upload");
      state = const AsyncData(null);
    }
  }
}
