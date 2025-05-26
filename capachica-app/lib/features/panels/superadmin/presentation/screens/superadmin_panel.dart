import 'package:flutter/material.dart';
import 'permisos_screen.dart';

class SuperAdminPanel extends StatelessWidget {
  const SuperAdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de SuperAdmin'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuCard(
            context,
            'Gestión de Permisos',
            Icons.security,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PermisosScreen(),
                ),
              );
            },
          ),
          // ... otros cards del menú existentes ...
        ],
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
} 