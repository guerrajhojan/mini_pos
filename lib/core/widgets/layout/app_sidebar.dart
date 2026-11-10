import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.extended = true,
    super.key,
  });

  final List<NavigationRailDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      labelType: extended ? null : NavigationRailLabelType.all,
      destinations: destinations,
    );
  }
}
