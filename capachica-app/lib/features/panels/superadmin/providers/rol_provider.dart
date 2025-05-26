import 'package:flutter/material.dart';
import '../data/models/rol_model.dart';
import '../data/repositories/rol_repository.dart';

class RolProvider extends ChangeNotifier {
  final RolRepository _repository;
  List<Rol> _roles = [];
  bool _isLoading = false;
  String? _error;

  RolProvider(this._repository);

  List<Rol> get roles => _roles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarRoles() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _roles = await _repository.getRoles();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> crearRol({required String nombre, required String descripcion}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final nuevoRol = await _repository.createRol(nombre: nombre, descripcion: descripcion);
      _roles.add(nuevoRol);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> actualizarRol({required int id, required String nombre, required String descripcion}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final rolActualizado = await _repository.updateRol(id: id, nombre: nombre, descripcion: descripcion);
      final index = _roles.indexWhere((r) => r.id == id);
      if (index != -1) {
        _roles[index] = rolActualizado;
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

  Future<void> eliminarRol(int id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.deleteRol(id);
      _roles.removeWhere((r) => r.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> asignarPermisoARol({required int rolId, required int permisoId}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.asignarPermisoARol(rolId: rolId, permisoId: permisoId);
      await cargarRoles(); // Recargar para ver los cambios
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}