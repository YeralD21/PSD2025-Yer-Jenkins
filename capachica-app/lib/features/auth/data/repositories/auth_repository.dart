import 'package:capachica/core/api/api_client.dart';
import 'package:dio/dio.dart';
import '../models/login_request.dart';
import '../models/user_register_request.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<Response> login(LoginRequest request) async {
    return _apiClient.post(
      '/auth/login',
      data: request.toJson(),
    );
  }

  Future<Response> register(UserRegisterRequest request) async {
    return _apiClient.post(
      '/users/register',
      data: request.toJson(),
    );
  }
}