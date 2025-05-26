// lib/features/auth/data/models/login_response.dart

/// El usuario que viene en la respuesta de login
class Usuario {
  final int id;
  final String email;
  final String nombre;
  final String apellidos;
  final List<String> roles;

  Usuario({
    required this.id,
    required this.email,
    required this.nombre,
    required this.apellidos,
    required this.roles,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      email: json['email'] as String,
      nombre: json['nombre'] as String,
      apellidos: json['apellidos'] as String,
      roles: List<String>.from(json['roles'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'nombre': nombre,
    'apellidos': apellidos,
    'roles': roles,
  };
}

/// La respuesta completa del endpoint /auth/login
class LoginResponse {
  final String accessToken;
  final Usuario usuario;

  LoginResponse({
    required this.accessToken,
    required this.usuario,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      usuario: Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'usuario': usuario.toJson(),
  };
}
