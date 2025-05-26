import 'disponibilidad_model.dart';

class ServicioModel {
  final int? id;
  final int tipoServicioId;
  final String nombre;
  final String descripcion;
  final num precioBase;
  final String moneda;
  final String estado;
  final DetallesServicio detallesServicio;
  final List<ServicioImagen> imagenes;

  ServicioModel({
    this.id,
    required this.tipoServicioId,
    required this.nombre,
    required this.descripcion,
    required this.precioBase,
    required this.moneda,
    required this.estado,
    required this.detallesServicio,
    required this.imagenes,
  });

  factory ServicioModel.fromJson(Map<String, dynamic> json) {
    return ServicioModel(
      id: json['id'],
      tipoServicioId: json['tipoServicioId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precioBase: json['precioBase'] is String
          ? double.tryParse(json['precioBase']) ?? 0.0
          : (json['precioBase'] as num?)?.toDouble() ?? 0.0,
      moneda: json['moneda'],
      estado: json['estado'],
      detallesServicio: json['detallesServicio'] != null
          ? DetallesServicio.fromJson(json['detallesServicio'])
          : DetallesServicio(),
      imagenes: (json['imagenes'] as List?)
          ?.map((e) => ServicioImagen.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'tipoServicioId': tipoServicioId,
    'nombre': nombre,
    'descripcion': descripcion,
    'precioBase': precioBase,
    'moneda': moneda,
    'estado': estado,
    'detallesServicio': detallesServicio.toJson(),
    'imagenes': imagenes.map((e) => e.toJson()).toList(),
  };
}

class DetallesServicio {
  final String? duracion;
  final int? capacidad;
  final List<String>? incluye;
  final List<String>? requisitos;

  DetallesServicio({
    this.duracion,
    this.capacidad,
    this.incluye,
    this.requisitos,
  });

  factory DetallesServicio.fromJson(Map<String, dynamic> json) => DetallesServicio(
    duracion: json['duracion'],
    capacidad: json['capacidad'],
    incluye: json['incluye'] != null ? List<String>.from(json['incluye']) : null,
    requisitos: json['requisitos'] != null ? List<String>.from(json['requisitos']) : null,
  );

  Map<String, dynamic> toJson() => {
    'duracion': duracion,
    'capacidad': capacidad,
    'incluye': incluye,
    'requisitos': requisitos,
  };
}

class ServicioImagen {
  final String url;

  ServicioImagen({required this.url});

  factory ServicioImagen.fromJson(Map<String, dynamic> json) =>
      ServicioImagen(url: json['url']);

  Map<String, dynamic> toJson() => {'url': url};
}

class TipoServicioModel {
  final int? id;
  final String? nombre;
  final String? descripcion;

  TipoServicioModel({
    this.id,
    this.nombre,
    this.descripcion,
  });

  factory TipoServicioModel.fromJson(Map<String, dynamic> json) {
    return TipoServicioModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}

class DisponibilidadModel {
  final int? id;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final int? capacidad;
  final double? precio;

  DisponibilidadModel({
    this.id,
    this.fechaInicio,
    this.fechaFin,
    this.capacidad,
    this.precio,
  });

  factory DisponibilidadModel.fromJson(Map<String, dynamic> json) {
    return DisponibilidadModel(
      id: json['id'],
      fechaInicio: json['fecha_inicio'] != null 
          ? DateTime.parse(json['fecha_inicio'])
          : null,
      fechaFin: json['fecha_fin'] != null 
          ? DateTime.parse(json['fecha_fin'])
          : null,
      capacidad: json['capacidad'],
      precio: json['precio']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_inicio': fechaInicio?.toIso8601String(),
      'fecha_fin': fechaFin?.toIso8601String(),
      'capacidad': capacidad,
      'precio': precio,
    };
  }
}
