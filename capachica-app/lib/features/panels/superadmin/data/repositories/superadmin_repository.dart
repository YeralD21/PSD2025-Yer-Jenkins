import '../models/superadmin_model.dart';

class SuperAdminRepository {
  Future<SuperAdmin> fetchProfile() async {
    // Aquí iría la lógica para obtener el perfil del SuperAdmin desde la API
    // Ejemplo simulado:
    return SuperAdmin(id: '1', name: 'Super Admin', email: 'admin@admin.com');
  }
}