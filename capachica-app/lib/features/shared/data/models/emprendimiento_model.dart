import 'dart:convert';

class Emprendimiento {
  final int? id;
  final int usuarioId;
  final String nombre;
  final String descripcion;
  final String tipo;
  final String direccion;
  final String? coordenadas;
  final String? contactoTelefono;
  final String? contactoEmail;
  final String? sitioWeb;
  final Map<String, dynamic>? redesSociales;
  final String estado;
  final DateTime? fechaAprobacion;
  final List<EmprendimientoImagen> imagenes;

  Emprendimiento({
    this.id,
    required this.usuarioId,
    required this.nombre,
    required this.descripcion,
    required this.tipo,
    required this.direccion,
    this.coordenadas,
    this.contactoTelefono,
    this.contactoEmail,
    this.sitioWeb,
    this.redesSociales,
    required this.estado,
    this.fechaAprobacion,
    required this.imagenes,
  });

  factory Emprendimiento.fromJson(Map<String, dynamic> json) => Emprendimiento(
    id: json['id'],
    usuarioId: json['usuarioId'],
    nombre: json['nombre'] ?? '',
    descripcion: json['descripcion'] ?? '',
    tipo: json['tipo'] ?? '',
    direccion: json['direccion'] ?? '',
    coordenadas: json['coordenadas'],
    contactoTelefono: json['contactoTelefono'],
    contactoEmail: json['contactoEmail'],
    sitioWeb: json['sitioWeb'],
    redesSociales: _parseRedesSociales(json['redesSociales']),
    estado: json['estado'] ?? '',
    fechaAprobacion: json['fechaAprobacion'] != null
        ? DateTime.tryParse(json['fechaAprobacion'])
        : null,
    imagenes: (json['imagenes'] as List<dynamic>?)
        ?.map((e) => EmprendimientoImagen.fromJson(e))
        .toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuarioId': usuarioId,
    'nombre': nombre,
    'descripcion': descripcion,
    'tipo': tipo,
    'direccion': direccion,
    'coordenadas': coordenadas,
    'contactoTelefono': contactoTelefono,
    'contactoEmail': contactoEmail,
    'sitioWeb': sitioWeb != null && sitioWeb!.isNotEmpty ? sitioWeb : null,
    'redesSociales': redesSociales != null ? jsonEncode(redesSociales) : null,
    'estado': estado,
    'fechaAprobacion': fechaAprobacion?.toIso8601String(),
    'imagenes': imagenes.map((e) => e.toJson()).toList(),
  };

  static Map<String, dynamic>? _parseRedesSociales(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is String && value.isNotEmpty) {
      try {
        return Map<String, dynamic>.from(jsonDecode(value));
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}

class EmprendimientoImagen {
  final String url;

  EmprendimientoImagen({required this.url});

  factory EmprendimientoImagen.fromJson(Map<String, dynamic> json) =>
      EmprendimientoImagen(url: json['url']);

  Map<String, dynamic> toJson() => {'url': url};
}

class EmprendimientoModel {
  final int? id;
  final int usuarioId;
  final String nombre;
  final String descripcion;
  final String tipo;
  final String direccion;
  final String? coordenadas;
  final String? contactoTelefono;
  final String? contactoEmail;
  final String? sitioWeb;
  final Map<String, String> redesSociales;
  final String estado;
  final DateTime? fechaAprobacion;
  final List<ImagenModel> imagenes;

  EmprendimientoModel({
    this.id,
    required this.usuarioId,
    required this.nombre,
    required this.descripcion,
    required this.tipo,
    required this.direccion,
    this.coordenadas,
    this.contactoTelefono,
    this.contactoEmail,
    this.sitioWeb,
    required this.redesSociales,
    required this.estado,
    this.fechaAprobacion,
    this.imagenes = const [],
  });

  factory EmprendimientoModel.fromJson(Map<String, dynamic> json) {
    return EmprendimientoModel(
      id: json['id'],
      usuarioId: json['usuarioId'],
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      tipo: json['tipo'] ?? '',
      direccion: json['direccion'] ?? '',
      coordenadas: json['coordenadas'],
      contactoTelefono: json['contactoTelefono'],
      contactoEmail: json['contactoEmail'],
      sitioWeb: json['sitioWeb'],
      redesSociales: _parseRedesSociales(json['redesSociales']),
      estado: json['estado'] ?? '',
      fechaAprobacion: json['fechaAprobacion'] != null
          ? DateTime.tryParse(json['fechaAprobacion'])
          : null,
      imagenes: (json['imagenes'] as List<dynamic>?)
              ?.map((img) => ImagenModel.fromJson(img))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'usuarioId': usuarioId,
      'nombre': nombre,
      'descripcion': descripcion,
      'tipo': tipo,
      'direccion': direccion,
      'coordenadas': coordenadas,
      'contactoTelefono': contactoTelefono,
      'contactoEmail': contactoEmail,
      'sitioWeb': sitioWeb,
      'redesSociales': redesSociales,
      'estado': estado,
      'fechaAprobacion': fechaAprobacion?.toIso8601String(),
      'imagenes': imagenes.map((img) => img.toJson()).toList(),
    };
  }

  EmprendimientoModel copyWith({
    int? id,
    int? usuarioId,
    String? nombre,
    String? descripcion,
    String? tipo,
    String? direccion,
    String? coordenadas,
    String? contactoTelefono,
    String? contactoEmail,
    String? sitioWeb,
    Map<String, String>? redesSociales,
    String? estado,
    DateTime? fechaAprobacion,
    List<ImagenModel>? imagenes,
  }) {
    return EmprendimientoModel(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      direccion: direccion ?? this.direccion,
      coordenadas: coordenadas ?? this.coordenadas,
      contactoTelefono: contactoTelefono ?? this.contactoTelefono,
      contactoEmail: contactoEmail ?? this.contactoEmail,
      sitioWeb: sitioWeb ?? this.sitioWeb,
      redesSociales: redesSociales ?? this.redesSociales,
      estado: estado ?? this.estado,
      fechaAprobacion: fechaAprobacion ?? this.fechaAprobacion,
      imagenes: imagenes ?? this.imagenes,
    );
  }

  static Map<String, String> _parseRedesSociales(dynamic value) {
    if (value == null) return {};
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
    }
    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map) {
          return decoded.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
        }
      } catch (_) {
        return {};
      }
    }
    return {};
  }
}

class ImagenModel {
  final String url;

  ImagenModel({required this.url});

  factory ImagenModel.fromJson(Map<String, dynamic> json) {
    return ImagenModel(
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}