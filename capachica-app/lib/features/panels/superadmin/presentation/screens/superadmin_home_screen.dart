import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/superadmin_provider.dart';
import 'package:capachica/features/auth/providers/auth_provider.dart';
import 'permisos_screen.dart';
import 'roles_screen.dart';
import 'package:capachica/features/panels/superadmin/data/models/rol_model.dart';
import 'package:capachica/features/gestion/presentation/screens/gestion_accesos.dart';
import 'package:capachica/features/shared/presentation/screens/emprendimientos_screen.dart';
import 'package:capachica/features/shared/presentation/screens/servicios_screen.dart';
import 'package:capachica/features/shared/presentation/screens/tipos_servicio_screen.dart';
import 'package:capachica/features/shared/presentation/screens/paquetes_turisticos_screen.dart';
import 'package:capachica/features/shared/presentation/screens/lugares_turisticos_screen.dart';

class SuperAdminHomeScreen extends StatefulWidget {
  const SuperAdminHomeScreen({super.key});

  @override
  State<SuperAdminHomeScreen> createState() => _SuperAdminHomeScreenState();
}

class _SuperAdminHomeScreenState extends State<SuperAdminHomeScreen> {
  final List<Map<String, dynamic>> accesosSuperAdmin = [
    {
      'nombre': 'Gestión de Permisos',
      'icon': Icons.security,
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PermisosScreen()),
        );
      },
    },
    {
      'nombre': 'Gestión de Roles y Asignación de Permisos',
      'icon': Icons.admin_panel_settings,
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RolesScreen()),
        );
      },
    },
  
    // Agrega más accesos según tus permisos y vistas
  ];

  final List<Map<String, dynamic>> accesosGestion = [
    {
      'nombre': 'Gestión de Emprendimientos',
      'icon': Icons.apartment,
      'screen': EmprendimientosScreen(isSuperAdmin: true),
    },
    {
      'nombre': 'Gestión de Servicios',
      'icon': Icons.room_service,
      'screen': ServiciosScreen(),
    },
    {
      'nombre': 'Tipos de Servicio',
      'icon': Icons.category,
      'screen': TiposServicioScreen(),
    },
    // ...otros accesos
    {
      'nombre': 'Gestión de Paquetes Turísticos',
      'icon': Icons.tour,
      'screen': PaquetesTuristicosScreen(),
    },
    {
      'nombre': 'Gestión de Lugares Turísticos',
      'icon': Icons.place,
      'screen': LugaresTuristicosScreen(),
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<SuperAdminProvider>(context, listen: false).loadProfile()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SuperAdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de SuperAdmin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: provider.profile == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Perfil del usuario
                Card(
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
                                'SuperAdmin',
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
                const SizedBox(height: 16),
                // Cards de gestión de permisos y roles
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.1,
                  children: accesosSuperAdmin.map((acceso) {
                    return _buildMenuCard(
                      context,
                      acceso['nombre'],
                      acceso['icon'],
                      () => acceso['onTap'](context),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Cards de gestión de entidades
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.1,
                  children: accesosGestion.map((acceso) {
                    return _buildMenuCard(
                      context,
                      acceso['nombre'],
                      acceso['icon'],
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => acceso['screen']),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.loadProfile(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
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

  Future<void> _mostrarAsignarPermisos(Rol rol) async {
    // Aquí deberías obtener la lista de permisos disponibles (puedes usar un provider de permisos)
    // y mostrar un diálogo con checkboxes o un selector.
    // Al seleccionar y confirmar, llama a provider.asignarPermisoARol(rolId: rol.id, permisoId: permisoSeleccionado)
  }
}