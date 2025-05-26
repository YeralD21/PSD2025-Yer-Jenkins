import 'package:dio/dio.dart';
import '../models/disponibilidad_model.dart';
import 'package:capachica/features/shared/data/models/disponibilidad_model.dart';

class DisponibilidadRepository {
  final Dio dio;
  DisponibilidadRepository(this.dio);

  Future<List<DisponibilidadModel>> getDisponibilidades() async {
    final response = await dio.get('/disponibilidad');
    return (response.data as List)
        .map((e) => DisponibilidadModel.fromJson(e))
        .toList();
  }

  Future<List<DisponibilidadModel>> getDisponibilidadesPorServicio(int servicioId) async {
    final response = await dio.get('/disponibilidad/servicio/$servicioId');
    return (response.data as List)
        .map((e) => DisponibilidadModel.fromJson(e))
        .toList();
  }

  Future<DisponibilidadModel> getDisponibilidad(int id) async {
    final response = await dio.get('/disponibilidad/$id');
    return DisponibilidadModel.fromJson(response.data);
  }

  Future<DisponibilidadModel> createDisponibilidad(DisponibilidadModel d) async {
    final response = await dio.post('/disponibilidad', data: d.toJson());
    return DisponibilidadModel.fromJson(response.data);
  }

  Future<DisponibilidadModel> updateDisponibilidad(DisponibilidadModel disponibilidad) async {
    final response = await dio.patch('/disponibilidad/${disponibilidad.id}', data: disponibilidad.toJson());
    return DisponibilidadModel.fromJson(response.data);
  }

  Future<void> deleteDisponibilidad(int id) async {
    await dio.delete('/disponibilidad/$id');
  }
}
