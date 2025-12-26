import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/datasources/upload_remote_datasource.dart';
import '../data/repositories/upload_repository_impl.dart';
import 'repositories/upload_repository.dart';
import 'usecases/chunk_file_usecase.dart';
import 'usecases/upload_file_usecase.dart';

part 'providers.g.dart';

// 1. Repository Provider
@riverpod
UploadRepository uploadRepository(UploadRepositoryRef ref) {
  final dataSource = ref.watch(uploadRemoteDataSourceProvider);
  return UploadRepositoryImpl(dataSource);
}

// 2. ChunkFileUseCase Provider (Logic cắt file)
@riverpod
ChunkFileUseCase chunkFileUseCase(ChunkFileUseCaseRef ref) {
  return ChunkFileUseCase();
}

// 3. UploadFileUseCase Provider (Nhạc trưởng)
@riverpod
UploadFileUseCase uploadFileUseCase(UploadFileUseCaseRef ref) {
  final repo = ref.watch(uploadRepositoryProvider);
  final chunker = ref.watch(chunkFileUseCaseProvider);
  return UploadFileUseCase(repo, chunker);
}
