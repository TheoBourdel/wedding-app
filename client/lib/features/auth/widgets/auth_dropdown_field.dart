import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthDropdownField extends StatelessWidget {
  final String controller;

  const AuthDropdownField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: controller,
      isExpanded: false,
      iconEnabledColor: AppColors.pink,
      hint: const Text(
        'Séléctionne ton type de compte',
        style: TextStyle(
          color: AppColors.mediumPink,
          fontSize: 16,
        ),
      ),
      borderRadius: BorderRadius.circular(15),
      items: const [
        DropdownMenuItem(
          value: "provider",
          child: Text('Prestataire'),
        ),
        DropdownMenuItem(
          value: "married",
          child: Text('Marié(e)'),
        ),
      ],
      onChanged: (value) {
        print(value);
      },
    );
  }
}