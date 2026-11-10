import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_replica/features/products/presentation/pages/products_page.dart';
import 'package:pos_replica/main.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('keeps the counter home and lists screen navigation buttons', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());

    expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Productos'), findsOneWidget);
    expect(find.text('Punto de venta'), findsOneWidget);
    expect(find.text('Detalle de factura'), findsOneWidget);
    expect(find.text('Configuración'), findsOneWidget);
    expect(find.text('Escáner de código'), findsOneWidget);

    await tester.tap(find.byTooltip('Increment'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('products button opens the product catalogue', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Productos'));
    await tester.pumpAndSettle();

    expect(find.text('Catálogo de Productos'), findsOneWidget);
    expect(find.text('Café Grano Gourmet 500g'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search filters the product catalogue', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ProductsPage()));
    await tester.enterText(find.byType(TextField), 'Aceite');
    await tester.pumpAndSettle();

    expect(find.text('Aceite de Oliva Extra Virgen'), findsOneWidget);
    expect(find.text('Café Grano Gourmet 500g'), findsNothing);
    expect(find.text('1 mostrados'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stock filters only show matching products', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ProductsPage()));
    await tester.tap(find.text('Agotados').first);
    await tester.pumpAndSettle();

    expect(find.text('Galletas de Avena & Miel'), findsOneWidget);
    expect(find.text('Aceite de Oliva Extra Virgen'), findsNothing);
    expect(find.text('1 mostrados'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
