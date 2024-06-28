import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String hintText;
  final bool isObscureText;
  final TextEditingController controller;

  const Input({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        labelStyle: const TextStyle(
          color: AppColors.pink500,
        ),
        errorStyle: TextStyle(
          color: Colors.red[200],
          fontWeight: FontWeight.bold,
        ),

      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is required';
        }
        return null;
      },
    );
  }
}
