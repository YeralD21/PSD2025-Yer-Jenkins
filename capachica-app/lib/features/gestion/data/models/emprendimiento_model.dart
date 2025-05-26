class Emprendimiento {
  final int id;
  final String nombre;
  final String descripcion;

  Emprendimiento({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory Emprendimiento.fromJson(Map<String, dynamic> json) {
    return Emprendimiento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
  };
}