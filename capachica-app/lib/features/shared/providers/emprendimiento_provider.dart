import 'package:flutter/material.dart';
import '../data/models/emprendimiento_model.dart';
import '../data/repositories/emprendimiento_repository.dart';

class EmprendimientoProvider extends ChangeNotifier {
  final EmprendimientoRepository repository;
  List<EmprendimientoModel> emprendimientos = [];
  bool isLoading = false;
  String? error;

  EmprendimientoProvider(this.repository);

  Future<void> fetchEmprendimientos() async {
    isLoading = true;
    notifyListeners();
    try {
      emprendimientos = await repository.fetchEmprendimientos();
      print('Emprendimientos cargados: ${emprendimientos.length}');
      error = null;
    } catch (e) {
      error = e.toString();
      print('Error cargando emprendimientos: $error');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addEmprendimiento(EmprendimientoModel e) async {
    print('Llamando a createEmprendimiento en el repositorio...');
    isLoading = true;
    notifyListeners();
    try {
      await repository.createEmprendimiento(e);
      await fetchEmprendimientos();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateEmprendimiento(EmprendimientoModel e) async {
    isLoading = true;
    notifyListeners();
    try {
      await repository.updateEmprendimiento(e);
      await fetchEmprendimientos();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteEmprendimiento(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      await repository.deleteEmprendimiento(id);
      emprendimientos.removeWhere((e) => e.id == id);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
