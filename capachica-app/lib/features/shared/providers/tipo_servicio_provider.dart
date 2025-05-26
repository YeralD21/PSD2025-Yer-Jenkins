import 'package:flutter/material.dart';
import '../data/models/tipo_servicio_model.dart';
import '../data/repositories/tipo_servicio_repository.dart';

class TipoServicioProvider extends ChangeNotifier {
  final TipoServicioRepository repository;
  List<TipoServicio> tiposServicio = [];
  bool isLoading = false;
  String? error;

  TipoServicioProvider(this.repository);

  Future<void> fetchTiposServicio() async {
    isLoading = true;
    notifyListeners();
    try {
      tiposServicio = await repository.getTiposServicio();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  // Métodos para crear, actualizar y eliminar igual que en ServicioProvider...
}
