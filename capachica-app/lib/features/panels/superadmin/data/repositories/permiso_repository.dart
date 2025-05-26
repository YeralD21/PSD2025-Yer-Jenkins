import 'package:capachica/core/api/api_client.dart';
import '../models/permiso_model.dart';

abstract class IPermisoRepository {
  Future<List<Permiso>> getPermisos();
  Future<Permiso> getPermiso(int id);
  Future<Permiso> createPermiso({required String nombre, required String descripcion});
  Future<Permiso> updatePermiso({required int id, required String nombre, required String descripcion});
  Future<void> deletePermiso(int id);
}

class PermisoRepository implements IPermisoRepository {
  final ApiClient _apiClient;

  PermisoRepository(this._apiClient);

  @override
  Future<List<Permiso>> getPermisos() async {
    try {
      final response = await _apiClient.get('/permissions');
      return (response.data as List)
          .map((json) => Permiso.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener permisos: $e');
    }
  }

  @override
  Future<Permiso> getPermiso(int id) async {
    try {
      final response = await _apiClient.get('/permissions/$id');
      return Permiso.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al obtener permiso: $e');
    }
  }

  @override
  Future<Permiso> createPermiso({
    required String nombre,
    required String descripcion,
  }) async {
    try {
      final response = await _apiClient.post(
        '/permissions',
        data: {
          'nombre': nombre,
          'descripcion': descripcion,
        },
      );
      return Permiso.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear permiso: $e');
    }
  }

  @override
  Future<Permiso> updatePermiso({
    required int id,
    required String nombre,
    required String descripcion,
  }) async {
    try {
      final response = await _apiClient.dio.patch(
        '/permissions/$id',
        data: {
          'nombre': nombre,
          'descripcion': descripcion,
        },
      );
      return Permiso.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar permiso: $e');
    }
  }

  @override
  Future<void> deletePermiso(int id) async {
    try {
      await _apiClient.dio.delete('/permissions/$id');
    } catch (e) {
      throw Exception('Error al eliminar permiso: $e');
    }
  }
}