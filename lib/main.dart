import 'package:flutter/material.dart';
import 'package:pos_replica/app/theme/app_theme.dart';
import 'package:pos_replica/features/products/presentation/pages/products_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InventaPro',
      theme: AppTheme.light,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late final List<_ScreenDestination> _destinations = [
    _ScreenDestination(
      label: 'Productos',
      icon: Icons.inventory_2_outlined,
      builder: (_) => const ProductsPage(),
    ),
    _ScreenDestination(
      label: 'Punto de venta',
      icon: Icons.point_of_sale_outlined,
      builder: (_) => const _ComingSoonPage(
        title: 'Punto de venta',
        icon: Icons.point_of_sale_outlined,
      ),
    ),
    _ScreenDestination(
      label: 'Detalle de factura',
      icon: Icons.receipt_long_outlined,
      builder: (_) => const _ComingSoonPage(
        title: 'Detalle de factura',
        icon: Icons.receipt_long_outlined,
      ),
    ),
    _ScreenDestination(
      label: 'Configuración',
      icon: Icons.settings_outlined,
      builder: (_) => const _ComingSoonPage(
        title: 'Configuración',
        icon: Icons.settings_outlined,
      ),
    ),
    _ScreenDestination(
      label: 'Escáner de código',
      icon: Icons.qr_code_scanner_rounded,
      builder: (_) => const _ComingSoonPage(
        title: 'Escáner de código',
        icon: Icons.qr_code_scanner_rounded,
      ),
    ),
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('You have pushed the button this many times:'),
                  const SizedBox(height: 8),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Vistas disponibles',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final destination in _destinations)
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: destination.builder,
                              ),
                            );
                          },
                          icon: Icon(destination.icon),
                          label: Text(destination.label),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ScreenDestination {
  const _ScreenDestination({
    required this.label,
    required this.icon,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final WidgetBuilder builder;
}

class _ComingSoonPage extends StatelessWidget {
  const _ComingSoonPage({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Esta vista aún no tiene un diseño implementado.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
