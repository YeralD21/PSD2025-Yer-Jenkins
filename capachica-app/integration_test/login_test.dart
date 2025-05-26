import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:capachica/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Solo login', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 1. Tap en el botón de menú (3 líneas horizontales)
    // Suponiendo que es el único PopupMenuButton en la pantalla
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();

    // 2. Tap en la opción "Iniciar sesión"
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    // 3. Ahora sí, ingresa usuario y contraseña en la pantalla de login
    await tester.enterText(find.widgetWithText(TextFormField, 'Correo electrónico'), 'admin@tourcapachica.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Contraseña'), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'INICIAR SESIÓN'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 4. Verifica que navega al panel de SuperAdmin
    expect(find.text('Panel de SuperAdmin'), findsOneWidget);
  });
}
