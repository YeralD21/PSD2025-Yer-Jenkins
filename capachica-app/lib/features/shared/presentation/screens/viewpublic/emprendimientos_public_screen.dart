import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/emprendimiento_provider.dart';

class EmprendimientosPublicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmprendimientoProvider>(context);

    if (provider.emprendimientos.isEmpty && !provider.isLoading) {
      Future.microtask(() => provider.fetchEmprendimientos());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Emprendimientos'),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.emprendimientos.isEmpty
              ? Center(child: Text('No hay emprendimientos'))
              : ListView.builder(
                  itemCount: provider.emprendimientos.length,
                  itemBuilder: (context, index) {
                    final emprendimiento = provider.emprendimientos[index];
                    return ListTile(
                      title: Text(emprendimiento.nombre ?? ''),
                      subtitle: Text(emprendimiento.descripcion ?? ''),
                    );
                  },
                ),
    );
  }
}
