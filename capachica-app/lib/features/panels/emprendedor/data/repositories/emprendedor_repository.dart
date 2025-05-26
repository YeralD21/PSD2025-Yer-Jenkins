import '../models/emprendedor_model.dart';

class EmprendedorRepository {
  Future<Emprendedor> fetchProfile() async {
    // Lógica para obtener el perfil del Emprendedor
    return Emprendedor(id: '2', name: 'Emprendedor', businessName: 'Mi Negocio');
  }
}