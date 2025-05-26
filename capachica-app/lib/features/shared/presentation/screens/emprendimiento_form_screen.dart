import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/emprendimiento_model.dart';
import '../../providers/emprendimiento_provider.dart';
import '../../providers/tipo_servicio_provider.dart';
import 'dart:convert';

class EmprendimientoFormScreen extends StatefulWidget {
  final EmprendimientoModel? emprendimiento;
  final int usuarioId;
  final bool isEditing;

  const EmprendimientoFormScreen({
    super.key,
    this.emprendimiento,
    required this.usuarioId,
  }) : isEditing = emprendimiento != null;

  @override
  State<EmprendimientoFormScreen> createState() => _EmprendimientoFormScreenState();
}

class _EmprendimientoFormScreenState extends State<EmprendimientoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Campos del formulario
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController tipoController;
  late TextEditingController direccionController;
  late TextEditingController coordenadasController;
  late TextEditingController contactoTelefonoController;
  late TextEditingController contactoEmailController;
  late TextEditingController sitioWebController;
  late TextEditingController facebookController;
  late TextEditingController instagramController;
  late TextEditingController estadoController;

  final List<String> estados = ['pendiente', 'aprobado', 'rechazado'];
  final List<String> tiposEmprendimiento = ['restaurante', 'hospedaje', 'artesania', 'otro'];
  String? tipoSeleccionado;
  String? estadoSeleccionado = 'PENDIENTE'; // Valor por defecto

  @override
  void initState() {
    super.initState();
    final e = widget.emprendimiento;
    nombreController = TextEditingController(text: e?.nombre ?? '');
    descripcionController = TextEditingController(text: e?.descripcion ?? '');
    tipoController = TextEditingController(text: e?.tipo ?? '');
    direccionController = TextEditingController(text: e?.direccion ?? '');
    coordenadasController = TextEditingController(text: e?.coordenadas ?? '');
    contactoTelefonoController = TextEditingController(text: e?.contactoTelefono ?? '');
    contactoEmailController = TextEditingController(text: e?.contactoEmail ?? '');
    sitioWebController = TextEditingController(text: e?.sitioWeb ?? '');
    facebookController = TextEditingController(text: e?.redesSociales?['facebook'] ?? '');
    instagramController = TextEditingController(text: e?.redesSociales?['instagram'] ?? '');
    estadoController = TextEditingController(text: e?.estado ?? 'pendiente');
    tipoSeleccionado = (e?.tipo?.toLowerCase() ?? tiposEmprendimiento.first);
    if (!tiposEmprendimiento.contains(tipoSeleccionado)) {
      tipoSeleccionado = tiposEmprendimiento.first;
    }
    estadoSeleccionado = (e?.estado?.toLowerCase() ?? estados.first);
    if (!estados.contains(estadoSeleccionado)) {
      estadoSeleccionado = estados.first;
    }
    final tipoServicioProvider = Provider.of<TipoServicioProvider>(context, listen: false);
    if (tipoServicioProvider.tiposServicio.isEmpty) {
      Future.microtask(() => tipoServicioProvider.fetchTiposServicio());
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    tipoController.dispose();
    direccionController.dispose();
    coordenadasController.dispose();
    contactoTelefonoController.dispose();
    contactoEmailController.dispose();
    sitioWebController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    estadoController.dispose();
    super.dispose();
  }

  void _guardar() async {
    print('Intentando guardar...');
    if (!_formKey.currentState!.validate()) {
      print('Formulario no válido');
      return;
    }
    if (tipoSeleccionado == null || estadoSeleccionado == null) {
      print('Tipo o estado no seleccionado');
      return;
    }
    print('Formulario válido, creando emprendimiento...');
    final provider = Provider.of<EmprendimientoProvider>(context, listen: false);

    final nuevo = EmprendimientoModel(
      id: widget.emprendimiento?.id,
      usuarioId: widget.usuarioId,
      nombre: nombreController.text,
      descripcion: descripcionController.text,
      tipo: tipoSeleccionado!,
      direccion: direccionController.text,
      coordenadas: coordenadasController.text,
      contactoTelefono: contactoTelefonoController.text,
      contactoEmail: contactoEmailController.text,
      sitioWeb: sitioWebController.text.isEmpty ? null : sitioWebController.text,
      redesSociales: {
        'facebook': facebookController.text,
        'instagram': instagramController.text,
      },
      estado: estadoSeleccionado!,
      fechaAprobacion: widget.emprendimiento?.fechaAprobacion,
      imagenes: widget.emprendimiento?.imagenes ?? [],
    );

    if (widget.isEditing) {
      await provider.updateEmprendimiento(nuevo);
    } else {
      await provider.addEmprendimiento(nuevo);
    }

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tipoServicioProvider = Provider.of<TipoServicioProvider>(context);

    final tipos = tipoServicioProvider.tiposServicio.map((tipo) => tipo.nombre).toList();
    // if (tipoSeleccionado != null && !tipos.contains(tipoSeleccionado)) {
    //   tipoSeleccionado = null; // O tipos.isNotEmpty ? tipos.first : null;
    // }

    if (tipoServicioProvider.tiposServicio.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.isEditing ? 'Editar Emprendimiento' : 'Nuevo Emprendimiento')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar Emprendimiento' : 'Nuevo Emprendimiento'),
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
              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                decoration: InputDecoration(labelText: 'Tipo'),
                items: tiposEmprendimiento.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo[0].toUpperCase() + tipo.substring(1)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    tipoSeleccionado = value;
                  });
                },
                validator: (v) => v == null ? 'Selecciona un tipo' : null,
              ),
              TextFormField(
                controller: direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: coordenadasController,
                decoration: InputDecoration(labelText: 'Coordenadas'),
              ),
              TextFormField(
                controller: contactoTelefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: contactoEmailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: sitioWebController,
                decoration: InputDecoration(labelText: 'Sitio Web'),
              ),
              TextFormField(
                controller: facebookController,
                decoration: InputDecoration(labelText: 'Facebook'),
              ),
              TextFormField(
                controller: instagramController,
                decoration: InputDecoration(labelText: 'Instagram'),
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
                validator: (v) => v == null ? 'Selecciona un estado' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardar,
                child: Text(widget.isEditing ? 'Actualizar' : 'Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
