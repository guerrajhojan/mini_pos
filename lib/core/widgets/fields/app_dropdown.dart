import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.hint,
    this.validator,
    super.key,
  });

  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final String? label;
  final String? hint;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(labelText: label, hintText: hint),
      borderRadius: BorderRadius.circular(16),
      isExpanded: true,
    );
  }
}
