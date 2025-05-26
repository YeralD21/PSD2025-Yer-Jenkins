//import 'package:capachica/features/panels/emprendedor/data/repositories/emprendedor_repository.dart';
//import 'package:capachica/features/panels/super_admin/data/repositories/superadmin_repository.dart';
//import 'package:capachica/features/panels/super_admin/providers/superadmin_provider.dart';
//import 'package:capachica/features/panels/user/data/repositories/user_repository.dart';
import 'package:capachica/core/api/api_client.dart';
import 'package:capachica/features/panels/emprendedor/data/repositories/emprendedor_repository.dart';
import 'package:capachica/features/panels/superadmin/data/repositories/superadmin_repository.dart';
import 'package:capachica/features/panels/user/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'features/auth/presentation/screens/register_screen.dart';

// Importa tus providers y screens
import 'features/panels/superadmin/providers/superadmin_provider.dart';
import 'features/panels/superadmin/presentation/screens/superadmin_home_screen.dart';

import 'features/panels/emprendedor/providers/emprendedor_provider.dart';
import 'features/panels/emprendedor/presentation/screens/emprendedor_home_screen.dart';

import 'features/panels/user/providers/user_provider.dart';
import 'features/panels/user/presentation/screens/user_home_screen.dart';

// Importa tu AuthProvider
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';

import 'features/panels/superadmin/providers/permiso_provider.dart';
import 'features/panels/superadmin/data/repositories/permiso_repository.dart';

import 'features/panels/superadmin/providers/rol_provider.dart';
import 'features/panels/superadmin/data/repositories/rol_repository.dart';

import 'features/panels/superadmin/presentation/screens/roles_screen.dart';

import 'package:capachica/features/shared/providers/emprendimiento_provider.dart';
import 'package:capachica/features/shared/data/repositories/emprendimiento_repository.dart';
import 'package:capachica/features/shared/providers/servicio_provider.dart';
import 'package:capachica/features/shared/data/repositories/servicio_repository.dart';
import 'package:capachica/features/shared/providers/tipo_servicio_provider.dart';
import 'package:capachica/features/shared/data/repositories/tipo_servicio_repository.dart';
import 'package:capachica/features/shared/providers/disponibilidad_provider.dart';
import 'package:capachica/features/shared/data/repositories/disponibilidad_repository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:capachica/features/shared/providers/paquete_turistico_provider.dart';
import 'package:capachica/features/shared/data/repositories/paquete_turistico_repository.dart';
import 'package:capachica/features/shared/data/repositories/lugar_turistico_repository.dart';
import 'package:capachica/features/shared/providers/lugar_turistico_provider.dart';
import 'features/shared/presentation/screens/general_home_screen.dart';
import 'package:capachica/features/shared/providers/theme_provider.dart';

void main() {
  final apiClient = ApiClient();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(apiClient)),
        ChangeNotifierProvider(create: (_) => SuperAdminProvider(SuperAdminRepository())),
        ChangeNotifierProvider(create: (_) => EmprendedorProvider(EmprendedorRepository())),
        ChangeNotifierProvider(create: (_) => UserProvider(UserRepository())),
        ChangeNotifierProvider(
          create: (context) => PermisoProvider(
            PermisoRepository(apiClient),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RolProvider(RolRepository(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => EmprendimientoProvider(EmprendimientoRepository(apiClient.dio)),
        ),
        ChangeNotifierProvider(
          create: (_) => ServicioProvider(ServicioRepository(apiClient.dio)),
        ),
        ChangeNotifierProvider(
          create: (_) => TipoServicioProvider(TipoServicioRepository(apiClient.dio)),
        ),
        ChangeNotifierProvider(
          create: (_) => DisponibilidadProvider(DisponibilidadRepository(apiClient.dio)),
        ),
        ChangeNotifierProvider(
          create: (_) => PaqueteTuristicoProvider(PaqueteTuristicoRepository(apiClient.dio)),
        ),
        ChangeNotifierProvider(
          create: (_) => LugarTuristicoProvider(
            LugarTuristicoRepository(dio: Dio()),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        Widget home;

        if (authProvider.status == AuthStatus.authenticated) {
          switch (authProvider.userRole) {
            case 'superadmin':
              home = SuperAdminHomeScreen();
              break;
            case 'emprendedor':
              home = EmprendedorHomeScreen();
              break;
            case 'user':
              home = UserHomeScreen();
              break;
            default:
              home = GeneralHomeScreen();
          }
        } else {
          home = GeneralHomeScreen();
        }

        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp(
              title: 'App por Roles',
              theme: ThemeData.light(),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: Color(0xFF23232B), // Gris oscuro elegante
                cardColor: Color(0xFF2C2C36),
                appBarTheme: AppBarTheme(
                  backgroundColor: Color(0xFF23232B),
                  iconTheme: IconThemeData(color: Colors.white),
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                textTheme: TextTheme(
                  bodyLarge: TextStyle(color: Colors.white),
                  bodyMedium: TextStyle(color: Colors.white),
                  titleLarge: TextStyle(color: Colors.white),
                  titleMedium: TextStyle(color: Colors.white),
                  titleSmall: TextStyle(color: Colors.white),
                  labelLarge: TextStyle(color: Colors.white),
                  labelMedium: TextStyle(color: Colors.white),
                  labelSmall: TextStyle(color: Colors.white),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Color(0xFF2C2C36),
                  hintStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                iconTheme: IconThemeData(color: Colors.white),
                popupMenuTheme: PopupMenuThemeData(
                  color: Color(0xFF2C2C36),
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
              themeMode: themeProvider.themeMode,
              home: home,
              routes: {
                '/login': (_) => LoginScreen(),
                '/register': (_) => RegisterScreen(), 
                '/superadmin': (_) => SuperAdminHomeScreen(),
                '/emprendedor': (_) => EmprendedorHomeScreen(),
                '/user': (_) => UserHomeScreen(),
                '/roles': (_) => RolesScreen(),
              },
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('es', ''), // Español
                Locale('en', ''), // Inglés (opcional)
              ],
            );
          },
        );
      },
    );
  }
}