import 'secure_storage_interface.dart';
import 'flutter_secure_storage_adapter.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static SecureStorageInterface storage = FlutterSecureStorageAdapter();

  static Future<void> saveToken(String token) async {
    await storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await storage.delete(key: _tokenKey);
  }
}
