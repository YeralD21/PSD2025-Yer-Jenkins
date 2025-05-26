abstract class SecureStorageInterface {
  Future<String?> read({required String key});
  Future<void> write({required String key, String? value});
  Future<void> delete({required String key});
  Future<void> deleteAll();
} 