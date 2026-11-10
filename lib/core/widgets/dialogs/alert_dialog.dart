import 'package:flutter/material.dart';

Future<void> showAppAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonLabel = 'Entendido',
  IconData icon = Icons.info_outline_rounded,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonLabel),
        ),
      ],
    ),
  );
}
