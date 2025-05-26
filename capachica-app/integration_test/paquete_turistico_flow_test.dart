import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:capachica/main.dart' as app;
import 'package:capachica/features/shared/data/models/paquete_turistico_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capachica/features/shared/providers/paquete_turistico_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Flujo de Gestión de Paquetes Turísticos', () {
    testWidgets('Flujo completo de gestión de paquete turístico', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print('Antes de login');
      await tester.enterText(find.widgetWithText(TextFormField, 'Correo electrónico'), 'admin@example.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Contraseña'), 'admin123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'INICIAR SESIÓN'));
      await tester.pumpAndSettle();
      print('Después de login');

      print('Antes de tap en Gestión de Paquetes Turísticos');
      final paqueteCard = find.descendant(
        of: find.byType(GridView),
        matching: find.text('Gestión de Paquetes Turísticos'),
      );
      expect(paqueteCard, findsOneWidget, reason: 'No se encontró el texto en el GridView');
      await tester.tap(paqueteCard);
      await tester.pumpAndSettle();
      print('Después de tap en Gestión de Paquetes Turísticos');

      expect(find.text('Paquetes Turísticos'), findsOneWidget);

      print('Antes de tap en FloatingActionButton');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      print('Después de tap en FloatingActionButton');

      print('Antes de llenar formulario');
      await tester.enterText(find.widgetWithText(TextFormField, 'Nombre'), 'Tour Capachica Completo');
      await tester.enterText(find.widgetWithText(TextFormField, 'Descripción'), 'Descripción del tour completo por Capachica');
      await tester.enterText(find.widgetWithText(TextFormField, 'Precio'), '150.00');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Crear'));
      await tester.pumpAndSettle();
      print('Después de crear paquete');

      expect(find.text('Tour Capachica Completo'), findsOneWidget);

      // Editar paquete turístico
      await tester.tap(find.widgetWithText(ListTile, 'Tour Capachica Completo'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Nombre'), 'Tour Capachica Premium');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Actualizar'));
      await tester.pumpAndSettle();

      expect(find.text('Tour Capachica Premium'), findsOneWidget);

      // Eliminar paquete turístico
      await tester.tap(find.widgetWithText(ListTile, 'Tour Capachica Premium'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      expect(find.text('Tour Capachica Premium'), findsNothing);
    });

    testWidgets('Usuario normal ve y filtra paquetes', (WidgetTester tester) async {
      // Login como usuario normal
      await tester.enterText(find.byType(TextField).first, 'usuario@example.com');
      await tester.enterText(find.byType(TextField).last, 'user123');
      await tester.tap(find.text('Iniciar Sesión'));
      await tester.pumpAndSettle();

      // Ir a la sección de paquetes turísticos
      await tester.tap(find.text('Gestión de Paquetes Turísticos'));
      await tester.pumpAndSettle();

      // Verificar que puede ver la lista
      expect(find.byType(ListView), findsOneWidget);
      
      // Verificar que no puede crear/editar/eliminar
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.byIcon(Icons.edit), findsNothing);
      expect(find.byIcon(Icons.delete), findsNothing);

      // Probar filtrado
      await tester.enterText(find.byType(TextField).first, 'Tour');
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Solo login', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print('Antes de login');
      await tester.enterText(find.widgetWithText(TextFormField, 'Correo electrónico'), 'admin@example.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Contraseña'), 'admin123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'INICIAR SESIÓN'));
      await tester.pumpAndSettle();
      print('Después de login');
    });
  });
} 