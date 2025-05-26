import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/servicio_provider.dart';
import '../../data/models/servicio_model.dart';
import '../../providers/tipo_servicio_provider.dart';
import '../../data/models/tipo_servicio_model.dart';

class ServicioFormScreen extends StatefulWidget {
  final ServicioModel? servicio;

  const ServicioFormScreen({super.key, this.servicio});

  @override
  State<ServicioFormScreen> createState() => _ServicioFormScreenState();
}

class _ServicioFormScreenState extends State<ServicioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController precioBaseController;
  late TextEditingController monedaController;
  late TextEditingController estadoController;
  late TextEditingController duracionController;
  late TextEditingController capacidadController;
  late TextEditingController incluyeController;
  late TextEditingController requisitosController;
  late int? tipoServicioId;
  List<String> imagenes = [];

  final List<String> estados = ['activo', 'inactivo', 'pendiente'];
  final List<String> monedas = ['PEN', 'USD', 'EUR'];

  @override
  void initState() {
    super.initState();
    final s = widget.servicio;
    nombreController = TextEditingController(text: s?.nombre ?? '');
    descripcionController = TextEditingController(text: s?.descripcion ?? '');
    precioBaseController = TextEditingController(text: s?.precioBase?.toString() ?? '');
    monedaController = TextEditingController(text: s?.moneda ?? 'PEN');
    estadoController = TextEditingController(text: s?.estado?.toLowerCase() ?? 'activo');
    duracionController = TextEditingController(text: s?.detallesServicio.duracion ?? '');
    capacidadController = TextEditingController(text: s?.detallesServicio.capacidad?.toString() ?? '');
    incluyeController = TextEditingController(text: s?.detallesServicio.incluye?.join(', ') ?? '');
    requisitosController = TextEditingController(text: s?.detallesServicio.requisitos?.join(', ') ?? '');
    tipoServicioId = s?.tipoServicioId;
    imagenes = s?.imagenes.map((img) => img.url).toList() ?? [];
    Future.microtask(() =>
      Provider.of<TipoServicioProvider>(context, listen: false).fetchTiposServicio()
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    precioBaseController.dispose();
    monedaController.dispose();
    estadoController.dispose();
    duracionController.dispose();
    capacidadController.dispose();
    incluyeController.dispose();
    requisitosController.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (tipoServicioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar un tipo de servicio')),
      );
      return;
    }

    final provider = Provider.of<ServicioProvider>(context, listen: false);

    final detallesServicio = DetallesServicio(
      duracion: duracionController.text,
      capacidad: int.tryParse(capacidadController.text),
      incluye: incluyeController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      requisitos: requisitosController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
    );

    final nuevo = ServicioModel(
      id: widget.servicio?.id,
      nombre: nombreController.text,
      descripcion: descripcionController.text,
      precioBase: double.tryParse(precioBaseController.text) ?? 0.0,
      moneda: monedaController.text,
      estado: estadoController.text,
      tipoServicioId: tipoServicioId!,
      detallesServicio: detallesServicio,
      imagenes: imagenes.map((url) => ServicioImagen(url: url)).toList(),
    );

    if (widget.servicio != null) {
      await provider.updateServicio(nuevo);
    } else {
      await provider.addServicio(nuevo);
    }

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.servicio != null ? 'Editar Servicio' : 'Nuevo Servicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: precioBaseController,
                decoration: const InputDecoration(
                  labelText: 'Precio Base',
                  border: OutlineInputBorder(),
                  prefixText: 'S/ ',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo requerido';
                  if (double.tryParse(v) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: monedaController.text,
                decoration: const InputDecoration(
                  labelText: 'Moneda',
                  border: OutlineInputBorder(),
                ),
                items: monedas.map((moneda) {
                  return DropdownMenuItem(
                    value: moneda,
                    child: Text(moneda),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      monedaController.text = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: estadoController.text,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                items: estados.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado[0].toUpperCase() + estado.substring(1)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      estadoController.text = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Consumer<TipoServicioProvider>(
                builder: (context, tipoServicioProvider, child) {
                  final tipos = tipoServicioProvider.tiposServicio;
                  if (tipos.isEmpty) {
                    return const CircularProgressIndicator();
                  }
                  return DropdownButtonFormField<int>(
                    value: tipoServicioId,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Servicio',
                      border: OutlineInputBorder(),
                    ),
                    items: tipos.map((tipo) {
                      return DropdownMenuItem(
                        value: tipo.id,
                        child: Text(tipo.nombre ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        tipoServicioId = value;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text('Detalles del Servicio', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: duracionController,
                decoration: const InputDecoration(
                  labelText: 'Duración',
                  border: OutlineInputBorder(),
                  helperText: 'Ejemplo: 2 horas, 1 día, etc.',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: capacidadController,
                decoration: const InputDecoration(
                  labelText: 'Capacidad',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  if (int.tryParse(v) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: incluyeController,
                decoration: const InputDecoration(
                  labelText: 'Incluye',
                  border: OutlineInputBorder(),
                  helperText: 'Ingrese los elementos incluidos separados por comas',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: requisitosController,
                decoration: const InputDecoration(
                  labelText: 'Requisitos',
                  border: OutlineInputBorder(),
                  helperText: 'Ingrese los requisitos separados por comas',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  widget.servicio != null ? 'Actualizar Servicio' : 'Crear Servicio',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
