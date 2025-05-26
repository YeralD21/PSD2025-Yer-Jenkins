import '../api/interceptor/api_interceptor.dart';
import '../constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    // Configurar cliente Dio con opciones más permisivas para desarrollo
    dio = Dio(BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: Constants.connectTimeout,
      receiveTimeout: Constants.receiveTimeout,
      validateStatus: (status) {
        // Acepta cualquier código de estado para poder depurar
        return true;
      },
    ));

    // Añadir interceptor personalizado
    dio.interceptors.add(ApiInterceptor());

    // Añadir interceptor de registro para depuración
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (obj) {
            print("DIO LOG: $obj");
          }
      ));
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      debugPrint('GET Request: $path, Params: $queryParameters');
      final response = await dio.get(path, queryParameters: queryParameters);
      _logResponse('GET', path, response);
      return response;
    } catch (e) {
      _logError('GET', path, e);
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      debugPrint('POST Request: $path, Data: $data');
      final response = await dio.post(path, data: data);
      _logResponse('POST', path, response);
      return response;
    } catch (e) {
      _logError('POST', path, e);
      rethrow;
    }
  }

  void _logResponse(String method, String path, Response response) {
    if (kDebugMode) {
      print('[$method] $path → Status: ${response.statusCode}');
      print('Response: ${response.data}');
    }
  }

  void _logError(String method, String path, dynamic error) {
    if (kDebugMode) {
      print('[$method] $path → ERROR: $error');
      if (error is DioException) {
        print('Error Type: ${error.type}');
        print('Error Message: ${error.message}');
        if (error.response != null) {
          print('Error Status: ${error.response!.statusCode}');
          print('Error Response: ${error.response!.data}');
        }
        if (error.error != null) {
          print('Error Details: ${error.error}');
        }
      }
    }
  }

// Puedes agregar más métodos: put, delete, etc.
}
