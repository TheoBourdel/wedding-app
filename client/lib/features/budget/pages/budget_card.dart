import 'package:flutter/material.dart';
import 'package:client/model/budget_model.dart';
import 'package:iconsax/iconsax.dart';

class BudgetCard extends StatelessWidget {
  final WeddingBudget budget;
  final String categoryName;
  final TextEditingController controller;
  final Function(double) onUpdate;
  final Function() onDelete;
  final Function() onTap;

  BudgetCard({
    required this.budget,
    required this.categoryName,
    required this.controller,
    required this.onUpdate,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double remainingAmount = budget.amount - budget.amountPaid;

    return InkWell(
      onTap: onTap,
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
                        Row(
                          children: [
                            if (budget.paid)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Payé',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10),
                            Text(
                              '${budget.amount.toStringAsFixed(2)}€',
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
                    const SizedBox(height: 8),
                    if (remainingAmount != 0 && budget.paid)
                      Row(
                        children: [
                          Text(
                            '${remainingAmount.toStringAsFixed(2)}€',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: remainingAmount >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            remainingAmount >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                            color: remainingAmount >= 0 ? Colors.green : Colors.red,
                            size: 20,
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
