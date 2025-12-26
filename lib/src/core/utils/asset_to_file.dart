import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

Future<File> loadAssetFile(String path, String filename) async {
  // 1. Lấy dữ liệu dạng byte từ assets
  final bytes = await rootBundle.load(path);

  // 2. Lấy đường dẫn thư mục tạm của hệ thống
  final dir = await getTemporaryDirectory();

  // 3. Tạo file thật
  final file = File('${dir.path}/$filename');

  // 4. Ghi dữ liệu vào file
  await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

  return file;
}
