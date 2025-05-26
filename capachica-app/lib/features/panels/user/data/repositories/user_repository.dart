import '../models/user_model.dart';

class UserRepository {
  Future<User> fetchProfile() async {
    // Lógica para obtener el perfil del Usuario
    return User(id: '3', name: 'Usuario', email: 'user@user.com');
  }
}