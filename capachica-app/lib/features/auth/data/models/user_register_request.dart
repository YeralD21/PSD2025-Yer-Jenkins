class UserRegisterRequest {
  final String nombre;
  final String apellidos;
  final String telefono;
  final String direccion;
  final String fotoPerfilUrl;
  final DateTime fechaNacimiento;
  final int subdivisionId;
  final String email;
  final String password;

  UserRegisterRequest({
    required this.nombre,
    required this.apellidos,
    required this.telefono,
    required this.direccion,
    required this.fotoPerfilUrl,
    required this.fechaNacimiento,
    required this.subdivisionId,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'apellidos': apellidos,
    'telefono': telefono,
    'direccion': direccion,
    'fotoPerfilUrl': fotoPerfilUrl,
    'fechaNacimiento': fechaNacimiento.toIso8601String(),
    'subdivisionId': subdivisionId,
    'email': email,
    'password': password,
  };
}
