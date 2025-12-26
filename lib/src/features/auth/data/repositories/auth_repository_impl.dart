import '../../../../core/local_storage/storage_service.dart'; // Import Storage
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _storageService; // Inject thêm cái này

  AuthRepositoryImpl(this._remoteDataSource, this._storageService);

  @override
  Future<UserEntity> login(
      {required String email, required String password}) async {
    try {
      // 1. Gọi API
      final user = await _remoteDataSource.loginRequest(email, password);

      // 2. [QUAN TRỌNG] Lưu Token vào Secure Storage
      // Giả sử API trả về token trong field 'token' (nếu Entity chưa có thì ta giả định)
      // Tạm thời ta lưu 1 token giả định để test logic persistence
      await _storageService.write(
          StorageKeys.accessToken, 'fake_jwt_token_saved');

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> register(
      {required String email,
      required String password,
      required String name}) async {
    try {
      // 1. Gọi API đăng ký
      final user =
          await _remoteDataSource.registerRequest(email, password, name);

      // 2. Đăng ký xong thì coi như login luôn -> Lưu Token
      await _storageService.write(
          StorageKeys.accessToken, 'fake_register_token');

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Thêm hàm này để kiểm tra lúc mở app
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
