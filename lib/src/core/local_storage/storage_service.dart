import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_service.g.dart';

// Key để lưu token
class StorageKeys {
  static const String accessToken = 'access_token';
}

// Interface (Abstraction)
abstract class StorageService {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> clearAll();
}

// Implementation (Concrete)
class SecureStorageServiceImpl implements StorageService {
  final FlutterSecureStorage _storage;

  // Cấu hình options cho Android và iOS
  SecureStorageServiceImpl()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions:
              IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clearAll() => _storage.deleteAll();
}

// Provider (Singleton)
@Riverpod(keepAlive: true)
StorageService storageService(StorageServiceRef ref) {
  return SecureStorageServiceImpl();
}
