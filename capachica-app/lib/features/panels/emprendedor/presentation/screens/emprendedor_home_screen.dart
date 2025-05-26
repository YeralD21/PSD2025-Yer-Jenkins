import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/emprendedor_provider.dart';
import 'package:capachica/features/auth/providers/auth_provider.dart';
import 'package:capachica/features/gestion/presentation/screens/gestion_accesos.dart';
//import 'package:capachica/features/gestion/presentation/screens/servicios_screen.dart';
import 'package:capachica/features/gestion/presentation/screens/paquetes_screen.dart';
import 'package:capachica/features/gestion/presentation/screens/reservas_screen.dart';
import 'package:capachica/features/gestion/presentation/screens/pagos_screen.dart';
import 'package:capachica/features/shared/presentation/screens/emprendimientos_screen.dart';
import 'package:capachica/features/shared/presentation/screens/servicios_screen.dart';
import 'package:capachica/features/shared/presentation/screens/tipos_servicio_screen.dart';
import 'package:capachica/features/shared/presentation/screens/paquetes_turisticos_screen.dart';
import 'package:capachica/features/shared/presentation/screens/lugares_turisticos_screen.dart';

class EmprendedorHomeScreen extends StatefulWidget {
  @override
  State<EmprendedorHomeScreen> createState() => _EmprendedorHomeScreenState();
}

class _EmprendedorHomeScreenState extends State<EmprendedorHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<EmprendedorProvider>(context, listen: false).loadProfile()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmprendedorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Emprendedor Home'),
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
      body: provider.profile == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bienvenido, ${provider.profile!.name}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  provider.profile!.businessName ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(16.0),
                    children: accesosGestion.map((acceso) {
                      return _buildMenuCard(
                        context,
                        acceso['nombre'],
                        acceso['icon'],
                        acceso['screen'],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.loadProfile(),
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> accesosGestion = [
  // {
  //   'nombre': 'Gestión de Emprendimientos',
  //   'icon': Icons.apartment,
  //   'screen': EmprendimientosScreen(isSuperAdmin: false),
  // },
  {
    'nombre': 'Gestión de Servicios',
    'icon': Icons.room_service,
    'screen': ServiciosScreen(),
  },
  {
    'nombre': 'Gestión de Tipos de Servicio',
    'icon': Icons.category,
    'screen': TiposServicioScreen(),
  },
    {
    'nombre': 'Gestión de Paquetes Turísticos',
    'icon': Icons.tour,
    'screen': PaquetesTuristicosScreen(),
  },
  //agrego mas
  {
    'nombre': 'Gestión de Reservas',
    'icon': Icons.book_online,
    'screen': ReservasScreen(),
  },
  {
    'nombre': 'Gestión de Pagos',
    'icon': Icons.payment,
    'screen': PagosScreen(),
  },
];