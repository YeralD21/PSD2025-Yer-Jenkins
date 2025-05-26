import 'package:capachica/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Verificar si estamos autenticados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.status != AuthStatus.authenticated) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tour Capa Chica'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80,
            ),
            SizedBox(height: 24),
            Text(
              '¡Inicio de sesión exitoso!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Bienvenido a Tour Capa Chica',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              icon: Icon(Icons.logout),
              label: Text('Cerrar Sesión'),
              onPressed: () {
                _showLogoutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión'),
        content: Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text('Salir'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}