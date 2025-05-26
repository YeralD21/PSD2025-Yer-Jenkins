import 'package:flutter/material.dart';
import '../data/models/emprendedor_model.dart';
import '../data/repositories/emprendedor_repository.dart';

class EmprendedorProvider with ChangeNotifier {
  final EmprendedorRepository repository;
  Emprendedor? profile;

  EmprendedorProvider(this.repository);

  Future<void> loadProfile() async {
    profile = await repository.fetchProfile();
    notifyListeners();
  }
}