import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppColors.mediumPink, double width = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      color: color,
      width: width,
    ),
    
  );

  static final darkTheme = ThemeData.dark();
  static final lightTheme = ThemeData.light().copyWith(
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(
        color: AppColors.mediumPink,
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.all(20),
      enabledBorder: _border(),
      focusedBorder: _border(AppColors.pink, 2),
    )
  );
}
