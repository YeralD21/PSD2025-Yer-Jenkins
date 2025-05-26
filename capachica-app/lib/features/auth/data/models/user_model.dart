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
      id: json['id'],
      email: json['email'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      roles: List<String>.from(json['roles']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre': nombre,
      'apellidos': apellidos,
      'roles': roles,
    };
  }
}
