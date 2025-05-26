import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/permiso_model.dart';
import '../../providers/permiso_provider.dart';
import 'asignar_permisos_screen.dart';

class PermisosScreen extends StatefulWidget {
  const PermisosScreen({super.key});

  @override
  State<PermisosScreen> createState() => _PermisosScreenState();
}

class _PermisosScreenState extends State<PermisosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PermisoProvider>().cargarPermisos();
    });
  }

  Future<void> _mostrarFormularioPermiso([Permiso? permiso]) async {
    final nombreController = TextEditingController(text: permiso?.nombre);
    final descripcionController = TextEditingController(text: permiso?.descripcion);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(permiso == null ? 'Nuevo Permiso' : 'Editar Permiso'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                if (permiso == null) {
                  await context.read<PermisoProvider>().crearPermiso(
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                      );
                } else {
                  await context.read<PermisoProvider>().actualizarPermiso(
                        id: permiso.id,
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                      );
                }
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: Text(permiso == null ? 'Crear' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarEliminarPermiso(Permiso permiso) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Permiso'),
        content: Text('¿Estás seguro de eliminar el permiso "${permiso.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await context.read<PermisoProvider>().eliminarPermiso(permiso.id);
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Permisos'),
      ),
      body: Consumer<PermisoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!, style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: () => provider.cargarPermisos(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.permisos.length,
            itemBuilder: (context, index) {
              final permiso = provider.permisos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(permiso.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(permiso.descripcion),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: permiso.rolesPermisos
                            .map((rp) => Chip(
                                  label: Text(rp.rol.nombre),
                                  backgroundColor: Colors.blue.withOpacity(0.2),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _mostrarFormularioPermiso(permiso),
                        tooltip: 'Editar',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmarEliminarPermiso(permiso),
                        tooltip: 'Eliminar',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioPermiso(),
        child: const Icon(Icons.add),
      ),
    );
  }
} 