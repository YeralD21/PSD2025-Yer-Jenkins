import 'package:capachica/core/api/api_client.dart';
import '../models/rol_model.dart';

class RolRepository {
  final ApiClient _apiClient;
  RolRepository(this._apiClient);

  Future<List<Rol>> getRoles() async {
    final response = await _apiClient.get('/roles');
    return (response.data as List).map((json) => Rol.fromJson(json)).toList();
  }

  Future<Rol> getRol(int id) async {
    final response = await _apiClient.get('/roles/$id');
    return Rol.fromJson(response.data);
  }

  Future<Rol> createRol({required String nombre, required String descripcion}) async {
    final response = await _apiClient.post('/roles', data: {
      'nombre': nombre,
      'descripcion': descripcion,
    });
    return Rol.fromJson(response.data);
  }

  Future<Rol> updateRol({required int id, required String nombre, required String descripcion}) async {
    final response = await _apiClient.dio.patch('/roles/$id', data: {
      'nombre': nombre,
      'descripcion': descripcion,
    });
    return Rol.fromJson(response.data);
  }

  Future<void> deleteRol(int id) async {
    await _apiClient.dio.delete('/roles/$id');
  }

  Future<void> asignarPermisoARol({required int rolId, required int permisoId}) async {
    await _apiClient.post('/roles/$rolId/permissions', data: {
      'permisoId': permisoId,
    });
  }
}