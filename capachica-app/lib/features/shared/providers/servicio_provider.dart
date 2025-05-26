import 'package:flutter/material.dart';
import '../data/models/servicio_model.dart';
import '../data/repositories/servicio_repository.dart';

class ServicioProvider extends ChangeNotifier {
  final ServicioRepository _repository;
  List<ServicioModel> _servicios = [];
  List<ServicioModel> _serviciosFiltrados = [];
  String? _categoriaSeleccionada;
  bool _isLoading = false;
  String? error;

  ServicioProvider(this._repository) {
    fetchServicios();
  }

  List<ServicioModel> get servicios => _serviciosFiltrados;
  bool get isLoading => _isLoading;
  String? get categoriaSeleccionada => _categoriaSeleccionada;

  // Lista de categorías predefinidas
  List<String> get categorias => [
    'Todos',
    'Hospedaje',
    'Alimentación',
    'Transporte',
    'Guía',
    'Actividades',
  ];

  Future<void> fetchServicios() async {
    _isLoading = true;
    notifyListeners();

    try {
      _servicios = await _repository.fetchServicios();
      _serviciosFiltrados = _servicios;
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filtrarPorCategoria(String categoria) {
    _categoriaSeleccionada = categoria;
    
    if (categoria == 'Todos') {
      _serviciosFiltrados = _servicios;
    } else {
      _serviciosFiltrados = _servicios.where((servicio) {
        return servicio.tipoServicioId == categoria;
      }).toList();
    }
    
    notifyListeners();
  }

  Future<void> addServicio(ServicioModel nuevo) async {
    _isLoading = true;
    notifyListeners();
    try {
      final servicio = await _repository.createServicio(nuevo);
      _servicios.add(servicio);
      _serviciosFiltrados = _servicios;
      error = null;
    } catch (e) {
      error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateServicio(ServicioModel actualizado) async {
    _isLoading = true;
    notifyListeners();
    try {
      final servicio = await _repository.updateServicio(actualizado);
      final idx = _servicios.indexWhere((s) => s.id == actualizado.id);
      if (idx != -1) _servicios[idx] = servicio;
      _serviciosFiltrados = _servicios;
      error = null;
    } catch (e) {
      error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteServicio(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteServicio(id);
      _servicios.removeWhere((e) => e.id == id);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
