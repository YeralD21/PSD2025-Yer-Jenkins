import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewpublic/paquetes_turisticos_public_screen.dart';
import 'viewpublic/lugares_turisticos_public_screen.dart';
import 'viewpublic/servicios_public_screen.dart';
import 'viewpublic/emprendimientos_public_screen.dart';
import '../../providers/paquete_turistico_provider.dart';
import '../../providers/lugar_turistico_provider.dart';
import '../../providers/servicio_provider.dart';
import '../../providers/emprendimiento_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/theme_provider.dart';

const Color kSelectedTabColorLight = Color(0xFF283593); // Indigo intenso para modo claro
const Color kSelectedTabColorDark = Color(0xFF6EC6F7);  // Celeste para modo oscuro

class GeneralHomeScreen extends StatefulWidget {
  const GeneralHomeScreen({Key? key}) : super(key: key);

  @override
  State<GeneralHomeScreen> createState() => _GeneralHomeScreenState();
}

class _GeneralHomeScreenState extends State<GeneralHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Para que se reconstruya y cambie el color del icono
    });

    // Carga inicial de datos usando Future.microtask
    Future.microtask(() {
      // Carga inicial de paquetes turísticos
      final paqueteProvider = Provider.of<PaqueteTuristicoProvider>(context, listen: false);
      if (paqueteProvider.paquetes.isEmpty && !paqueteProvider.isLoading) {
        paqueteProvider.fetchPaquetes();
      }

      // Carga inicial de lugares turísticos
      final lugarProvider = Provider.of<LugarTuristicoProvider>(context, listen: false);
      if (lugarProvider.lugares.isEmpty && !lugarProvider.isLoading) {
        lugarProvider.fetchLugares();
      }

      // Carga inicial de emprendimientos
      final emprendimientoProvider = Provider.of<EmprendimientoProvider>(context, listen: false);
      if (emprendimientoProvider.emprendimientos.isEmpty && !emprendimientoProvider.isLoading) {
        emprendimientoProvider.fetchEmprendimientos();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildPaquetesTab(BuildContext context) {
    final provider = Provider.of<PaqueteTuristicoProvider>(context);
    final paquetesFiltrados = provider.paquetes.where((p) {
      return p.nombre?.toLowerCase().contains(_searchText.toLowerCase()) ?? false;
    }).toList();

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (paquetesFiltrados.isEmpty) {
      return Center(child: Text('No hay paquetes turísticos'));
    }

    return ListView.builder(
      itemCount: paquetesFiltrados.length,
      itemBuilder: (context, index) {
        final paquete = paquetesFiltrados[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PaqueteTuristicoImageCarousel(index: index),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paquete.nombre ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      paquete.descripcion ?? '',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      paquete.precio != null ? 'S/ ${paquete.precio}' : '',
                      style: TextStyle(fontSize: 16, color: Colors.green[700], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLugaresTab(BuildContext context) {
    final provider = Provider.of<LugarTuristicoProvider>(context);
    print('Lugares en provider: ${provider.lugares.length}');
    final lugaresFiltrados = provider.lugares.where((l) {
      return l.nombre?.toLowerCase().contains(_searchText.toLowerCase()) ?? false;
    }).toList();

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (lugaresFiltrados.isEmpty) {
      return Center(child: Text('No hay lugares turísticos'));
    }

    return ListView.builder(
      itemCount: lugaresFiltrados.length,
      itemBuilder: (context, index) {
        final lugar = lugaresFiltrados[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LugarTuristicoImageCarousel(index: index),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lugar.nombre ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lugar.descripcion ?? '',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiciosTab(BuildContext context) {
    final provider = Provider.of<ServicioProvider>(context);
    final serviciosFiltrados = provider.servicios.where((s) {
      return s.nombre?.toLowerCase().contains(_searchText.toLowerCase()) ?? false;
    }).toList();

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (serviciosFiltrados.isEmpty) {
      return Center(child: Text('No hay servicios'));
    }

    return ListView.builder(
      itemCount: serviciosFiltrados.length,
      itemBuilder: (context, index) {
        final servicio = serviciosFiltrados[index];
        return Card(
          color: Theme.of(context).cardColor,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen (cuadro vacío por ahora)
              Container(
                height: 160,
                width: double.infinity,
                color: Colors.grey[300],
                child: Center(child: Icon(Icons.image, size: 60, color: Colors.grey[500])),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(servicio.nombre ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(servicio.descripcion ?? '', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    SizedBox(height: 8),
                    Text(
                      servicio.precioBase != null ? 'S/ ${servicio.precioBase}' : '',
                      style: TextStyle(fontSize: 16, color: Colors.green[700], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmprendimientosTab(BuildContext context) {
    final provider = Provider.of<EmprendimientoProvider>(context);
    print('Emprendimientos en provider: ${provider.emprendimientos.length}');
    final emprendimientosFiltrados = provider.emprendimientos.where((e) {
      return e.nombre?.toLowerCase().contains(_searchText.toLowerCase()) ?? false;
    }).toList();

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (emprendimientosFiltrados.isEmpty) {
      return Center(child: Text('No hay familias emprendedoras'));
    }

    return ListView.builder(
      itemCount: emprendimientosFiltrados.length,
      itemBuilder: (context, index) {
        final emprendimiento = emprendimientosFiltrados[index];
        return Card(
          color: Theme.of(context).cardColor,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen (cuadro vacío por ahora)
              Container(
                height: 160,
                width: double.infinity,
                color: Colors.grey[300],
                child: Center(child: Icon(Icons.image, size: 60, color: Colors.grey[500])),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(emprendimiento.nombre ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(emprendimiento.descripcion ?? '', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTabColor = isDark ? kSelectedTabColorDark : kSelectedTabColorLight;
    final menuIconColor = isDark ? kSelectedTabColorDark : kSelectedTabColorLight;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barra de búsqueda + menú
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Empieza la búsqueda',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: Image.asset(
                      'assets/menu.png',
                      width: 32,
                      height: 32,
                      color: menuIconColor,
                    ),
                    onSelected: (value) {
                      if (value == 'login') {
                        Navigator.pushNamed(context, '/login');
                      } else if (value == 'theme') {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                      }
                      // Configuración y Acerca de Nosotros no hacen nada por ahora
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'login',
                        child: Row(
                          children: [
                            Icon(Icons.login, color: menuIconColor),
                            SizedBox(width: 8),
                            Text('Iniciar sesión'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'theme',
                        child: Row(
                          children: [
                            Icon(Icons.brightness_6, color: menuIconColor),
                            SizedBox(width: 8),
                            Text(isDark ? 'Modo Día' : 'Modo Noche'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'config',
                        child: Row(
                          children: [
                            Icon(Icons.settings, color: menuIconColor),
                            SizedBox(width: 8),
                            Text('Configuración'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'about',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: menuIconColor),
                            SizedBox(width: 8),
                            Text('Acerca de Nosotros'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // TabBar
            TabBar(
              controller: _tabController,
              labelColor: selectedTabColor,
              unselectedLabelColor: Colors.grey[500],
              indicatorColor: selectedTabColor,
              tabs: [
                Tab(
                  icon: Icon(Icons.place, color: _tabController.index == 0 ? selectedTabColor : Colors.grey[500]),
                  text: 'Lugares',
                ),
                Tab(
                  icon: Icon(Icons.card_travel, color: _tabController.index == 1 ? selectedTabColor : Colors.grey[500]),
                  text: 'Paquetes',
                ),
                Tab(
                  icon: Icon(Icons.room_service, color: _tabController.index == 2 ? selectedTabColor : Colors.grey[500]),
                  text: 'Servicios',
                ),
                Tab(
                  icon: Icon(Icons.groups, color: _tabController.index == 3 ? selectedTabColor : Colors.grey[500]),
                  text: 'Familias Emprendedoras',
                ),
              ],
            ),
            // El resto de la pantalla (TabBarView)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLugaresTab(context),
                  _buildPaquetesTab(context),
                  _buildServiciosTab(context),
                  _buildEmprendimientosTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LugarTuristicoImageCarousel extends StatefulWidget {
  final int index;
  const _LugarTuristicoImageCarousel({required this.index});

  @override
  State<_LugarTuristicoImageCarousel> createState() => _LugarTuristicoImageCarouselState();
}

class _LugarTuristicoImageCarouselState extends State<_LugarTuristicoImageCarousel> {
  int _currentPage = 0;

  List<String> _getImageList(int index) {
    // Máximo 5 imágenes por lugar
    List<String> images = [
      'assets/lugares-turisticos/lugar-turistico${index + 1}.jpg',
    ];
    for (int i = 1; i <= 5; i++) {
      final imgPath = 'assets/lugares-turisticos/lugar-turistico-line${index + 1}-$i.jpg';
      // Si existe el archivo, lo agregas. Si no, lo ignoras.
      // Como Flutter no tiene acceso directo al filesystem en assets, simplemente asume que existen.
      images.add(imgPath);
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    final images = _getImageList(widget.index);

    return Column(
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.88,
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: PageView.builder(
                itemCount: images.length,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, i) {
                  return Image.asset(
                    images[i],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Indicador de puntos
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (i) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == i ? 10 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == i ? Colors.blueAccent : Colors.grey[400],
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _PaqueteTuristicoImageCarousel extends StatefulWidget {
  final int index;
  const _PaqueteTuristicoImageCarousel({required this.index});

  @override
  State<_PaqueteTuristicoImageCarousel> createState() => _PaqueteTuristicoImageCarouselState();
}

class _PaqueteTuristicoImageCarouselState extends State<_PaqueteTuristicoImageCarousel> {
  int _currentPage = 0;

  List<String> _getImageList(int index) {
    // Máximo 5 imágenes por paquete
    List<String> images = [
      'assets/paquetes-turisticos/paquete-turistico${index + 1}.jpg',
    ];
    for (int i = 1; i <= 5; i++) {
      final imgPath = 'assets/paquetes-turisticos/paquete-turistico-line${index + 1}-$i.jpg';
      images.add(imgPath);
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    final images = _getImageList(widget.index);

    return Column(
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.88,
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: PageView.builder(
                itemCount: images.length,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, i) {
                  return Image.asset(
                    images[i],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Indicador de puntos
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (i) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == i ? 10 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == i ? Colors.blueAccent : Colors.grey[400],
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
