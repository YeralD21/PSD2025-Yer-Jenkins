import 'package:flutter/material.dart';
import '../data/models/lugar_turistico_model.dart';
import '../data/repositories/lugar_turistico_repository.dart';

class LugarTuristicoProvider extends ChangeNotifier {
  final LugarTuristicoRepository repository;

  LugarTuristicoProvider(this.repository);

  List<LugarTuristicoModel> lugares = [];
  List<LugarTuristicoModel> destacados = [];
  LugarTuristicoModel? detalle;
  bool isLoading = false;
  String? error;

  Future<void> fetchLugares() async {
    isLoading = true;
    notifyListeners();
    try {
      lugares = await repository.fetchLugares();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDestacados() async {
    isLoading = true;
    notifyListeners();
    try {
      destacados = await repository.fetchDestacados();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchById(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      detalle = await repository.fetchById(id);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addLugar(LugarTuristicoModel lugar, String token) async {
    isLoading = true;
    notifyListeners();
    try {
      await repository.create(lugar, token);
      await fetchLugares();
      error = null;
    } catch (e) {
      error = e.toString();
      print('Error al crear lugar: $error');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateLugar(LugarTuristicoModel lugar, String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final updated = await repository.update(lugar, token);
      print('Lugar actualizado: ${updated.toJson()}');
      await fetchLugares();
      error = null;
    } catch (e) {
      error = e.toString();
      print('Error al actualizar lugar: $error');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteLugar(int id, String token) async {
    isLoading = true;
    notifyListeners();
    try {
      await repository.delete(id, token);
      await fetchLugares();
      error = null;
    } catch (e) {
      error = e.toString();
      print('Error al eliminar lugar: $error');
    }
    isLoading = false;
    notifyListeners();
  }
}
