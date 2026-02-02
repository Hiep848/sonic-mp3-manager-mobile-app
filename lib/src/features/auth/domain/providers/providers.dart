import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/local_storage/storage_service.dart';
import '../../data/datasources/auth_remote_datasource.dart' as data;
import '../../data/repositories/auth_repository_impl.dart';
import '../repositories/auth_repository.dart';
import '../usecases/login_usecase.dart' as usecase;
import '../usecases/logout_usecase.dart';
import '../usecases/register_usecase.dart';

part 'providers.g.dart';

// Repository Provider
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final dataSource = ref.watch(data.authRemoteDataSourceProvider);
  final storage = ref.watch(storageServiceProvider);

  // Use Data strategies for Repository
  final traditionalStrategy = ref.watch(data.traditionalLoginStrategyProvider);
  final googleStrategy = ref.watch(data.googleLoginStrategyProvider);

  return AuthRepositoryImpl(
    dataSource,
    storage,
    traditionalStrategy,
    googleStrategy,
  );
}

// Domain Strategy Providers
// Renamed to avoid conflict with Data strategy providers
@riverpod
usecase.TraditionalLoginStrategy usecaseTraditionalLoginStrategy(
    UsecaseTraditionalLoginStrategyRef ref) {
  return usecase.TraditionalLoginStrategy();
}

@riverpod
usecase.GoogleLoginStrategy usecaseGoogleLoginStrategy(
    UsecaseGoogleLoginStrategyRef ref) {
  return usecase.GoogleLoginStrategy();
}

// UseCase Providers
@riverpod
usecase.LoginUseCase traditionalLoginUseCase(TraditionalLoginUseCaseRef ref) {
  final repository = ref.watch(authRepositoryProvider);
  final strategy = ref.watch(usecaseTraditionalLoginStrategyProvider);
  return usecase.LoginUseCase(repository, strategy);
}

@riverpod
usecase.LoginUseCase googleLoginUseCase(GoogleLoginUseCaseRef ref) {
  final repository = ref.watch(authRepositoryProvider);
  final strategy = ref.watch(usecaseGoogleLoginStrategyProvider);
  return usecase.LoginUseCase(repository, strategy);
}

// Other UseCases
@riverpod
RegisterUseCase registerUseCase(RegisterUseCaseRef ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(LogoutUseCaseRef ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}
