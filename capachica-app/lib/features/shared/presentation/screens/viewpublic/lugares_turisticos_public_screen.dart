import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/lugar_turistico_provider.dart';

class LugaresTuristicosPublicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LugarTuristicoProvider>(context);

    // Si no has cargado los lugares, puedes hacerlo aquí:
    if (provider.lugares.isEmpty && !provider.isLoading) {
      Future.microtask(() => provider.fetchLugares());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lugares Turísticos'),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.lugares.isEmpty
              ? Center(child: Text('No hay lugares turísticos'))
              : ListView.builder(
                  itemCount: provider.lugares.length,
                  itemBuilder: (context, index) {
                    final lugar = provider.lugares[index];
                    return ListTile(
                      title: Text(lugar.nombre ?? ''),
                      subtitle: Text(lugar.descripcion ?? ''),
                      // Puedes agregar más campos si lo deseas, pero NO botones de editar/eliminar
                      // Si quieres, puedes navegar a un detalle público aquí
                    );
                  },
                ),
    );
  }
}
