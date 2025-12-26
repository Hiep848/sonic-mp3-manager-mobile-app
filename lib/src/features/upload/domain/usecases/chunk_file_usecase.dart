import 'dart:io';
import 'dart:typed_data';
import '../entities/file_chunk.dart';

class ChunkFileUseCase {
  // Cấu hình: 1 Chunk = 1MB
  static const int chunkSize = 1024 * 1024; 

  // Hàm này trả về một Stream (Dòng chảy) các mảnh
  Stream<FileChunk> call(File file, String uploadId) async* {
    final int fileSize = await file.length();
    
    // Tính tổng số mảnh. Ví dụ 2.5MB -> ceil(2.5) = 3 mảnh
    final int totalChunks = (fileSize / chunkSize).ceil();
    
    int chunkIndex = 0;
    int offset = 0;

    // Mở file để đọc
    final accessFile = await file.open();

    try {
      while (offset < fileSize) {
        // Đọc 1MB dữ liệu
        // Nếu phần còn lại < 1MB thì chỉ đọc phần còn lại
        int sizeToRead = chunkSize;
        if (offset + sizeToRead > fileSize) {
          sizeToRead = fileSize - offset;
        }

        final List<int> data = await accessFile.read(sizeToRead);
        
        // Tạo ra 1 mảnh
        yield FileChunk(
          index: chunkIndex,
          data: Uint8List.fromList(data),
          offset: offset,
          totalChunks: totalChunks,
          uploadId: uploadId,
        );

        // Cộng dồn index và offset để cắt mảnh tiếp theo
        chunkIndex++;
        offset += sizeToRead;
      }
    } finally {
      // Nhớ đóng file sau khi đọc xong
      await accessFile.close();
    }
  }
}