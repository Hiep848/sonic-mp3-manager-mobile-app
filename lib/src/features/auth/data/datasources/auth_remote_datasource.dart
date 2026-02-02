import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/dio_provider.dart';
import '../models/auth_response_model.dart';

part 'auth_remote_datasource.g.dart';

abstract interface class LoginStrategy {
  Future<AuthResponseModel> login(Map<String, dynamic> credentials);
}

class TraditionalLoginStrategy implements LoginStrategy {
  final Dio _dio;

  TraditionalLoginStrategy(this._dio);

  @override
  Future<AuthResponseModel> login(Map<String, dynamic> credentials) async {
    try {
      print('Performing traditional login with credentials: $credentials');
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}/auth/traditional-login',
        data: {
          'email': credentials['email'],
          'password': credentials['password'],
        },
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}

class GoogleLoginStrategy implements LoginStrategy {
  final Dio _dio;

  GoogleLoginStrategy(this._dio);

  @override
  Future<AuthResponseModel> login(Map<String, dynamic> credentials) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}/auth/google-login',
        data: {
          'code': credentials['authCode'],
        },
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}

abstract interface class AuthRemoteDataSource {
  Future<AuthResponseModel> login(
      LoginStrategy strategy, Map<String, dynamic> credentials);
  Future<AuthResponseModel> registerRequest(
      String email, String password, String name);
}

// Implementation
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthResponseModel> login(
    LoginStrategy strategy,
    Map<String, dynamic> credentials,
  ) async {
    return await strategy.login(credentials);
  }

  @override
  Future<AuthResponseModel> registerRequest(
      String email, String password, String name) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.register}',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}

@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio);
}

@riverpod
TraditionalLoginStrategy traditionalLoginStrategy(
    TraditionalLoginStrategyRef ref) {
  final dio = ref.watch(dioProvider);
  return TraditionalLoginStrategy(dio);
}

@riverpod
GoogleLoginStrategy googleLoginStrategy(GoogleLoginStrategyRef ref) {
  final dio = ref.watch(dioProvider);
  return GoogleLoginStrategy(dio);
}
