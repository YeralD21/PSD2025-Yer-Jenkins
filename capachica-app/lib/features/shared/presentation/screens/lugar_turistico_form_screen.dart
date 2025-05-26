import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/lugar_turistico_provider.dart';
import '../../data/models/lugar_turistico_model.dart';
import '../../../auth/providers/auth_provider.dart';

class LugarTuristicoFormScreen extends StatefulWidget {
  final LugarTuristicoModel? lugar;
  const LugarTuristicoFormScreen({Key? key, this.lugar}) : super(key: key);

  @override
  State<LugarTuristicoFormScreen> createState() => _LugarTuristicoFormScreenState();
}

class _LugarTuristicoFormScreenState extends State<LugarTuristicoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController direccionController;
  late TextEditingController coordenadasController;
  late TextEditingController estadoController;
  late TextEditingController recomendacionesController;
  late TextEditingController restriccionesController;
  late TextEditingController costoEntradaController;
  DateTime? horarioApertura;
  DateTime? horarioCierre;
  bool esDestacado = false;
  List<ImagenLugarTuristico> imagenes = [];

  @override
  void initState() {
    super.initState();
    final l = widget.lugar;
    nombreController = TextEditingController(text: l?.nombre ?? '');
    descripcionController = TextEditingController(text: l?.descripcion ?? '');
    direccionController = TextEditingController(text: l?.direccion ?? '');
    coordenadasController = TextEditingController(text: l?.coordenadas ?? '');
    estadoController = TextEditingController(text: l?.estado ?? 'activo');
    recomendacionesController = TextEditingController(text: l?.recomendaciones ?? '');
    restriccionesController = TextEditingController(text: l?.restricciones ?? '');
    costoEntradaController = TextEditingController(text: l?.costoEntrada?.toString() ?? '');
    horarioApertura = l?.horarioApertura;
    horarioCierre = l?.horarioCierre;
    esDestacado = l?.esDestacado ?? false;
    imagenes = l?.imagenes ?? [];
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    direccionController.dispose();
    coordenadasController.dispose();
    estadoController.dispose();
    recomendacionesController.dispose();
    restriccionesController.dispose();
    costoEntradaController.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (horarioApertura == null || horarioCierre == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debes seleccionar horario de apertura y cierre')),
      );
      return;
    }

    final provider = Provider.of<LugarTuristicoProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontró el token de autenticación. Inicia sesión nuevamente.')),
      );
      return;
    }

    final lugar = LugarTuristicoModel(
      id: widget.lugar?.id,
      nombre: nombreController.text,
      descripcion: descripcionController.text,
      direccion: direccionController.text,
      coordenadas: coordenadasController.text,
      estado: estadoController.text,
      esDestacado: esDestacado,
      horarioApertura: horarioApertura,
      horarioCierre: horarioCierre,
      costoEntrada: num.tryParse(costoEntradaController.text) ?? 0,
      recomendaciones: recomendacionesController.text,
      restricciones: restriccionesController.text,
      imagenes: imagenes,
    );

    if (widget.lugar != null) {
      await provider.updateLugar(lugar, token);
    } else {
      await provider.addLugar(lugar, token);
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
                    imagenes.add(ImagenLugarTuristico(url: controller.text));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lugar != null ? 'Editar Lugar Turístico' : 'Nuevo Lugar Turístico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                controller: direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: coordenadasController,
                decoration: InputDecoration(labelText: 'Coordenadas'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              SwitchListTile(
                title: Text('¿Es destacado?'),
                value: esDestacado,
                onChanged: (v) => setState(() => esDestacado = v),
              ),
              TextFormField(
                controller: costoEntradaController,
                decoration: InputDecoration(labelText: 'Costo de entrada'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: recomendacionesController,
                decoration: InputDecoration(labelText: 'Recomendaciones'),
              ),
              TextFormField(
                controller: restriccionesController,
                decoration: InputDecoration(labelText: 'Restricciones'),
              ),
              TextFormField(
                controller: estadoController,
                decoration: InputDecoration(labelText: 'Estado'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              ListTile(
                title: Text('Horario de apertura: ${horarioApertura != null ? horarioApertura!.toLocal().toString().substring(0, 16) : ''}'),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: horarioApertura ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(horarioApertura ?? DateTime.now()),
                    );
                    if (time != null) {
                      setState(() {
                        horarioApertura = DateTime(
                          picked.year, picked.month, picked.day, time.hour, time.minute);
                      });
                    }
                  }
                },
              ),
              ListTile(
                title: Text('Horario de cierre: ${horarioCierre != null ? horarioCierre!.toLocal().toString().substring(0, 16) : ''}'),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: horarioCierre ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(horarioCierre ?? DateTime.now()),
                    );
                    if (time != null) {
                      setState(() {
                        horarioCierre = DateTime(
                          picked.year, picked.month, picked.day, time.hour, time.minute);
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              Text('Imágenes', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: [
                  ...imagenes.map((img) => Chip(
                        label: Text(img.url),
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
                child: Text(widget.lugar != null ? 'Actualizar' : 'Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
