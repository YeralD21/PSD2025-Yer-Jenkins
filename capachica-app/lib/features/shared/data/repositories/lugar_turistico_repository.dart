import 'package:dio/dio.dart';
import '../models/lugar_turistico_model.dart';

class LugarTuristicoRepository {
  final Dio dio;
  final String baseUrl;

  LugarTuristicoRepository({required this.dio, this.baseUrl = 'http://10.0.2.2:3000'});

  Future<List<LugarTuristicoModel>> fetchLugares() async {
    final res = await dio.get('$baseUrl/lugares-turisticos');
    return (res.data as List)
        .map((e) => LugarTuristicoModel.fromJson(e))
        .toList();
  }

  Future<List<LugarTuristicoModel>> fetchDestacados() async {
    final res = await dio.get('$baseUrl/lugares-turisticos/destacados');
    return (res.data as List)
        .map((e) => LugarTuristicoModel.fromJson(e))
        .toList();
  }

  Future<LugarTuristicoModel> fetchById(int id) async {
    final res = await dio.get('$baseUrl/lugares-turisticos/$id');
    return LugarTuristicoModel.fromJson(res.data);
  }

  Future<LugarTuristicoModel> create(LugarTuristicoModel lugar, String token) async {
    final res = await dio.post(
      '$baseUrl/lugares-turisticos',
      data: lugar.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print('Respuesta POST: ${res.data}');
    return LugarTuristicoModel.fromJson(res.data);
  }

  Future<LugarTuristicoModel> update(LugarTuristicoModel lugar, String token) async {
    final res = await dio.patch(
      '$baseUrl/lugares-turisticos/${lugar.id}',
      data: lugar.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print('Respuesta PATCH: ${res.data}');
    return LugarTuristicoModel.fromJson(res.data);
  }

  Future<void> delete(int id, String token) async {
    await dio.delete(
      '$baseUrl/lugares-turisticos/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
