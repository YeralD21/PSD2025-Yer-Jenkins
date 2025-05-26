import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/paquete_turistico_provider.dart';

class PaquetesTuristicosPublicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaqueteTuristicoProvider>(context);

    if (provider.paquetes.isEmpty && !provider.isLoading) {
      Future.microtask(() => provider.fetchPaquetes());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Paquetes Turísticos'),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.paquetes.isEmpty
              ? Center(child: Text('No hay paquetes turísticos'))
              : ListView.builder(
                  itemCount: provider.paquetes.length,
                  itemBuilder: (context, index) {
                    final paquete = provider.paquetes[index];
                    return ListTile(
                      title: Text(paquete.nombre ?? ''),
                      subtitle: Text(paquete.descripcion ?? ''),
                    );
                  },
                ),
    );
  }
}
