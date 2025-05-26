import 'permiso_model.dart';

class Rol {
  final int id;
  final String nombre;
  final String descripcion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RolPermiso> rolesPermisos;

  Rol({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.createdAt,
    required this.updatedAt,
    required this.rolesPermisos,
  });

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      rolesPermisos: (json['rolesPermisos'] as List<dynamic>? ?? [])
          .map((rp) => RolPermiso.fromJson(rp))
          .toList(),
    );
  }
}

class RolPermiso {
  final int id;
  final int rolId;
  final int permisoId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Permiso permiso;

  RolPermiso({
    required this.id,
    required this.rolId,
    required this.permisoId,
    required this.createdAt,
    required this.updatedAt,
    required this.permiso,
  });

  factory RolPermiso.fromJson(Map<String, dynamic> json) {
    return RolPermiso(
      id: json['id'],
      rolId: json['rolId'],
      permisoId: json['permisoId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      permiso: Permiso.fromJson(json['permiso']),
    );
  }
}

// Puedes importar Permiso desde tu permiso_model.dart
//import 'permiso_model.dart';