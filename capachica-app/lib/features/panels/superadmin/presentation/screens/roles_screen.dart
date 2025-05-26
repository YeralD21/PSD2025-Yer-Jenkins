import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rol_provider.dart';
import '../../data/models/rol_model.dart';
import 'package:capachica/features/panels/superadmin/providers/permiso_provider.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RolProvider>().cargarRoles();
    });
  }

  Future<void> _mostrarFormularioRol([Rol? rol]) async {
    final nombreController = TextEditingController(text: rol?.nombre);
    final descripcionController = TextEditingController(text: rol?.descripcion);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(rol == null ? 'Nuevo Rol' : 'Editar Rol'),
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
                if (rol == null) {
                  await context.read<RolProvider>().crearRol(
                    nombre: nombreController.text,
                    descripcion: descripcionController.text,
                  );
                } else {
                  await context.read<RolProvider>().actualizarRol(
                    id: rol.id,
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
            child: Text(rol == null ? 'Crear' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarEliminarRol(Rol rol) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Rol'),
        content: Text('¿Estás seguro de eliminar el rol "${rol.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await context.read<RolProvider>().eliminarRol(rol.id);
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

  Future<void> _mostrarAsignarPermisos(BuildContext context, Rol rol) async {
    final permisosProvider = Provider.of<PermisoProvider>(context, listen: false);
    await permisosProvider.cargarPermisos();

    final permisosAsignados = rol.rolesPermisos.map((rp) => rp.permiso.id).toSet();

    showDialog(
      context: context,
      builder: (context) {
        Set<int> seleccionados = {...permisosAsignados};
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Asignar Permisos a ${rol.nombre}'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: permisosProvider.permisos.map((permiso) {
                    return CheckboxListTile(
                      value: seleccionados.contains(permiso.id),
                      title: Text(permiso.nombre),
                      subtitle: Text(permiso.descripcion),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            seleccionados.add(permiso.id);
                          } else {
                            seleccionados.remove(permiso.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Asigna solo los permisos nuevos
                    for (final permisoId in seleccionados.difference(permisosAsignados)) {
                      await Provider.of<RolProvider>(context, listen: false)
                          .asignarPermisoARol(rolId: rol.id, permisoId: permisoId);
                    }
                    // Opcional: podrías eliminar permisos desmarcados aquí si tu backend lo permite
                    Navigator.pop(context);
                  },
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Roles y Asignación de Permisos'),
      ),
      body: Consumer<RolProvider>(
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
                    onPressed: () => provider.cargarRoles(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.roles.length,
            itemBuilder: (context, index) {
              final rol = provider.roles[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(rol.nombre),
                  subtitle: Text(rol.descripcion),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _mostrarFormularioRol(rol),
                        tooltip: 'Editar',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmarEliminarRol(rol),
                        tooltip: 'Eliminar',
                      ),
                      IconButton(
                        icon: Icon(Icons.lock_open),
                        tooltip: 'Asignar Permisos',
                        onPressed: () => _mostrarAsignarPermisos(context, rol),
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
        onPressed: () => _mostrarFormularioRol(),
        child: const Icon(Icons.add),
      ),
    );
  }
}