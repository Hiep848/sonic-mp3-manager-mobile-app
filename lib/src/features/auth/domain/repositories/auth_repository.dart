import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  // Thêm register
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  });

  Future<bool> checkAuthStatus(); // Thêm dòng này
  Future<void> logout(); // Thêm dòng này
}
