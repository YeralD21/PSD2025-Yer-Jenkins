import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/disponibilidad_provider.dart';
import '../../data/models/disponibilidad_model.dart';
import 'disponibilidad_form_screen.dart';

class DisponibilidadScreen extends StatefulWidget {
  final int servicioId;
  final String? nombreServicio;
  const DisponibilidadScreen({super.key, required this.servicioId, this.nombreServicio});

  @override
  State<DisponibilidadScreen> createState() => _DisponibilidadScreenState();
}

class _DisponibilidadScreenState extends State<DisponibilidadScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<DisponibilidadProvider>(context, listen: false)
        .fetchDisponibilidades(servicioId: widget.servicioId)
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DisponibilidadProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.nombreServicio != null && widget.nombreServicio!.isNotEmpty
          ? 'Disponibilidad de ${widget.nombreServicio}'
          : 'Disponibilidad')),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text('Error: ${provider.error}'))
              : provider.disponibilidades.isEmpty
                  ? Center(child: Text('No hay disponibilidad'))
                  : ListView.builder(
                      itemCount: provider.disponibilidades.length,
                      itemBuilder: (context, index) {
                        final d = provider.disponibilidades[index];
                        return ListTile(
                          title: Text('Fecha: ${d.fecha}'),
                          subtitle: Text('Cupos: ${d.cuposDisponibles} - Precio especial: ${d.precioEspecial}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DisponibilidadFormScreen(
                                        disponibilidad: d,
                                        servicioId: d.servicioId!,
                                      ),
                                    ),
                                  );
                                  Provider.of<DisponibilidadProvider>(context, listen: false)
                                    .fetchDisponibilidades(servicioId: widget.servicioId);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Eliminar disponibilidad'),
                                      content: Text('¿Deseas eliminar la disponibilidad del ${d.fecha}?'),
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
                                    provider.deleteDisponibilidad(d.id!);
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
              builder: (_) => DisponibilidadFormScreen(servicioId: widget.servicioId),
            ),
          );
          Provider.of<DisponibilidadProvider>(context, listen: false)
            .fetchDisponibilidades(servicioId: widget.servicioId);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
