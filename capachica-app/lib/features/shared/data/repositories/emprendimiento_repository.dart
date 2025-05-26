import 'package:dio/dio.dart';
import '../models/emprendimiento_model.dart';
import 'dart:convert';

class EmprendimientoRepository {
  final Dio dio;

  EmprendimientoRepository(this.dio);

  Future<List<EmprendimientoModel>> fetchEmprendimientos() async {
    final response = await dio.get('/emprendimientos');
    return (response.data as List)
        .map((e) => EmprendimientoModel.fromJson(e))
        .toList();
  }

  Future<EmprendimientoModel> getEmprendimiento(int id) async {
    final response = await dio.get('/emprendimientos/$id');
    return EmprendimientoModel.fromJson(response.data);
  }

  Future<EmprendimientoModel> createEmprendimiento(EmprendimientoModel nuevo) async {
    final data = nuevo.toJson();
    data['redesSociales'] = jsonEncode(data['redesSociales']);

    final response = await dio.post('/emprendimientos', data: data);
    return EmprendimientoModel.fromJson(response.data);
  }

  Future<EmprendimientoModel> updateEmprendimiento(EmprendimientoModel nuevo) async {
    final data = nuevo.toJson();
    data['redesSociales'] = jsonEncode(data['redesSociales']);

    final response = await dio.patch('/emprendimientos/${nuevo.id}', data: data);
    return EmprendimientoModel.fromJson(response.data);
  }

  Future<void> deleteEmprendimiento(int id) async {
    await dio.delete('/emprendimientos/$id');
  }
}
