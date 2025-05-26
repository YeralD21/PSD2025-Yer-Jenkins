class DisponibilidadModel {
  final int? id;
  final int? servicioId;
  final String? fecha; // formato 'YYYY-MM-DD'
  final int? cuposDisponibles;
  final double? precioEspecial;

  DisponibilidadModel({
    this.id,
    this.servicioId,
    this.fecha,
    this.cuposDisponibles,
    this.precioEspecial,
  });

  factory DisponibilidadModel.fromJson(Map<String, dynamic> json) {
    return DisponibilidadModel(
      id: json['id'],
      servicioId: json['servicioId'],
      fecha: json['fecha'],
      cuposDisponibles: json['cuposDisponibles'] is String
          ? int.tryParse(json['cuposDisponibles']) ?? 0
          : (json['cuposDisponibles'] as int?),
      precioEspecial: json['precioEspecial'] is String
          ? double.tryParse(json['precioEspecial']) ?? 0.0
          : (json['precioEspecial'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'servicioId': servicioId,
      'fecha': fecha,
      'cuposDisponibles': cuposDisponibles,
      'precioEspecial': precioEspecial,
    };
  }
}
