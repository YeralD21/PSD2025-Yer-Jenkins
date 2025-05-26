import 'package:flutter/material.dart';
import '../data/models/emprendimiento_model.dart';
import '../data/repositories/emprendimiento_repository.dart';

class EmprendimientoProvider with ChangeNotifier {
  final EmprendimientoRepository repository;
  List<Emprendimiento> _emprendimientos = [];

  EmprendimientoProvider(this.repository);

  List<Emprendimiento> get emprendimientos => _emprendimientos;

  Future<void> cargarEmprendimientos() async {
    _emprendimientos = await repository.fetchEmprendimientos();
    notifyListeners();
  }
}