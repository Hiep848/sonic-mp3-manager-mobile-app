import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<UserEntity> traditionalLogin({
    required String email,
    required String password,
  });

  Future<UserEntity> googleLogin({required String authCode});

  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  });

  Future<bool> checkAuthStatus();

  Future<void> logout();
}
