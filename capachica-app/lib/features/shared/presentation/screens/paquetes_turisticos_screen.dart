import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/paquete_turistico_provider.dart';
import '../../data/models/paquete_turistico_model.dart';
import 'paquete_turistico_form_screen.dart';
import '../../providers/servicio_provider.dart';
import '../../data/models/servicio_model.dart';

class PaquetesTuristicosScreen extends StatefulWidget {
  @override
  State<PaquetesTuristicosScreen> createState() => _PaquetesTuristicosScreenState();
}

class _PaquetesTuristicosScreenState extends State<PaquetesTuristicosScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<PaqueteTuristicoProvider>(context, listen: false).fetchPaquetes()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaqueteTuristicoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Paquetes Turísticos')),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text('Error: ${provider.error}'))
              : provider.paquetes.isEmpty
                  ? Center(child: Text('No hay paquetes turísticos'))
                  : ListView.builder(
                      itemCount: provider.paquetes.length,
                      itemBuilder: (context, index) {
                        final paquete = provider.paquetes[index];
                        return ListTile(
                          title: Text(paquete.nombre ?? ''),
                          subtitle: Text(paquete.descripcion ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PaqueteTuristicoFormScreen(paquete: paquete),
                                    ),
                                  );
                                  provider.fetchPaquetes();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Eliminar paquete'),
                                      content: Text('¿Deseas eliminar "${paquete.nombre}"?'),
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
                                    provider.deletePaquete(paquete.id!);
                                  }
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaqueteTuristicoDetalleScreen(paquete: paquete),
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
              builder: (_) => PaqueteTuristicoFormScreen(),
            ),
          );
          provider.fetchPaquetes();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PaqueteTuristicoDetalleScreen extends StatelessWidget {
  final PaqueteTuristicoModel paquete;
  const PaqueteTuristicoDetalleScreen({Key? key, required this.paquete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviciosProvider = Provider.of<ServicioProvider>(context, listen: false);
    final servicios = serviciosProvider.servicios;

    // Obtén los servicios que están incluidos en el paquete
    final serviciosIncluidos = paquete.servicios ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(paquete.nombre ?? ''),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(paquete.descripcion ?? '', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text('Precio: S/ ${paquete.precio ?? 0}', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          // Imágenes
          if (paquete.imagenes != null && paquete.imagenes!.isNotEmpty) ...[
            Text('Imágenes:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: paquete.imagenes!
                    .map((img) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(img, width: 120, fit: BoxFit.cover),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 16),
          ],

          // Servicios asociados
          Text('Servicios incluidos:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...serviciosIncluidos.map((servicio) => Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(servicio.nombre ?? ''),
              subtitle: Text(servicio.descripcion ?? ''),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Eliminar Servicio'),
                      content: Text('¿Eliminar Servicio de este Paquete?'),
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
                    final provider = Provider.of<PaqueteTuristicoProvider>(context, listen: false);
                    final nuevaLista = List<ServicioModel>.from(serviciosIncluidos)
                      ..removeWhere((s) => s.id == servicio.id);
                    final paqueteActualizado = paquete.copyWith(servicios: nuevaLista);
                    await provider.updatePaquete(paqueteActualizado);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
}
