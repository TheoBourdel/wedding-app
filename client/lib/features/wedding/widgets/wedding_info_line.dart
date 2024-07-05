import 'package:flutter/material.dart';

class WeddingInfoLine extends StatelessWidget {
  final String title;
  final IconData icon;
  const WeddingInfoLine({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}