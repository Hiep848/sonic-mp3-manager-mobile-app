import '../../domain/entities/file_chunk.dart';
import '../../domain/repositories/upload_repository.dart';

import '../datasources/upload_remote_datasource.dart';

class UploadRepositoryImpl implements UploadRepository {
  final UploadRemoteDataSource _dataSource;

  UploadRepositoryImpl(this._dataSource);

  @override
  Future<String> initUpload(String fileName, int fileSize) {
    return _dataSource.initUpload(fileName, fileSize);
  }

  @override
  Future<void> uploadChunk(FileChunk chunk) {
    return _dataSource.uploadChunk(
      uploadId: chunk.uploadId,
      chunkIndex: chunk.index,
      data: chunk.data,
    );
  }

  @override
  Future<String> completeUpload(String uploadId) {
    return _dataSource.completeUpload(uploadId);
  }
}
