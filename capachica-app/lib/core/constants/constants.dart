class Constants {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  static const Duration connectTimeout = Duration(seconds: 50);
  static const Duration receiveTimeout = Duration(seconds: 50);
}
