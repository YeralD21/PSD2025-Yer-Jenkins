import 'package:flutter/material.dart';
import '../data/models/paquete_turistico_model.dart';
import '../data/repositories/paquete_turistico_repository.dart';
import 'package:capachica/features/shared/data/models/paquete_turistico_model.dart';

class PaqueteTuristicoProvider extends ChangeNotifier {
  final PaqueteTuristicoRepository _repository;
  List<PaqueteTuristicoModel> _paquetes = [];
  List<PaqueteTuristicoModel> _paquetesFiltrados = [];
  String? _categoriaSeleccionada;
  bool _isLoading = false;
  String? error;

  PaqueteTuristicoProvider(this._repository) {
    fetchPaquetes();
  }

  List<PaqueteTuristicoModel> get paquetes => _paquetesFiltrados;
  bool get isLoading => _isLoading;
  String? get categoriaSeleccionada => _categoriaSeleccionada;

  // Lista de categorías predefinidas
  List<String> get categorias => [
    'Todos',
    'Aventura',
    'Cultural',
    'Gastronómico',
    'Naturaleza',
    'Relax',
  ];

  Future<void> fetchPaquetes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _paquetes = await _repository.fetchPaquetes();
      _paquetesFiltrados = _paquetes;
    } catch (e) {
      print('Error fetching paquetes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filtrarPorCategoria(String categoria) {
    _categoriaSeleccionada = categoria;
    
    if (categoria == 'Todos') {
      _paquetesFiltrados = _paquetes;
    } else {
      _paquetesFiltrados = _paquetes.where((paquete) {
        return true; // o el filtro correcto según tu modelo
      }).toList();
    }
    
    notifyListeners();
  }

  Future<void> addPaquete(PaqueteTuristicoModel paquete) async {
    await _repository.createPaquete(paquete);
    await fetchPaquetes();
  }

  Future<void> updatePaquete(PaqueteTuristicoModel paquete) async {
    await _repository.updatePaquete(paquete);
    await fetchPaquetes();
  }

  Future<void> deletePaquete(int id) async {
    await _repository.deletePaquete(id);
    await fetchPaquetes();
  }
}
