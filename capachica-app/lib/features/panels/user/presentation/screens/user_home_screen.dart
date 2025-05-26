import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'package:capachica/features/auth/providers/auth_provider.dart';
// import 'emprendimientos_list_screen.dart';
// import 'servicios_list_screen.dart';
// import 'paquetes_list_screen.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar el perfil automáticamente al entrar a la pantalla
    Future.microtask(() =>
      Provider.of<UserProvider>(context, listen: false).loadProfile()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Explora Capachica'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          // Elimina o comenta las siguientes líneas porque las pantallas ya no existen:
          // _buildMenuCard(context, 'Emprendimientos', Icons.business, EmprendimientosListScreen()),
          // _buildMenuCard(context, 'Servicios', Icons.room_service, ServiciosListScreen()),
          // _buildMenuCard(context, 'Paquetes Turísticos', Icons.tour, PaquetesListScreen()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.loadProfile(),
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Widget screen) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}