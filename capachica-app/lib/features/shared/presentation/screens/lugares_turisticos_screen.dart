import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/lugar_turistico_provider.dart';
import '../../data/models/lugar_turistico_model.dart';
import 'lugar_turistico_form_screen.dart';
import '../../../auth/providers/auth_provider.dart';

class LugaresTuristicosScreen extends StatefulWidget {
  @override
  State<LugaresTuristicosScreen> createState() => _LugaresTuristicosScreenState();
}

class _LugaresTuristicosScreenState extends State<LugaresTuristicosScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<LugarTuristicoProvider>(context, listen: false).fetchLugares()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LugarTuristicoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Lugares Turísticos')),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text('Error: ${provider.error}'))
              : provider.lugares.isEmpty
                  ? Center(child: Text('No hay lugares turísticos'))
                  : ListView.builder(
                      itemCount: provider.lugares.length,
                      itemBuilder: (context, index) {
                        final lugar = provider.lugares[index];
                        return ListTile(
                          title: Text(lugar.nombre ?? ''),
                          subtitle: Text(lugar.descripcion ?? ''),
                          onTap: () {
                            // Puedes navegar a un detalle si lo deseas
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LugarTuristicoFormScreen(lugar: lugar),
                                    ),
                                  );
                                  provider.fetchLugares();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                  final token = authProvider.token;
                                  if (token == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('No se encontró el token de autenticación. Inicia sesión nuevamente.')),
                                    );
                                    return;
                                  }
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Eliminar lugar'),
                                      content: Text('¿Deseas eliminar "${lugar.nombre}"?'),
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
                                    provider.deleteLugar(lugar.id!, token);
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
              builder: (_) => LugarTuristicoFormScreen(),
            ),
          );
          provider.fetchLugares();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
