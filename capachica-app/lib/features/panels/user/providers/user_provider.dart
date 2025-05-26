import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository repository;
  User? profile;

  UserProvider(this.repository);

  Future<void> loadProfile() async {
    profile = await repository.fetchProfile();
    notifyListeners();
  }
}