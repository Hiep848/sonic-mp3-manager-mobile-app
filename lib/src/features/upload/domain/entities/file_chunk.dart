import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_chunk.freezed.dart';

@freezed
class FileChunk with _$FileChunk {
  const factory FileChunk({
    required int index,          // Số thứ tự mảnh (0, 1, 2...)
    required Uint8List data,     // Dữ liệu binary của mảnh này
    required int offset,         // Vị trí bắt đầu trong file gốc
    required int totalChunks,    // Tổng số mảnh
    required String uploadId,    // ID của phiên upload
  }) = _FileChunk;
}