import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tipo_servicio_provider.dart';
import '../../data/models/tipo_servicio_model.dart';
import 'tipo_servicio_form_screen.dart';

class TiposServicioScreen extends StatefulWidget {
  const TiposServicioScreen({super.key});

  @override
  State<TiposServicioScreen> createState() => _TiposServicioScreenState();
}

class _TiposServicioScreenState extends State<TiposServicioScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<TipoServicioProvider>(context, listen: false).fetchTiposServicio()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TipoServicioProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Tipos de Servicio')),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text('Error: ${provider.error}'))
              : provider.tiposServicio.isEmpty
                  ? Center(child: Text('No hay tipos de servicio'))
                  : ListView.builder(
                      itemCount: provider.tiposServicio.length,
                      itemBuilder: (context, index) {
                        final tipo = provider.tiposServicio[index];
                        return ListTile(
                          title: Text(tipo.nombre),
                          subtitle: Text(tipo.descripcion),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TipoServicioFormScreen(tipoServicio: tipo),
                                    ),
                                  );
                                  Provider.of<TipoServicioProvider>(context, listen: false).fetchTiposServicio();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Eliminar tipo de servicio'),
                                      content: Text('¿Deseas eliminar "${tipo.nombre}"?'),
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
                                    provider.repository.deleteTipoServicio(tipo.id!);
                                    provider.fetchTiposServicio();
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TipoServicioFormScreen(),
            ),
          );
          Provider.of<TipoServicioProvider>(context, listen: false).fetchTiposServicio();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
