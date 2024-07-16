import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:client/model/budget_model.dart';
import 'package:client/services/budget_service.dart';
import 'package:client/services/category_service.dart';
import 'package:client/model/category.dart';
import 'budget_card.dart'; // Assurez-vous d'importer le fichier contenant le widget BudgetCard
import 'buildbudget_card.dart'; // Importez le nouveau fichier

class BudgetManagementPage extends StatefulWidget {
  final int weddingId;
  final int budget;

  BudgetManagementPage({required this.weddingId, required this.budget});

  @override
  _BudgetManagementPageState createState() => _BudgetManagementPageState();
}

class _BudgetManagementPageState extends State<BudgetManagementPage> {
  late Future<List<WeddingBudget>> futureBudgets;
  late Future<List<Category>> futureCategories;
  final Map<int, TextEditingController> _controllers = {};
  Map<int, String> categoryNames = {};
  final BudgetService budgetService = BudgetService();

  @override
  void initState() {
    super.initState();
    futureBudgets = budgetService.getBudgets(widget.weddingId);
    futureCategories = _fetchCategories();
  }

  Future<List<Category>> _fetchCategories() async {
    final CategoryService categoryService = CategoryService();
    try {
      List<Category> categories = await categoryService.fetchCategories();
      setState(() {
        categoryNames = {for (var category in categories) category.id: category.name};
      });
      return categories;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
      return [];
    }
  }

  double _calculateTotalAllocatedBudget(List<WeddingBudget> budgets) {
    double total = 0;
    for (var budget in budgets) {
      total += budget.amountPaid;
    }
    return total;
  }

  bool _categoryExists(int categoryId, List<WeddingBudget> budgets) {
    for (var budget in budgets) {
      if (budget.categoryId == categoryId) {
        return true;
      }
    }
    return false;
  }

  void _saveBudget(int categoryId, double amount) async {
    final existingBudgets = await budgetService.getBudgets(widget.weddingId);
    final totalAllocated = _calculateTotalAllocatedBudget(existingBudgets);

    if (_categoryExists(categoryId, existingBudgets)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Un budget pour cette catégorie existe déjà')),
      );
      return;
    }

    if (totalAllocated + amount > widget.budget) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tu as dépassé le budget de ton mariage')),
      );
      return;
    }

    final newBudget = WeddingBudget(
      id: 0,
      weddingId: widget.weddingId,
      categoryId: categoryId,
      amount: amount,
    );

    budgetService.createBudget(newBudget).then((createdBudget) {
      setState(() {
        futureBudgets = budgetService.getBudgets(widget.weddingId);
      });
    }).catchError((error) {
      print('Failed to save budget: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save budget: $error')),
      );
    });
  }

  void _updateBudget(WeddingBudget budget, double amount) async {
    final existingBudgets = await budgetService.getBudgets(widget.weddingId);
    final totalAllocated = _calculateTotalAllocatedBudget(existingBudgets) - budget.amount;

    if (totalAllocated + amount > widget.budget.toDouble()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tu as dépassé le budget de ton mariage')),
      );
      return;
    }

    final updatedBudget = WeddingBudget(
      id: budget.id,
      weddingId: budget.weddingId,
      categoryId: budget.categoryId,
      amount: amount,
    );

    budgetService.updateBudget(updatedBudget).then((_) {
      setState(() {
        futureBudgets = budgetService.getBudgets(widget.weddingId);
      });
    }).catchError((error) {
      print('Failed to update budget: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update budget: $error')),
      );
    });
  }

  void _deleteBudget(int id) {
    budgetService.deleteBudget(id).then((_) {
      setState(() {
        futureBudgets = budgetService.getBudgets(widget.weddingId);
      });
    }).catchError((error) {
      print('Failed to delete budget: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete budget: $error')),
      );
    });
  }

  void _showUpdateDialog(WeddingBudget budget) {
    final TextEditingController amountController = TextEditingController(text: budget.amount.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text('Mettre à jour le budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Montant',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.euro),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null) {
                  _updateBudget(budget, amount);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veuillez entrer un montant valide')),
                  );
                }
              },
              child: Text('Mettre à jour'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Gérer votre budget'),
        elevation: 0,
      ),
      body: FutureBuilder<List<WeddingBudget>>(
        future: futureBudgets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erreur lors du chargement des budgets'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun budget trouvé'));
          } else {
            final budgets = snapshot.data!;
            final totalAllocated = _calculateTotalAllocatedBudget(budgets);
            final remainingBudget = widget.budget - totalAllocated;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '€$remainingBudget',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'restant sur un budget de ${widget.budget} €',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: totalAllocated / widget.budget,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.pink500),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(10),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                    itemCount: budgets.length,
                    itemBuilder: (context, index) {
                      final budget = budgets[index];
                      if (!_controllers.containsKey(budget.categoryId)) {
                        _controllers[budget.categoryId] = TextEditingController(text: budget.amount.toString());
                      }
                      final categoryName = categoryNames[budget.categoryId] ?? 'Unknown Category';
                      return Column(
                        children: [
                          BudgetCard(
                            budget: budget,
                            categoryName: categoryName,
                            controller: _controllers[budget.categoryId]!,
                            onUpdate: (amount) => _updateBudget(budget, amount),
                            onDelete: () => _deleteBudget(budget.id),
                            onTap: () => _showUpdateDialog(budget),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                  )
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return FloatingActionButton(
              onPressed: null,
              child: CircularProgressIndicator(),
              backgroundColor: Colors.pink,
            );
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.error),
              backgroundColor: Colors.pink,
            );
          } else {
            return FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final TextEditingController amountController = TextEditingController();
                    Category? selectedCategory;

                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      title: Text('Ajouter un budget'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButtonFormField<Category>(
                            decoration: InputDecoration(
                              labelText: 'Sélectionner une catégorie',
                              border: OutlineInputBorder(),
                            ),
                            items: categoryNames.entries.map((entry) {
                              return DropdownMenuItem<Category>(
                                value: Category(
                                  id: entry.key,
                                  name: entry.value,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                ),
                                child: Text(entry.value),
                              );
                            }).toList(),
                            onChanged: (Category? newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            },
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: amountController,
                            decoration: InputDecoration(
                              labelText: 'Montant',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.euro),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (selectedCategory != null) {
                              final amount = double.tryParse(amountController.text);
                              if (amount != null) {
                                print('Saving budget: Category ID: ${selectedCategory!.id}, Amount: $amount');
                                _saveBudget(selectedCategory!.id, amount);
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please enter a valid amount')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please select a category')),
                              );
                            }
                          },
                          child: Text('Enregistrer'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
              backgroundColor: AppColors.pink500,
            );
          }
        },
      ),
    );
  }
}

