import 'dart:io';
import '../repositories/upload_repository.dart';
import 'chunk_file_usecase.dart';

class UploadFileUseCase {
  final UploadRepository _repository;
  final ChunkFileUseCase _chunkFileUseCase;

  UploadFileUseCase(this._repository, this._chunkFileUseCase);

  // Hàm trả về Stream<double> thể hiện tiến độ (0.0 đến 1.0)
  Stream<double> call(File file) async* {
    final fileName = file.path.split('/').last;
    final fileSize = await file.length();

    // BƯỚC 1: INIT
    // Báo hiệu bắt đầu (0%)
    yield 0.0;
    final uploadId = await _repository.initUpload(fileName, fileSize);

    // BƯỚC 2 & 3: CHUNK LOOP (Cắt đến đâu gửi đến đó)
    // Lấy stream các mảnh từ ChunkFileUseCase
    final chunkStream = _chunkFileUseCase.call(file, uploadId);

    int chunksSent = 0;

    // Lắng nghe từng mảnh được cắt ra
    await for (final chunk in chunkStream) {
      // Gửi mảnh lên server
      await _repository.uploadChunk(chunk);

      chunksSent++;

      // Tính toán tiến độ
      // progress = số mảnh đã gửi / tổng số mảnh
      final progress = chunksSent / chunk.totalChunks;

      // Báo cáo tiến độ về UI (Ví dụ: 0.1, 0.2, ... 0.99)
      yield progress;
    }

    // BƯỚC 4: COMPLETE
    await _repository.completeUpload(uploadId);

    // Báo hiệu hoàn tất (100%)
    yield 1.0;
  }
}
