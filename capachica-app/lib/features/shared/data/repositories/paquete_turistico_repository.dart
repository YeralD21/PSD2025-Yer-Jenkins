import 'package:dio/dio.dart';
import '../models/paquete_turistico_model.dart';

class PaqueteTuristicoRepository {
  final Dio dio;
  PaqueteTuristicoRepository(this.dio);

  Future<List<PaqueteTuristicoModel>> fetchPaquetes() async {
    final res = await dio.get('/paquetes-turisticos');
    return (res.data as List)
        .map((e) => PaqueteTuristicoModel.fromJson(e))
        .toList();
  }

  Future<PaqueteTuristicoModel> fetchPaquete(int id) async {
    final res = await dio.get('/paquetes-turisticos/$id');
    return PaqueteTuristicoModel.fromJson(res.data);
  }

  Future<void> createPaquete(PaqueteTuristicoModel paquete) async {
    await dio.post('/paquetes-turisticos', data: paquete.toJson());
  }

  Future<void> updatePaquete(PaqueteTuristicoModel paquete) async {
    await dio.patch('/paquetes-turisticos/${paquete.id}', data: paquete.toJson());
  }

  Future<void> deletePaquete(int id) async {
    await dio.delete('/paquetes-turisticos/$id');
  }
}
