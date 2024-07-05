import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String hintText;
  final bool isObscureText;
  final TextEditingController controller;
  final IconData? icon;
  final bool isDate;
  final TextInputType keyboardType;

  const Input({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.isDate = false,
    this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {

    Future<void> selectDate() async {
      DateTime? picked = await showDatePicker(
        context: context, 
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(3000),
      );

      if (picked != null) {
        controller.text = picked.toString().split(' ')[0];
      }
    }

    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        prefixIconColor: AppColors.pink500,
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
      onTap: () {
        if (isDate) {
          selectDate();
        }
      }
    );
  }
}