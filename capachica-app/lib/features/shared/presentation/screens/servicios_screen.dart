import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/servicio_provider.dart';
import '../../data/models/servicio_model.dart';
import 'servicio_form_screen.dart';
import '../../providers/tipo_servicio_provider.dart';
import '../../data/models/tipo_servicio_model.dart';
import 'disponibilidad_screen.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<ServicioProvider>(context, listen: false).fetchServicios()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ServicioProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Servicios')),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text('Error: ${provider.error}'))
              : provider.servicios.isEmpty
                  ? Center(child: Text('No hay servicios'))
                  : Consumer<TipoServicioProvider>(
                      builder: (context, tipoProvider, _) {
                        return ListView.builder(
                          itemCount: provider.servicios.length,
                          itemBuilder: (context, index) {
                            final servicio = provider.servicios[index];
                            final tipoSeleccionado = tipoProvider.tiposServicio.firstWhere(
                              (t) => t.id == servicio.tipoServicioId,
                              orElse: () => TipoServicio(id: null, nombre: 'Desconocido', descripcion: '', requiereCupo: false),
                            );
                            return ListTile(
                              title: Text(servicio.nombre ?? ''),
                              subtitle: Text('${servicio.descripcion}\nTipo: ${tipoSeleccionado.nombre}'),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.event_available),
                                    tooltip: 'Ver disponibilidad',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DisponibilidadScreen(
                                            servicioId: servicio.id!,
                                            nombreServicio: servicio.nombre ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ServicioFormScreen(servicio: servicio),
                                        ),
                                      );
                                      Provider.of<ServicioProvider>(context, listen: false).fetchServicios();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Eliminar servicio'),
                                          content: Text('¿Deseas eliminar "${servicio.nombre}"?'),
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
                                        provider.deleteServicio(servicio.id!);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServicioFormScreen(),
            ),
          );
          Provider.of<ServicioProvider>(context, listen: false).fetchServicios();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
