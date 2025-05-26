import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/servicio_provider.dart';

class ServiciosPublicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ServicioProvider>(context);

    if (provider.servicios.isEmpty && !provider.isLoading) {
      Future.microtask(() => provider.fetchServicios());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Servicios'),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.servicios.isEmpty
              ? Center(child: Text('No hay servicios'))
              : ListView.builder(
                  itemCount: provider.servicios.length,
                  itemBuilder: (context, index) {
                    final servicio = provider.servicios[index];
                    return ListTile(
                      title: Text(servicio.nombre ?? ''),
                      subtitle: Text(servicio.descripcion ?? ''),
                    );
                  },
                ),
    );
  }
}
