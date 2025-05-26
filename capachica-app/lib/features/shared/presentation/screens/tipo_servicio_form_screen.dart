import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tipo_servicio_provider.dart';
import '../../data/models/tipo_servicio_model.dart';

class TipoServicioFormScreen extends StatefulWidget {
  final TipoServicio? tipoServicio;

  const TipoServicioFormScreen({super.key, this.tipoServicio});

  @override
  State<TipoServicioFormScreen> createState() => _TipoServicioFormScreenState();
}

class _TipoServicioFormScreenState extends State<TipoServicioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  bool requiereCupo = false;

  @override
  void initState() {
    super.initState();
    final t = widget.tipoServicio;
    nombreController = TextEditingController(text: t?.nombre ?? '');
    descripcionController = TextEditingController(text: t?.descripcion ?? '');
    requiereCupo = t?.requiereCupo ?? false;
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<TipoServicioProvider>(context, listen: false);

    final nuevo = TipoServicio(
      id: widget.tipoServicio?.id,
      nombre: nombreController.text,
      descripcion: descripcionController.text,
      requiereCupo: requiereCupo,
    );

    if (widget.tipoServicio != null) {
      await provider.repository.updateTipoServicio(nuevo);
    } else {
      await provider.repository.createTipoServicio(nuevo);
    }
    await provider.fetchTiposServicio();

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipoServicio != null ? 'Editar Tipo de Servicio' : 'Nuevo Tipo de Servicio'),
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
              SwitchListTile(
                title: Text('Requiere cupo'),
                value: requiereCupo,
                onChanged: (v) => setState(() => requiereCupo = v),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardar,
                child: Text(widget.tipoServicio != null ? 'Actualizar' : 'Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
