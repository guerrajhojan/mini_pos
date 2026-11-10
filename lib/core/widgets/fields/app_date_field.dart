import 'package:flutter/material.dart';

class AppDateField extends StatelessWidget {
  const AppDateField({
    required this.onChanged,
    this.value,
    this.firstDate,
    this.lastDate,
    this.label = 'Fecha',
    this.enabled = true,
    super.key,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final displayedDate = value == null
        ? null
        : localizations.formatMediumDate(value!);

    return InkWell(
      onTap: enabled
          ? () async {
              final now = DateTime.now();
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: value ?? now,
                firstDate: firstDate ?? DateTime(now.year - 100),
                lastDate: lastDate ?? DateTime(now.year + 100),
              );
              if (selectedDate != null) {
                onChanged(selectedDate);
              }
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        isEmpty: displayedDate == null,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          enabled: enabled,
        ),
        child: Text(
          displayedDate ?? '',
          style: displayedDate == null
              ? Theme.of(context).inputDecorationTheme.hintStyle
              : null,
        ),
      ),
    );
  }
}
