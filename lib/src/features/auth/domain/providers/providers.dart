import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../repositories/auth_repository.dart';
import '../usecases/login_usecase.dart';
import '../usecases/register_usecase.dart'; // Import
import '../usecases/logout_usecase.dart'; // Import
import '../../../../core/local_storage/storage_service.dart'; // Import

part 'providers.g.dart';

// [SỬA ĐOẠN NÀY]
// Thay vì throw UnimplementedError, giờ ta trả về Implementation thật
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  // Lấy datasource từ provider đã tạo ở Bước 1
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  final storage = ref.watch(storageServiceProvider); // Lấy storage service

  return AuthRepositoryImpl(dataSource, storage); // Truyền vào Impl
}

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
}

// Register UseCase provider
@riverpod
RegisterUseCase registerUseCase(RegisterUseCaseRef ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
}

// Logout UseCase provider
@riverpod
LogoutUseCase logoutUseCase(LogoutUseCaseRef ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}
