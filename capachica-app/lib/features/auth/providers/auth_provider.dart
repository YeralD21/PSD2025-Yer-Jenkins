import 'package:capachica/core/api/api_client.dart';
import 'package:capachica/core/storage/token_storage.dart';
import 'package:capachica/features/auth/data/models/login_request.dart';
import 'package:capachica/features/auth/data/models/login_response.dart';
import 'package:capachica/features/auth/data/models/user_register_request.dart';
import 'package:capachica/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated, error }

class Usuario {
  final int id;
  final String nombre;
  final String email;
  final String rol;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      rol: (json['roles'] != null && json['roles'].isNotEmpty)
          ? json['roles'][0]
          : '',
    );
  }
}

class AuthProvider with ChangeNotifier {
  final AuthRepository _repository;
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _errorMessage;
  String? _userRole;
  Usuario? _usuario;
  String? _token;

  String? get userRole => _userRole;
  Usuario? get usuario => _usuario;
  String? get token => _token;

  AuthProvider(ApiClient apiClient) : _repository = AuthRepository(apiClient) {
    _checkToken();
  }

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> _checkToken() async {
    final token = await TokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      _token = token;
      _status = AuthStatus.authenticated;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.login(
        LoginRequest(email: email, password: password),
      );

      if (response.statusCode == 200 && response.data != null) {
        final loginResp = LoginResponse.fromJson(response.data);
        await TokenStorage.saveToken(loginResp.accessToken);
        _token = loginResp.accessToken;

        if (loginResp.usuario.roles.isNotEmpty) {
          _userRole = loginResp.usuario.roles[0];
        }

        _usuario = Usuario(
          id: loginResp.usuario.id,
          nombre: loginResp.usuario.nombre,
          email: loginResp.usuario.email,
          rol: _userRole ?? '',
        );

        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Formato de respuesta inesperado';
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      _status = AuthStatus.error;
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          _errorMessage = 'Credenciales incorrectas';
        } else if (e.response!.statusCode == 500) {
          _errorMessage = 'Error en el servidor';
        } else {
          _errorMessage = 'Error: ${e.response!.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        _errorMessage = 'Tiempo de conexión agotado';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        _errorMessage = 'Tiempo de respuesta agotado';
      } else {
        _errorMessage = 'Error de conexión: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Error inesperado: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String nombre,
    required String apellidos,
    required String telefono,
    required String direccion,
    required String fotoPerfilUrl,
    required DateTime fechaNacimiento,
    required int subdivisionId,
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.register(
        UserRegisterRequest(
          nombre: nombre,
          apellidos: apellidos,
          telefono: telefono,
          direccion: direccion,
          fotoPerfilUrl: fotoPerfilUrl,
          fechaNacimiento: fechaNacimiento,
          subdivisionId: subdivisionId,
          email: email,
          password: password,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['token'] != null) {
          final token = response.data['token'];
          await TokenStorage.saveToken(token);
          _token = token;
          _status = AuthStatus.authenticated;
        } else {
          _status = AuthStatus.unauthenticated;
        }
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Error en el registro';
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      _status = AuthStatus.error;
      if (e.response != null && e.response!.data != null) {
        _errorMessage = e.response!.data['message'] ?? 'Error en el registro';
      } else {
        _errorMessage = 'Error en el registro: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Error inesperado: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await TokenStorage.deleteToken();
    _usuario = null;
    _token = null;
    _status = AuthStatus.unauthenticated;
    _userRole = null;
    notifyListeners();
  }

  void setUsuario(Usuario usuario) {
    _usuario = usuario;
    _status = AuthStatus.authenticated;
    notifyListeners();
  }
}