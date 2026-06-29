import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
