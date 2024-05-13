import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isOutlined;
  
  const Button({super.key, this.onPressed, required this.text, this.isOutlined = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(double.maxFinite, 60),
        //primary: isOutlined ? Colors.white : AppColors.pink,
        backgroundColor: isOutlined ? Colors.white : AppColors.pink,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: isOutlined ? AppColors.pink : Colors.white,
            width: 1,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isOutlined ? AppColors.pink : Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}