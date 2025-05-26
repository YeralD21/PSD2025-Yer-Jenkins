import 'package:flutter_test/flutter_test.dart';
import 'package:capachica/core/storage/secure_storage_interface.dart';

class TestSecureStorage implements SecureStorageInterface {
  final Map<String, String> _storage = {};

  @override
  Future<String?> read({required String key}) async {
    return _storage[key];
  }

  @override
  Future<void> write({required String key, String? value}) async {
    if (value != null) {
      _storage[key] = value;
    }
  }

  @override
  Future<void> delete({required String key}) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _storage.clear();
  }
}

void setupTestSecureStorage() {
  TestWidgetsFlutterBinding.ensureInitialized();
} 