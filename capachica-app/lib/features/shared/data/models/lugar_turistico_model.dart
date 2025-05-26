class ImagenLugarTuristico {
  final String url;

  ImagenLugarTuristico({required this.url});

  factory ImagenLugarTuristico.fromJson(Map<String, dynamic> json) =>
      ImagenLugarTuristico(url: json['url']);

  Map<String, dynamic> toJson() => {'url': url};
}

class LugarTuristicoModel {
  final int? id;
  final String? nombre;
  final String? descripcion;
  final String? direccion;
  final String? coordenadas;
  final String? estado;
  final bool? esDestacado;
  final DateTime? horarioApertura;
  final DateTime? horarioCierre;
  final num? costoEntrada;
  final String? recomendaciones;
  final String? restricciones;
  final List<ImagenLugarTuristico>? imagenes;

  LugarTuristicoModel({
    this.id,
    this.nombre,
    this.descripcion,
    this.direccion,
    this.coordenadas,
    this.estado,
    this.esDestacado,
    this.horarioApertura,
    this.horarioCierre,
    this.costoEntrada,
    this.recomendaciones,
    this.restricciones,
    this.imagenes,
  });

  factory LugarTuristicoModel.fromJson(Map<String, dynamic> json) {
    return LugarTuristicoModel(
      id: json['id'],
      nombre: json['nombre'] as String?,
      descripcion: json['descripcion'] as String?,
      direccion: json['direccion'] as String?,
      coordenadas: json['coordenadas'] as String?,
      estado: json['estado'] as String?,
      esDestacado: json['esDestacado'] as bool? ?? false,
      horarioApertura: json['horarioApertura'] != null
          ? DateTime.tryParse(json['horarioApertura'])
          : null,
      horarioCierre: json['horarioCierre'] != null
          ? DateTime.tryParse(json['horarioCierre'])
          : null,
      costoEntrada: json['costoEntrada'] == null
          ? 0
          : (json['costoEntrada'] is num
              ? json['costoEntrada']
              : num.tryParse(json['costoEntrada'].toString()) ?? 0),
      recomendaciones: json['recomendaciones'] as String?,
      restricciones: json['restricciones'] as String?,
      imagenes: (json['imagenes'] as List<dynamic>?)
              ?.map((e) => ImagenLugarTuristico.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'direccion': direccion,
        'coordenadas': coordenadas,
        'estado': estado,
        'esDestacado': esDestacado,
        'horarioApertura': horarioApertura?.toIso8601String(),
        'horarioCierre': horarioCierre?.toIso8601String(),
        'costoEntrada': costoEntrada,
        'recomendaciones': recomendaciones,
        'restricciones': restricciones,
        'imagenes': imagenes?.map((e) => e.toJson()).toList(),
      };
}
