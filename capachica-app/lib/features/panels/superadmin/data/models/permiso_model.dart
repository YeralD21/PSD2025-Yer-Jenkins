class Permiso {
  final int id;
  final String nombre;
  final String descripcion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RolPermiso> rolesPermisos;

  Permiso({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.createdAt,
    required this.updatedAt,
    required this.rolesPermisos,
  });

  factory Permiso.fromJson(Map<String, dynamic> json) {
    return Permiso(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'rolesPermisos': rolesPermisos.map((rp) => rp.toJson()).toList(),
    };
  }
}

class RolPermiso {
  final int id;
  final int rolId;
  final int permisoId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Rol rol;

  RolPermiso({
    required this.id,
    required this.rolId,
    required this.permisoId,
    required this.createdAt,
    required this.updatedAt,
    required this.rol,
  });

  factory RolPermiso.fromJson(Map<String, dynamic> json) {
    return RolPermiso(
      id: json['id'],
      rolId: json['rolId'],
      permisoId: json['permisoId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      rol: Rol.fromJson(json['rol']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rolId': rolId,
      'permisoId': permisoId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'rol': rol.toJson(),
    };
  }
}

class Rol {
  final int id;
  final String nombre;
  final String descripcion;
  final DateTime createdAt;
  final DateTime updatedAt;

  Rol({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
} 