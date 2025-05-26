import 'package:capachica/core/storage/token_storage.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Aquí puedes agregar lógica para manejar expiración de token, etc.
    return handler.next(err);
  }
}
