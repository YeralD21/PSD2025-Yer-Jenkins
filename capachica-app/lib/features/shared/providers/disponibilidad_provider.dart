import 'package:flutter/material.dart';
import '../data/models/disponibilidad_model.dart';
import '../data/repositories/disponibilidad_repository.dart';
import 'package:capachica/features/shared/data/models/disponibilidad_model.dart';

class DisponibilidadProvider extends ChangeNotifier {
  final DisponibilidadRepository repository;
  List<DisponibilidadModel> disponibilidades = [];
  bool isLoading = false;
  String? error;

  DisponibilidadProvider(this.repository);

  Future<void> fetchDisponibilidades({int? servicioId}) async {
    isLoading = true;
    notifyListeners();
    try {
      if (servicioId != null) {
        disponibilidades = await repository.getDisponibilidadesPorServicio(servicioId);
      } else {
        disponibilidades = await repository.getDisponibilidades();
      }
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addDisponibilidad(DisponibilidadModel d) async {
    isLoading = true;
    notifyListeners();
    try {
      final nueva = await repository.createDisponibilidad(d);
      disponibilidades.add(nueva);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateDisponibilidad(DisponibilidadModel d) async {
    isLoading = true;
    notifyListeners();
    try {
      final actualizada = await repository.updateDisponibilidad(d);
      final idx = disponibilidades.indexWhere((e) => e.id == d.id);
      if (idx != -1) disponibilidades[idx] = actualizada;
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteDisponibilidad(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      await repository.deleteDisponibilidad(id);
      disponibilidades.removeWhere((e) => e.id == id);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
