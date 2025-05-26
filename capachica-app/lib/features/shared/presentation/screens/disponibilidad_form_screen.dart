import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/disponibilidad_provider.dart';
import '../../data/models/disponibilidad_model.dart';

class DisponibilidadFormScreen extends StatefulWidget {
  final DisponibilidadModel? disponibilidad;
  final int servicioId;

  const DisponibilidadFormScreen({super.key, this.disponibilidad, required this.servicioId});

  @override
  State<DisponibilidadFormScreen> createState() => _DisponibilidadFormScreenState();
}

class _DisponibilidadFormScreenState extends State<DisponibilidadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController fechaController;
  late TextEditingController cuposController;
  late TextEditingController precioController;

  @override
  void initState() {
    super.initState();
    final d = widget.disponibilidad;
    fechaController = TextEditingController(
      text: d?.fecha ?? ''
    );
    cuposController = TextEditingController(
      text: d?.cuposDisponibles?.toString() ?? ''
    );
    precioController = TextEditingController(
      text: d?.precioEspecial?.toString() ?? ''
    );
  }

  @override
  void dispose() {
    fechaController.dispose();
    cuposController.dispose();
    precioController.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<DisponibilidadProvider>(context, listen: false);

    final nueva = DisponibilidadModel(
      id: widget.disponibilidad?.id,
      servicioId: widget.servicioId,
      fecha: fechaController.text,
      cuposDisponibles: int.tryParse(cuposController.text) ?? 0,
      precioEspecial: double.tryParse(precioController.text) ?? 0.0,
    );

    if (widget.disponibilidad != null) {
      await provider.updateDisponibilidad(nueva);
    } else {
      await provider.addDisponibilidad(nueva);
    }

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.disponibilidad != null ? 'Editar Disponibilidad' : 'Nueva Disponibilidad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fechaController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha (YYYY-MM-DD)',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    locale: const Locale('es', ''),
                  );
                  if (pickedDate != null) {
                    fechaController.text = pickedDate.toIso8601String().split('T').first;
                    setState(() {});
                  }
                },
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: cuposController,
                decoration: InputDecoration(labelText: 'Cupos Disponibles'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: precioController,
                decoration: InputDecoration(labelText: 'Precio Especial'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardar,
                child: Text(widget.disponibilidad != null ? 'Actualizar' : 'Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
