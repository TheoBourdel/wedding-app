import 'package:flutter/material.dart';

class BudgetCardWidget extends StatelessWidget {
  final String title;
  final int amount;
  final Color? color;

  BudgetCardWidget({required this.title, required this.amount, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '€${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: color ?? Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
