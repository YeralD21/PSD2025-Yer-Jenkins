import 'package:dio/dio.dart';
import '../models/servicio_model.dart';

class ServicioRepository {
  final Dio dio;
  ServicioRepository(this.dio);

  Future<List<ServicioModel>> fetchServicios() async {
    final response = await dio.get('/servicios');
    final data = response.data as List;
    return data
        .where((e) => e is Map)
        .map((e) => ServicioModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ServicioModel> getServicio(int id) async {
    final response = await dio.get('/servicios/$id');
    return ServicioModel.fromJson(response.data);
  }

  Future<ServicioModel> createServicio(ServicioModel servicio) async {
    final response = await dio.post('/servicios', data: servicio.toJson());
    return ServicioModel.fromJson(response.data);
  }

  Future<ServicioModel> updateServicio(ServicioModel servicio) async {
    final response = await dio.patch('/servicios/${servicio.id}', data: servicio.toJson());
    return ServicioModel.fromJson(response.data);
  }

  Future<void> deleteServicio(int id) async {
    await dio.delete('/servicios/$id');
  }
}
