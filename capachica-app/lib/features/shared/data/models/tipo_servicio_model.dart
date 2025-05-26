class TipoServicio {
  final int? id;
  final String nombre;
  final String descripcion;
  final bool requiereCupo;

  TipoServicio({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.requiereCupo,
  });

  factory TipoServicio.fromJson(Map<String, dynamic> json) => TipoServicio(
    id: json['id'],
    nombre: json['nombre'],
    descripcion: json['descripcion'],
    requiereCupo: json['requiereCupo'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'requiereCupo': requiereCupo,
  };
}
