import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String name,
  }) {
    // Validate Business Logic
    if (name.isEmpty) throw Exception('Tên không được để trống');
    if (!email.contains('@')) throw Exception('Email không hợp lệ');
    if (password.length < 6) throw Exception('Mật khẩu quá ngắn');

    return _authRepository.register(
        email: email, password: password, name: name);
  }
}
