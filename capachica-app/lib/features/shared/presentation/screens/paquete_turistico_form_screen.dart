import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/paquete_turistico_provider.dart';
import '../../data/models/paquete_turistico_model.dart';
import '../../providers/servicio_provider.dart';
import '../../data/models/servicio_model.dart';
import '../../providers/emprendimiento_provider.dart';
import 'package:capachica/features/auth/providers/auth_provider.dart';


class PaqueteTuristicoFormScreen extends StatefulWidget {
  final PaqueteTuristicoModel? paquete;
  const PaqueteTuristicoFormScreen({Key? key, this.paquete}) : super(key: key);

  @override
  State<PaqueteTuristicoFormScreen> createState() => _PaqueteTuristicoFormScreenState();
}

class _PaqueteTuristicoFormScreenState extends State<PaqueteTuristicoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController precioController;
  late TextEditingController imagenesController;
  List<ServicioModel> serviciosSeleccionados = [];
  List<String> imagenes = [];
  int? emprendimientoSeleccionado;
  bool isSuperAdmin = false;
  final List<String> estados = ['activo', 'inactivo'];
  String? estadoSeleccionado;

  @override
  void initState() {
    super.initState();
    final p = widget.paquete;
    nombreController = TextEditingController(text: p?.nombre ?? '');
    descripcionController = TextEditingController(text: p?.descripcion ?? '');
    precioController = TextEditingController(text: p?.precio?.toString() ?? '');
    estadoSeleccionado = p?.estado ?? 'activo';
    imagenes = p?.imagenes ?? [];
    if (p?.servicios != null) {
      serviciosSeleccionados = List<ServicioModel>.from(p!.servicios!);
    }
    // emprendimientoSeleccionado = p?.emprendimientoId;

    // Obtén el rol del usuario
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    isSuperAdmin = authProvider.userRole == 'superadmin';

    if (isSuperAdmin) {
      // Si eres superadmin, carga todos los emprendimientos
      Future.microtask(() =>
        Provider.of<EmprendimientoProvider>(context, listen: false).fetchEmprendimientos()
      );
    } else {
      // Si eres emprendedor, asigna automáticamente su emprendimientoId
      final emprendimientoProvider = Provider.of<EmprendimientoProvider>(context, listen: false);
      // Asegúrate de que el provider tenga el emprendimiento cargado
      if (emprendimientoProvider.emprendimientos.isNotEmpty) {
        emprendimientoSeleccionado = emprendimientoProvider.emprendimientos.first.id;
      } else {
        // Si no está cargado, puedes cargarlo aquí si tienes el método adecuado
        Future.microtask(() async {
          await emprendimientoProvider.fetchEmprendimientos();
          setState(() {
            emprendimientoSeleccionado = emprendimientoProvider.emprendimientos.first.id;
          });
        });
      }
    }

    Future.microtask(() =>
      Provider.of<ServicioProvider>(context, listen: false).fetchServicios()
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    precioController.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<PaqueteTuristicoProvider>(context, listen: false);

    final paquete = PaqueteTuristicoModel(
      id: widget.paquete?.id,
      emprendimientoId: emprendimientoSeleccionado ?? widget.paquete?.emprendimientoId,
      nombre: nombreController.text,
      descripcion: descripcionController.text,
      precio: double.tryParse(precioController.text) ?? 0.0,
      estado: estadoSeleccionado,
      servicios: serviciosSeleccionados.toSet().toList(),
      imagenes: imagenes,
    );

    if (widget.paquete != null) {
      await provider.updatePaquete(paquete);
    } else {
      await provider.addPaquete(paquete);
    }

    if (context.mounted) Navigator.pop(context);
  }

  void _agregarImagen() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Agregar URL de imagen'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'https://...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    imagenes.add(controller.text);
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviciosProvider = Provider.of<ServicioProvider>(context);
    final servicios = serviciosProvider.servicios;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paquete != null ? 'Editar Paquete Turístico' : 'Nuevo Paquete Turístico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (isSuperAdmin)
                Consumer<EmprendimientoProvider>(
                  builder: (context, emprendimientoProvider, _) {
                    final emprendimientos = emprendimientoProvider.emprendimientos;
                    return DropdownButtonFormField<int>(
                      value: emprendimientoSeleccionado,
                      decoration: InputDecoration(labelText: 'Emprendimiento'),
                      items: emprendimientos.map((e) {
                        return DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.nombre ?? 'Sin nombre'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          emprendimientoSeleccionado = value;
                        });
                      },
                      validator: (v) => v == null ? 'Seleccione un emprendimiento' : null,
                    );
                  },
                ),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              DropdownButtonFormField<String>(
                value: estadoSeleccionado,
                decoration: InputDecoration(labelText: 'Estado'),
                items: estados.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado[0].toUpperCase() + estado.substring(1)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    estadoSeleccionado = value;
                  });
                },
                validator: (v) => v == null ? 'Seleccione un estado' : null,
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: Text('Servicios', style: TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  serviciosProvider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: servicios.map((servicio) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CheckboxListTile(
                                  value: serviciosSeleccionados.any((s) => s.id == servicio.id),
                                  title: Text(servicio.nombre ?? ''),
                                  subtitle: Text(servicio.descripcion ?? ''),
                                  onChanged: (selected) {
                                    setState(() {
                                      if (selected == true) {
                                        if (!serviciosSeleccionados.any((s) => s.id == servicio.id)) {
                                          serviciosSeleccionados.add(servicio);
                                        }
                                      } else {
                                        serviciosSeleccionados.removeWhere((s) => s.id == servicio.id);
                                      }
                                    });
                                  },
                                ),
                                Divider(),
                              ],
                            );
                          }).toList(),
                        ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Imágenes', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: [
                  ...imagenes.map((img) => Chip(
                        label: Text(img),
                        onDeleted: () {
                          setState(() {
                            imagenes.remove(img);
                          });
                        },
                      )),
                  ActionChip(
                    label: Text('Agregar'),
                    onPressed: _agregarImagen,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardar,
                child: Text(widget.paquete != null ? 'Actualizar' : 'Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
