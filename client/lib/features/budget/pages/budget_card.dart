import 'package:flutter/material.dart';
import 'package:client/model/budget_model.dart';

class BudgetCard extends StatelessWidget {
  final WeddingBudget budget;
  final String categoryName;
  final TextEditingController controller;
  final Function(double) onUpdate;
  final Function() onDelete;
  final Function() onTap;

  const BudgetCard({
    super.key, 
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
      onTap: () {
        budget.paid ? null : onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${budget.amount.toStringAsFixed(2)}€',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  budget.paid ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Tu as payé : ${budget.amountPaid.toStringAsFixed(2)}€',
                      ),
                      Text(
                        '${remainingAmount.toStringAsFixed(2)}€',
                        style: TextStyle(
                          color: remainingAmount >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ) : const SizedBox.shrink(),
                  budget.paid ? 
                  const SizedBox.shrink() : 
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}
