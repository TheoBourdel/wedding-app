import 'package:flutter/material.dart';
import 'package:client/model/budget_model.dart';
import 'package:iconsax/iconsax.dart';

class BudgetCard extends StatelessWidget {
  final WeddingBudget budget;
  final String categoryName;
  final TextEditingController controller;
  final Function(double) onUpdate;
  final Function() onDelete;
  final Function() onTap; // Ajoutez ce callback

  BudgetCard({
    required this.budget,
    required this.categoryName,
    required this.controller,
    required this.onUpdate,
    required this.onDelete,
    required this.onTap, // Ajoutez ce paramètre
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Connectez le callback ici
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.pink[50],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Iconsax.money,
                    size: 30,
                    color: Colors.pink,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '€${budget.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
