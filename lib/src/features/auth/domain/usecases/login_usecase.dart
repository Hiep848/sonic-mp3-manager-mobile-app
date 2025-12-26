import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  // Dependency Injection: UseCase cần Repository để hoạt động
  LoginUseCase(this._authRepository);

  // Hàm call giúp class hoạt động như một hàm (Callable Class)
  // UI chỉ cần gọi: loginUseCase(email, pass)
  Future<UserEntity> call({required String email, required String password}) {
    // 1. Validate logic (Ví dụ)
    if (!email.contains('@')) {
      throw Exception('Email không hợp lệ');
    }
    if (password.length < 6) {
      throw Exception('Mật khẩu quá ngắn');
    }

    // 2. Gọi xuống tầng Repository (Data Layer)
    return _authRepository.login(email: email, password: password);
  }
}
