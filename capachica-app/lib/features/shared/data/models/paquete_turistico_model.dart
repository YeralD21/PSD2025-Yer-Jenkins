import 'package:capachica/features/shared/data/models/emprendimiento_model.dart';
import 'package:capachica/features/shared/data/models/servicio_model.dart';
import 'package:capachica/features/auth/providers/auth_provider.dart';

class PaqueteTuristicoModel {
  final int? id;
  final int? emprendimientoId;
  final String? nombre;
  final String? descripcion;
  final double? precio;
  final String? estado;
  final EmprendimientoModel? emprendimiento;
  final List<ServicioModel>? servicios;
  final List<String>? imagenes;

  PaqueteTuristicoModel({
    this.id,
    this.emprendimientoId,
    this.nombre,
    this.descripcion,
    this.precio,
    this.estado,
    this.emprendimiento,
    this.servicios,
    this.imagenes,
  });

  factory PaqueteTuristicoModel.fromJson(Map<String, dynamic> json) {
    return PaqueteTuristicoModel(
      id: json['id'],
      emprendimientoId: json['emprendimientoId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: (json['precio'] as num?)?.toDouble(),
      estado: json['estado'],
      emprendimiento: json['emprendimiento'] != null
          ? EmprendimientoModel.fromJson(json['emprendimiento'])
          : null,
      servicios: json['servicios'] != null
          ? (json['servicios'] as List)
              .map((e) {
                if (e is Map && e['servicio'] != null) {
                  return ServicioModel.fromJson(e['servicio']);
                }
                return ServicioModel.fromJson(e);
              })
              .toList()
          : [],
      imagenes: json['imagenes'] != null
          ? List<String>.from(json['imagenes'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (emprendimientoId != null) data['emprendimientoId'] = emprendimientoId;
    if (nombre != null) data['nombre'] = nombre;
    if (descripcion != null) data['descripcion'] = descripcion;
    if (precio != null) data['precio'] = precio;
    if (estado != null) data['estado'] = estado;
    if (servicios != null) {
      data['servicios'] = servicios!.map((s) => s.id).toList();
    }
    if (imagenes != null) data['imagenes'] = imagenes;
    return data;
  }

  PaqueteTuristicoModel copyWith({
    int? id,
    int? emprendimientoId,
    String? nombre,
    String? descripcion,
    double? precio,
    String? estado,
    EmprendimientoModel? emprendimiento,
    List<ServicioModel>? servicios,
    List<String>? imagenes,
  }) {
    return PaqueteTuristicoModel(
      id: id ?? this.id,
      emprendimientoId: emprendimientoId ?? this.emprendimientoId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      estado: estado ?? this.estado,
      emprendimiento: emprendimiento ?? this.emprendimiento,
      servicios: servicios ?? this.servicios,
      imagenes: imagenes ?? this.imagenes,
    );
  }
}

class ServicioPaquete {
  final int? id;
  final int? paqueteTuristicoId;
  final int? servicioId;
  final int? orden;
  final ServicioModel? servicio;

  ServicioPaquete({
    this.id,
    this.paqueteTuristicoId,
    this.servicioId,
    this.orden,
    this.servicio,
  });

  factory ServicioPaquete.fromJson(Map<String, dynamic> json) => ServicioPaquete(
    id: json['id'],
    paqueteTuristicoId: json['paqueteTuristicoId'],
    servicioId: json['servicioId'],
    orden: json['orden'],
    servicio: json['servicio'] != null ? ServicioModel.fromJson(json['servicio']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'paqueteTuristicoId': paqueteTuristicoId,
    'servicioId': servicioId,
    'orden': orden,
    'servicio': servicio?.toJson(),
  };
}

// Puedes importar o definir aquí el modelo de Servicio y Emprendimiento si no lo tienes ya en shared/models
