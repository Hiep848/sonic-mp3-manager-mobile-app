import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_endpoints.dart';
import '../local_storage/storage_service.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  // Cấu hình BaseOptions cho toàn bộ app
  final options = BaseOptions(
    baseUrl: ApiEndpoints.baseUrl, // URL giả định
    connectTimeout: ApiEndpoints.connectionTimeout,
    receiveTimeout: ApiEndpoints.receiveTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final dio = Dio(options);
  final storageService = ref.watch(storageServiceProvider);

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Add token if available
      final token = await storageService.read(StorageKeys.accessToken);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));

  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  return dio;
}
