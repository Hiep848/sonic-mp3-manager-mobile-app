import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_task.freezed.dart';

enum UploadStatus { pending, uploading, paused, completed, failed }

@freezed
class UploadTask with _$UploadTask {
  const factory UploadTask({
    required String id,           // UUID
    required String filePath,     // Đường dẫn file gốc trên máy
    required String fileName,
    required int fileSize,        // Tổng dung lượng (bytes)
    @Default(0) int chunksUploaded, // Đã xong bao nhiêu mảnh
    @Default(0) int totalChunks,    // Tổng số mảnh cần gửi
    @Default(UploadStatus.pending) UploadStatus status,
    String? errorMessage,
  }) = _UploadTask;
  
  // Getter tính % tiến độ
  const UploadTask._();
  double get progress => totalChunks == 0 ? 0 : chunksUploaded / totalChunks;
}