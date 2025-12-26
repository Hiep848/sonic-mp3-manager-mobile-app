import '../entities/file_chunk.dart';

abstract class UploadRepository {
  Future<String> initUpload(String fileName, int fileSize);
  Future<void> uploadChunk(FileChunk chunk);
  Future<String> completeUpload(String uploadId);
}
