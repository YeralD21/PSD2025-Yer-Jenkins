import 'package:flutter/material.dart';
import '../data/models/superadmin_model.dart';
import '../data/repositories/superadmin_repository.dart';

class SuperAdminProvider with ChangeNotifier {
  final SuperAdminRepository repository;
  SuperAdmin? profile;

  SuperAdminProvider(this.repository);

  Future<void> loadProfile() async {
    profile = await repository.fetchProfile();
    notifyListeners();
  }
}