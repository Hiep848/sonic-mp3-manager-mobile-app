import '../../../../core/local_storage/storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _storageService;
  final TraditionalLoginStrategy _traditionalLoginStrategy;
  final GoogleLoginStrategy _googleLoginStrategy;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._storageService,
    this._traditionalLoginStrategy,
    this._googleLoginStrategy,
  );

  @override
  Future<UserEntity> traditionalLogin({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _remoteDataSource.login(
        _traditionalLoginStrategy,
        {
          'email': email,
          'password': password,
        },
      );

      await _storageService.write(
        StorageKeys.accessToken,
        authResponse.accessToken,
      );

      return authResponse.user;
    } catch (e, stacktrace) {
      print("Stack trace:\n$stacktrace");
      rethrow;
    }
  }

  @override
  Future<UserEntity> googleLogin({required String authCode}) async {
    try {
      final authResponse = await _remoteDataSource.login(
        _googleLoginStrategy,
        {'authCode': authCode},
      );

      await _storageService.write(
        StorageKeys.accessToken,
        authResponse.accessToken,
      );

      return authResponse.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final authResponse = await _remoteDataSource.registerRequest(
        email,
        password,
        name,
      );

      await _storageService.write(
        StorageKeys.accessToken,
        authResponse.accessToken,
      );

      return authResponse.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkAuthStatus() async {
    final token = await _storageService.read(StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    await _storageService.delete(StorageKeys.accessToken);
  }
}
