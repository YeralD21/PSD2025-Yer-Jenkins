// lib/features/gestion/presentation/screens/gestion_accesos.dart

import 'package:flutter/material.dart';
import 'emprendimientos_screen.dart';
import 'servicios_screen.dart';
import 'paquetes_screen.dart';
import 'reservas_screen.dart';
import 'pagos_screen.dart';

final List<Map<String, dynamic>> accesosGestion = [
  {
    'nombre': 'Gestión de Emprendimientos',
    'icon': Icons.business,
    'screen': EmprendimientosScreen(),
  },
  {
    'nombre': 'Gestión de Servicios',
    'icon': Icons.room_service,
    'screen': ServiciosScreen(),
  },
  {
    'nombre': 'Gestión de Paquetes',
    'icon': Icons.card_travel,
    'screen': PaquetesScreen(),
  },
  {
    'nombre': 'Gestión de Reservas',
    'icon': Icons.book_online,
    'screen': ReservasScreen(),
  },
  {
    'nombre': 'Gestión de Pagos',
    'icon': Icons.payment,
    'screen': PagosScreen(),
  },
  // Puedes agregar más accesos si lo deseas
];