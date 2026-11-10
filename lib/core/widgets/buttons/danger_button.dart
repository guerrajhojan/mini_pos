import 'package:flutter/material.dart';

class DangerButton extends StatelessWidget {
  const DangerButton({
    required this.label,
    required this.onPressed,
    this.icon = Icons.delete_outline_rounded,
    this.isExpanded = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onError,
        backgroundColor: Theme.of(context).colorScheme.error,
        minimumSize: const Size(48, 48),
        shape: const StadiumBorder(),
      ),
    );

    return isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
