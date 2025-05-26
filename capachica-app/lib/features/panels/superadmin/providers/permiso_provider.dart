import 'package:flutter/material.dart';
import '../data/models/permiso_model.dart';
import '../data/repositories/permiso_repository.dart';

class PermisoProvider extends ChangeNotifier {
  final PermisoRepository _repository;
  List<Permiso> _permisos = [];
  bool _isLoading = false;
  String? _error;

  PermisoProvider(this._repository);

  List<Permiso> get permisos => _permisos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarPermisos() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _permisos = await _repository.getPermisos();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> crearPermiso({
    required String nombre,
    required String descripcion,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final nuevoPermiso = await _repository.createPermiso(
        nombre: nombre,
        descripcion: descripcion,
      );
      _permisos.add(nuevoPermiso);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> actualizarPermiso({
    required int id,
    required String nombre,
    required String descripcion,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final permisoActualizado = await _repository.updatePermiso(
        id: id,
        nombre: nombre,
        descripcion: descripcion,
      );
      final index = _permisos.indexWhere((p) => p.id == id);
      if (index != -1) {
        _permisos[index] = permisoActualizado;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminarPermiso(int id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.deletePermiso(id);
      _permisos.removeWhere((p) => p.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  


} 