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
