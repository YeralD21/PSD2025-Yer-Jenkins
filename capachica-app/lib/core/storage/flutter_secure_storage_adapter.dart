import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage_interface.dart';

class FlutterSecureStorageAdapter implements SecureStorageInterface {
  final FlutterSecureStorage _storage;

  FlutterSecureStorageAdapter() : _storage = const FlutterSecureStorage();

  @override
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> write({required String key, String? value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
} 