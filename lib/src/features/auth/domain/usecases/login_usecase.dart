import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

abstract interface class LoginStrategy {
  Future<UserEntity> login(
    AuthRepository repository,
    Map<String, dynamic> credentials,
  );

  void validate(Map<String, dynamic> credentials);
}

class TraditionalLoginStrategy implements LoginStrategy {
  @override
  void validate(Map<String, dynamic> credentials) {
    final email = credentials['email'] as String?;
    final password = credentials['password'] as String?;
    if (email == null || !email.contains('@')) {
      throw Exception('Email không hợp lệ');
    }
    if (password == null || password.length < 6) {
      throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
    }
  }

  @override
  Future<UserEntity> login(
    AuthRepository repository,
    Map<String, dynamic> credentials,
  ) {
    print('Email: ${credentials['email']}');
    print('Password: ${credentials['password']}');
    return repository.traditionalLogin(
      email: (credentials['email'] as String?) ?? '',
      password: (credentials['password'] as String?) ?? '',
    );
  }
}

class GoogleLoginStrategy implements LoginStrategy {
  @override
  void validate(Map<String, dynamic> credentials) {
    final authCode = credentials['authCode'] as String?;
    if (authCode == null || authCode.isEmpty) {
      throw Exception('Auth code không hợp lệ');
    }
  }

  @override
  Future<UserEntity> login(
    AuthRepository repository,
    Map<String, dynamic> credentials,
  ) {
    return repository.googleLogin(
      authCode: (credentials['authCode'] as String?) ?? '',
    );
  }
}

class LoginUseCase {
  final AuthRepository _repository;
  final LoginStrategy _strategy;

  LoginUseCase(this._repository, this._strategy);

  Future<UserEntity> call(Map<String, dynamic> credentials) async {
    _strategy.validate(credentials);
    return await _strategy.login(_repository, credentials);
  }
}
