import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/emprendimiento_provider.dart';
import '../../data/models/emprendimiento_model.dart';
import 'package:capachica/features/auth/providers/auth_provider.dart';
import 'emprendimiento_form_screen.dart';

class EmprendimientosScreen extends StatefulWidget {
  final bool isSuperAdmin;

  const EmprendimientosScreen({super.key, required this.isSuperAdmin});

  @override
  State<EmprendimientosScreen> createState() => _EmprendimientosScreenState();
}

class _EmprendimientosScreenState extends State<EmprendimientosScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<EmprendimientoProvider>(context, listen: false).fetchEmprendimientos()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmprendimientoProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final usuarioId = authProvider.usuario?.id;

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text('Gestión de Emprendimientos')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Debes iniciar sesión para acceder a esta sección'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navegar a la pantalla de login
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Ir a Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Emprendimientos')),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text('Error: ${provider.error}'))
              : provider.emprendimientos.isEmpty
                  ? Center(child: Text('No hay emprendimientos'))
                  : ListView.builder(
                      itemCount: provider.emprendimientos.length,
                      itemBuilder: (context, index) {
                        final emp = provider.emprendimientos[index];
                        return ListTile(
                          title: Text(emp.nombre ?? ''),
                          subtitle: Text(emp.descripcion ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.isSuperAdmin || /* lógica de permisos */ true)
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EmprendimientoFormScreen(
                                          emprendimiento: emp,
                                          usuarioId: usuarioId!,
                                        ),
                                      ),
                                    );
                                    Provider.of<EmprendimientoProvider>(context, listen: false).fetchEmprendimientos();
                                  },
                                ),
                              if (widget.isSuperAdmin || /* lógica de permisos */ true)
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Eliminar este emprendimiento?'),
                                        content: Text('¿Deseas eliminar "${emp.nombre}"?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      provider.deleteEmprendimiento(emp.id!);
                                    }
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
      floatingActionButton: (widget.isSuperAdmin || /* lógica de permisos */ true)
          ? FloatingActionButton(
              onPressed: () async {
                if (usuarioId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: usuario no autenticado')),
                  );
                  return;
                }
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmprendimientoFormScreen(
                      usuarioId: usuarioId,
                    ),
                  ),
                );
                Provider.of<EmprendimientoProvider>(context, listen: false).fetchEmprendimientos();
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
