import 'package:dio/dio.dart';
import '../models/tipo_servicio_model.dart';

class TipoServicioRepository {
  final Dio dio;
  TipoServicioRepository(this.dio);

  Future<List<TipoServicio>> getTiposServicio() async {
    final response = await dio.get('/tipos-servicio');
    return (response.data as List)
        .map((e) => TipoServicio.fromJson(e))
        .toList();
  }

  Future<TipoServicio> getTipoServicio(int id) async {
    final response = await dio.get('/tipos-servicio/$id');
    return TipoServicio.fromJson(response.data);
  }

  Future<TipoServicio> createTipoServicio(TipoServicio tipo) async {
    final response = await dio.post('/tipos-servicio', data: tipo.toJson());
    return TipoServicio.fromJson(response.data);
  }

  Future<TipoServicio> updateTipoServicio(TipoServicio tipo) async {
    final response = await dio.patch('/tipos-servicio/${tipo.id}', data: tipo.toJson());
    return TipoServicio.fromJson(response.data);
  }

  Future<void> deleteTipoServicio(int id) async {
    await dio.delete('/tipos-servicio/$id');
  }
}
