import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/dio_provider.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_remote_datasource.g.dart';

// Interface cho DataSource (Để sau này dễ Mock khi test)
abstract class AuthRemoteDataSource {
  Future<UserEntity> loginRequest(String email, String password);
  // Thêm register
  Future<UserEntity> registerRequest(
      String email, String password, String name);
}

// Implementation (Triển khai thật)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<UserEntity> loginRequest(String email, String password) async {
    try {
      // 1. Gọi API thật (giả sử Backend quy ước như thế này)
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.login}',
        data: {
          'email': email,
          'password': password,
        },
      );

      // 2. Parse JSON thành Entity
      // response.data chính là cái Map<String, dynamic> từ server
      return UserEntity.fromJson(response.data);
    } on DioException catch (e) {
      // Xử lý lỗi từ Dio (400, 401, 500...)
      // Ở đây ta cứ ném tiếp để Repository xử lý
      throw e;
    }
  }

  @override
  Future<UserEntity> registerRequest(
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

      return UserEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw e;
    }
  }
}

// Tạo Provider cho DataSource
@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  // Lấy Dio instance từ core provider (sẽ tạo ở bước 3)
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio);
}
