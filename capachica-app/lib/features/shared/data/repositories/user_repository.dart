import '../models/user_model.dart';

class UserRepository {
  Future<User> fetchProfile() async {
    // Simulación de API
    return User(id: 1, name: 'Admin', email: 'admin@correo.com');
  }
}