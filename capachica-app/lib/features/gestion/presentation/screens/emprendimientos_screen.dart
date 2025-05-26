import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/emprendimiento_provider.dart';

class EmprendimientosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Emprendimientos')),
      body: Center(child: Text('Aquí va la gestión de emprendimientos')),
    );
  }
}