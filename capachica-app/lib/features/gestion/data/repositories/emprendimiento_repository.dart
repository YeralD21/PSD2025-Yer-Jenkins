import '../models/emprendimiento_model.dart';

class EmprendimientoRepository {
  // Simulación de API
  Future<List<Emprendimiento>> fetchEmprendimientos() async {
    // Aquí iría la llamada real a la API
    return [
      Emprendimiento(id: 1, nombre: 'Tienda A', descripcion: 'Descripción A'),
      Emprendimiento(id: 2, nombre: 'Tienda B', descripcion: 'Descripción B'),
    ];
  }

  // Otros métodos: create, update, delete...
}