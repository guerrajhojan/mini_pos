import 'package:flutter/material.dart';
import 'package:pos_replica/core/widgets/buttons/icon_button.dart';
import 'package:pos_replica/core/widgets/buttons/primary_button.dart';
import 'package:pos_replica/core/widgets/buttons/secondary_button.dart';
import 'package:pos_replica/core/widgets/cards/app_card.dart';
import 'package:pos_replica/core/widgets/cards/info_card.dart';
import 'package:pos_replica/core/widgets/cards/statistic_card.dart';
import 'package:pos_replica/core/widgets/dialogs/alert_dialog.dart';
import 'package:pos_replica/core/widgets/dialogs/confirm_dialog.dart';
import 'package:pos_replica/core/widgets/feedback/empty_view.dart';
import 'package:pos_replica/core/widgets/fields/app_date_field.dart';
import 'package:pos_replica/core/widgets/fields/app_dropdown.dart';
import 'package:pos_replica/core/widgets/fields/app_search_field.dart';
import 'package:pos_replica/core/widgets/fields/app_text_field.dart';
import 'package:pos_replica/core/widgets/layout/app_header.dart';
import 'package:pos_replica/core/widgets/layout/app_sidebar.dart';
import 'package:pos_replica/core/widgets/layout/page_container.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  static const _categories = ['Bebidas', 'Abarrotes', 'Snacks', 'Limpieza'];

  final _searchController = TextEditingController();
  final List<_Product> _products = [
    const _Product(
      name: 'Café Grano Gourmet 500g',
      sku: 'CF-00921',
      category: 'Bebidas',
      price: 14.50,
      cost: 8.20,
      barcode: '750103049210',
      stock: 18,
      icon: Icons.coffee_rounded,
      packageSize: '500g',
    ),
    const _Product(
      name: 'Aceite de Oliva Extra Virgen',
      sku: 'AC-00104',
      category: 'Abarrotes',
      price: 22,
      cost: 15,
      barcode: '750102048192',
      stock: 3,
      icon: Icons.oil_barrel_outlined,
      packageSize: '1L',
    ),
    const _Product(
      name: 'Galletas de Avena & Miel',
      sku: 'GL-00445',
      category: 'Snacks',
      price: 4.80,
      cost: 2.40,
      barcode: '750104928173',
      stock: 0,
      icon: Icons.cookie_outlined,
      packageSize: '300g',
    ),
    const _Product(
      name: 'Arroz Integral Grano Largo',
      sku: 'AR-00312',
      category: 'Abarrotes',
      price: 3.90,
      cost: 2.10,
      barcode: '750109384721',
      stock: 45,
      icon: Icons.grain_rounded,
      packageSize: '1kg',
    ),
  ];

  String _query = '';
  String _stockFilter = 'Todos';
  String _sortOrder = 'Recomendados';
  String _location = 'Principal';
  DateTime? _expiryBefore;
  int _selectedNavigationIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Product> get _visibleProducts {
    final normalizedQuery = _query.trim().toLowerCase();
    final products = _products.where((product) {
      final matchesQuery =
          normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.sku.toLowerCase().contains(normalizedQuery) ||
          product.barcode.contains(normalizedQuery);
      final matchesStock = switch (_stockFilter) {
        'Bajo Stock' => product.stock > 0 && product.stock <= 5,
        'Agotados' => product.stock == 0,
        _ => true,
      };
      final matchesExpiry =
          _expiryBefore == null ||
          product.expiryDate == null ||
          !product.expiryDate!.isAfter(_expiryBefore!);
      return matchesQuery && matchesStock && matchesExpiry;
    }).toList();

    switch (_sortOrder) {
      case 'Nombre A-Z':
        products.sort((a, b) => a.name.compareTo(b.name));
      case 'Nombre Z-A':
        products.sort((a, b) => b.name.compareTo(a.name));
      case 'Precio: menor a mayor':
        products.sort((a, b) => a.price.compareTo(b.price));
      case 'Precio: mayor a menor':
        products.sort((a, b) => b.price.compareTo(a.price));
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            brand: 'InventaPro',
            location: _location,
            locations: const ['Principal', 'Sucursal Norte', 'Sucursal Sur'],
            avatarInitials: 'JG',
            onLocationChanged: (value) => setState(() => _location = value),
            onAvatarTap: _showProfile,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 900) {
                  return Row(
                    children: [
                      AppSidebar(
                        destinations: _railDestinations,
                        selectedIndex: _selectedNavigationIndex,
                        onDestinationSelected: _onNavigationSelected,
                      ),
                      Expanded(child: _buildCatalog(products)),
                    ],
                  );
                }
                return _buildCatalog(products);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: PrimaryButton(
        label: 'Nuevo Producto',
        icon: Icons.add_rounded,
        onPressed: _showAddProductDialog,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return const SizedBox.shrink();
          }
          return NavigationBar(
            height: 68,
            selectedIndex: _selectedNavigationIndex,
            onDestinationSelected: _onNavigationSelected,
            destinations: _navigationDestinations,
          );
        },
      ),
    );
  }

  static const _navigationDestinations = [
    NavigationDestination(
      icon: Icon(Icons.inventory_2_outlined),
      selectedIcon: Icon(Icons.inventory_2_rounded),
      label: 'Productos',
    ),
    NavigationDestination(
      icon: Icon(Icons.add_circle_outline_rounded),
      label: 'Nuevo',
    ),
    NavigationDestination(
      icon: Icon(Icons.query_stats_rounded),
      label: 'Stock',
    ),
    NavigationDestination(
      icon: Icon(Icons.category_outlined),
      label: 'Categorías',
    ),
  ];

  static const _railDestinations = [
    NavigationRailDestination(
      icon: Icon(Icons.inventory_2_outlined),
      selectedIcon: Icon(Icons.inventory_2_rounded),
      label: Text('Productos'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.add_circle_outline_rounded),
      label: Text('Nuevo'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.query_stats_rounded),
      label: Text('Stock'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.category_outlined),
      label: Text('Categorías'),
    ),
  ];

  void _onNavigationSelected(int index) {
    if (index == 1) {
      _showAddProductDialog();
      return;
    }
    if (index != 0) {
      showAppAlertDialog(
        context: context,
        title: _navigationDestinations[index].label,
        message: 'Esta sección estará disponible próximamente.',
        icon: Icons.construction_outlined,
      );
      return;
    }
    setState(() => _selectedNavigationIndex = index);
  }

  Widget _buildCatalog(List<_Product> products) {
    return PageContainer(
      eyebrow: 'Catálogo general',
      title: 'Catálogo de Productos',
      subtitle: 'Gestión activa de inventario y control de existencias',
      maxWidth: 720,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: StatisticCard(
                  label: 'Total',
                  value: '148',
                  caption: 'Productos',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: StatisticCard(
                  label: 'Valor Total',
                  value: '\$42.8k',
                  caption: 'Activo',
                  icon: Icons.payments_outlined,
                  accentColor: Color(0xFF059669),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: _showAlerts,
                  child: const StatisticCard(
                    label: 'Alertas',
                    value: '8',
                    caption: 'Por revisar',
                    icon: Icons.warning_amber_rounded,
                    accentColor: Color(0xFFE11D48),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AppSearchField(
            controller: _searchController,
            hint: 'Buscar por nombre, SKU o código',
            onChanged: (value) => setState(() => _query = value),
            onScanPressed: _showScannerNotice,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _StockFilterChip(
                  label: 'Todos',
                  count: '148',
                  selected: _stockFilter == 'Todos',
                  onTap: () => _selectStockFilter('Todos'),
                ),
                _StockFilterChip(
                  label: 'Bajo Stock',
                  count: '6',
                  selected: _stockFilter == 'Bajo Stock',
                  color: const Color(0xFFF59E0B),
                  onTap: () => _selectStockFilter('Bajo Stock'),
                ),
                _StockFilterChip(
                  label: 'Agotados',
                  count: '2',
                  selected: _stockFilter == 'Agotados',
                  color: const Color(0xFFE11D48),
                  onTap: () => _selectStockFilter('Agotados'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                'Productos',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${products.length} mostrados',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _showSortAndFilter,
                icon: const Icon(Icons.swap_vert_rounded, size: 18),
                label: const Text('Ordenar'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (products.isEmpty)
            SizedBox(
              height: 260,
              child: EmptyView(
                title: _query.isEmpty
                    ? 'No hay productos con este filtro'
                    : 'No encontramos productos',
                message: 'Prueba con otros términos o cambia los filtros.',
                icon: Icons.search_off_rounded,
                action: SecondaryButton(
                  label: 'Limpiar filtros',
                  icon: Icons.filter_alt_off_outlined,
                  onPressed: _clearFilters,
                ),
              ),
            )
          else
            ...products.map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ProductCard(
                  product: product,
                  onDelete: () => _deleteProduct(product),
                  onEdit: () => _showEditProductDialog(product),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _selectStockFilter(String filter) {
    setState(() => _stockFilter = filter);
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _stockFilter = 'Todos';
      _expiryBefore = null;
    });
  }

  Future<void> _showSortAndFilter() async {
    var selectedSort = _sortOrder;
    var selectedExpiry = _expiryBefore;
    final result = await showModalBottomSheet<_CatalogOptions>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ordenar y filtrar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                AppDropdown<String>(
                  label: 'Ordenar por',
                  value: selectedSort,
                  items: const [
                    DropdownMenuItem(
                      value: 'Recomendados',
                      child: Text('Recomendados'),
                    ),
                    DropdownMenuItem(
                      value: 'Nombre A-Z',
                      child: Text('Nombre A-Z'),
                    ),
                    DropdownMenuItem(
                      value: 'Nombre Z-A',
                      child: Text('Nombre Z-A'),
                    ),
                    DropdownMenuItem(
                      value: 'Precio: menor a mayor',
                      child: Text('Precio: menor a mayor'),
                    ),
                    DropdownMenuItem(
                      value: 'Precio: mayor a menor',
                      child: Text('Precio: mayor a menor'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setSheetState(() => selectedSort = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                AppDateField(
                  label: 'Vencimiento antes de',
                  value: selectedExpiry,
                  onChanged: (date) {
                    setSheetState(() => selectedExpiry = date);
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Cancelar',
                        icon: Icons.close_rounded,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Aplicar',
                        icon: Icons.check_rounded,
                        onPressed: () => Navigator.pop(
                          context,
                          _CatalogOptions(
                            sortOrder: selectedSort,
                            expiryBefore: selectedExpiry,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _sortOrder = result.sortOrder;
        _expiryBefore = result.expiryBefore;
      });
    }
  }

  Future<void> _showAddProductDialog() async {
    final product = await showDialog<_Product>(
      context: context,
      builder: (context) => const _ProductFormDialog(categories: _categories),
    );
    if (product != null && mounted) {
      setState(() => _products.insert(0, product));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto agregado al catálogo')),
      );
    }
  }

  Future<void> _showEditProductDialog(_Product product) async {
    final updatedProduct = await showDialog<_Product>(
      context: context,
      builder: (context) =>
          _ProductFormDialog(categories: _categories, product: product),
    );
    if (updatedProduct != null && mounted) {
      final index = _products.indexOf(product);
      if (index >= 0) {
        setState(() => _products[index] = updatedProduct);
      }
    }
  }

  Future<void> _deleteProduct(_Product product) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Eliminar producto',
      message: '¿Quieres eliminar "${product.name}" del catálogo?',
      confirmLabel: 'Eliminar',
      isDestructive: true,
    );
    if (confirmed && mounted) {
      setState(() => _products.remove(product));
    }
  }

  Future<void> _showAlerts() {
    return showAppAlertDialog(
      context: context,
      title: 'Alertas de inventario',
      message: 'Hay 6 productos con bajo stock y 2 productos agotados.',
      icon: Icons.warning_amber_rounded,
    );
  }

  Future<void> _showScannerNotice() {
    return showAppAlertDialog(
      context: context,
      title: 'Escáner de productos',
      message: 'El escáner de códigos estará disponible cuando se conecte la cámara.',
      icon: Icons.qr_code_scanner_rounded,
    );
  }

  Future<void> _showProfile() {
    return showAppAlertDialog(
      context: context,
      title: 'Perfil',
      message: 'Sesión activa en la sucursal $_location.',
      icon: Icons.person_outline_rounded,
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onDelete,
    required this.onEdit,
  });

  final _Product product;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final stockColor = product.stock == 0
        ? const Color(0xFFE11D48)
        : product.stock <= 5
        ? const Color(0xFFF59E0B)
        : const Color(0xFF10B981);
    final stockLabel = product.stock == 0
        ? 'Agotado (0 pzas)'
        : product.stock <= 5
        ? 'Stock Bajo (${product.stock}/8)'
        : 'En stock (${product.stock} pzas)';
    final margin = product.price == 0
        ? 0
        : ((product.price - product.cost) / product.price * 100).round();

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(product.icon, color: colors.primary, size: 34),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colors.onSurface.withValues(alpha: 0.78),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.packageSize,
                          style: TextStyle(
                            color: colors.surface,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        PopupMenuButton<String>(
                          tooltip: 'Opciones de ${product.name}',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 150),
                          child: AppIconButton(
                            icon: Icons.more_vert_rounded,
                            tooltip: 'Opciones de ${product.name}',
                            onPressed: null,
                            color: const Color(0xFF64748B),
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              onEdit();
                            } else if (value == 'delete') {
                              onDelete();
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'edit',
                              child: ListTile(
                                dense: true,
                                leading: Icon(Icons.edit_outlined),
                                title: Text('Editar'),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: ListTile(
                                dense: true,
                                leading: Icon(Icons.delete_outline_rounded),
                                title: Text('Eliminar'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            product.category,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: colors.primary),
                          ),
                        ),
                        Text(
                          'SKU: ${product.sku}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontFamily: 'monospace',
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '(Costo: \$${product.cost.toStringAsFixed(2)})',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: colors.onSurfaceVariant),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Margen\n$margin%',
                            style: const TextStyle(
                              color: Color(0xFF047857),
                              fontSize: 11,
                              height: 1.15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: colors.outlineVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.qr_code_2_rounded,
                size: 16,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  product.barcode,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: stockColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: stockColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  stockLabel,
                  style: TextStyle(
                    color: stockColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockFilterChip extends StatelessWidget {
  const _StockFilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    this.color = const Color(0xFFF59E0B),
  });

  final String label;
  final String count;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        avatar: selected
            ? null
            : CircleAvatar(radius: 4, backgroundColor: color),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 7),
            Text(count, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        labelStyle: TextStyle(
          color: selected ? colors.onPrimary : colors.onSurface,
        ),
        backgroundColor: colors.surface,
        selectedColor: colors.onSurface,
        side: BorderSide(
          color: selected ? colors.onSurface : colors.outlineVariant,
        ),
        shape: const StadiumBorder(),
      ),
    );
  }
}

class _ProductFormDialog extends StatefulWidget {
  const _ProductFormDialog({required this.categories, this.product});

  final List<String> categories;
  final _Product? product;

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _priceController;
  late final TextEditingController _costController;
  late String _category;
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name);
    _skuController = TextEditingController(text: product?.sku);
    _barcodeController = TextEditingController(text: product?.barcode);
    _priceController = TextEditingController(
      text: product?.price.toStringAsFixed(2),
    );
    _costController = TextEditingController(
      text: product?.cost.toStringAsFixed(2),
    );
    _category = product?.category ?? widget.categories.first;
    _expiryDate = product?.expiryDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.product != null;
    return AlertDialog(
      title: Text(editing ? 'Editar producto' : 'Nuevo producto'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const InfoCard(
                  title: 'Datos del producto',
                  message: 'Los campos con * son obligatorios.',
                  icon: Icons.inventory_2_outlined,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _nameController,
                  label: 'Nombre *',
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                AppDropdown<String>(
                  label: 'Categoría',
                  value: _category,
                  items: widget.categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _skuController,
                        label: 'SKU *',
                        validator: _requiredValidator,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        controller: _barcodeController,
                        label: 'Código de barras *',
                        keyboardType: TextInputType.number,
                        validator: _requiredValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _priceController,
                        label: 'Precio *',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _priceValidator,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        controller: _costController,
                        label: 'Costo *',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _priceValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppDateField(
                  label: 'Fecha de vencimiento (opcional)',
                  value: _expiryDate,
                  onChanged: (date) => setState(() => _expiryDate = date),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        SecondaryButton(
          label: 'Cancelar',
          icon: Icons.close_rounded,
          onPressed: () => Navigator.pop(context),
        ),
        PrimaryButton(
          label: editing ? 'Guardar' : 'Agregar',
          icon: editing ? Icons.check_rounded : Icons.add_rounded,
          onPressed: _save,
        ),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  String? _priceValidator(String? value) {
    final parsed = double.tryParse(value ?? '');
    if (parsed == null || parsed < 0) {
      return 'Ingresa un valor válido';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final price = double.parse(_priceController.text);
    final cost = double.parse(_costController.text);
    final original = widget.product;
    final packageSize = original?.packageSize ?? '1 pza';
    Navigator.pop(
      context,
      _Product(
        name: _nameController.text.trim(),
        sku: _skuController.text.trim(),
        category: _category,
        price: price,
        cost: cost,
        barcode: _barcodeController.text.trim(),
        stock: original?.stock ?? 0,
        icon: original?.icon ?? Icons.inventory_2_outlined,
        packageSize: packageSize,
        expiryDate: _expiryDate,
      ),
    );
  }
}

class _CatalogOptions {
  const _CatalogOptions({required this.sortOrder, this.expiryBefore});

  final String sortOrder;
  final DateTime? expiryBefore;
}

class _Product {
  const _Product({
    required this.name,
    required this.sku,
    required this.category,
    required this.price,
    required this.cost,
    required this.barcode,
    required this.stock,
    required this.icon,
    required this.packageSize,
    this.expiryDate,
  });

  final String name;
  final String sku;
  final String category;
  final double price;
  final double cost;
  final String barcode;
  final int stock;
  final IconData icon;
  final String packageSize;
  final DateTime? expiryDate;
}
