import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_state.freezed.dart';

enum UploadStage {
  idle, // Chưa làm gì
  uploading, // Đang upload S3
  confirming, // Đang gọi API confirm
  processing, // Đang xử lý AI (SSE)
  completed, // Xong
  failed // Lỗi
}

@freezed
class UploadState with _$UploadState {
  const factory UploadState({
    @Default(UploadStage.idle) UploadStage stage,
    @Default(0.0) double progress,
    String? jobId,
    String? errorMessage,
  }) = _UploadState;
}
