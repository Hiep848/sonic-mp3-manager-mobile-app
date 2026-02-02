import 'package:flutter_test/flutter_test.dart';
// Import file usecase vừa tạo (sửa lại đường dẫn import cho đúng project của bạn)

void main() {
  test('Kiểm tra logic tính tổng số chunk', () {
    const fileSize = 1024 * 1024 * 5 + 500; // 5MB + 500 bytes
    const chunkSize = 1024 * 1024; // 1MB
    
    final totalChunks = (fileSize / chunkSize).ceil();
    
    // Mong đợi: 6 mảnh (5 mảnh full 1MB + 1 mảnh lẻ 500 bytes)
    expect(totalChunks, 6);
  });
}