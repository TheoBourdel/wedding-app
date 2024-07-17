import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:client/model/budget_model.dart';
import 'package:client/services/budget_service.dart';
import 'package:client/services/category_service.dart';
import 'package:client/model/category.dart';
import 'package:iconsax/iconsax.dart';
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
          } else {
            final budgets = snapshot.data!;
            final totalAllocated = _calculateTotalAllocatedBudget(budgets);
            final remainingBudget = widget.budget - totalAllocated;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Budget total restant :',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(
                              '€$remainingBudget',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '/ €${widget.budget}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: totalAllocated / widget.budget,
                          backgroundColor: Colors.grey[100],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            totalAllocated > widget.budget ? Colors.red : Colors.green
                          ),
                          minHeight: 15,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              totalAllocated > widget.budget ? Iconsax.close_circle : Iconsax.tick_circle,
                              color: totalAllocated > widget.budget ? Colors.red : Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              totalAllocated > widget.budget ? 'Vous avez dépassé votre budget' : 'Vos dépenses totales sont toujours sur la bonne voie',
                              style: TextStyle(
                                color: totalAllocated > widget.budget ? Colors.red : Colors.green,
                                fontSize: 12,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20),
                  child: Text(
                    'Mes budgets', 
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    )
                  )
                ), 
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: !snapshot.hasData || snapshot.data!.isEmpty
                      ? Column(
                        children: [
                          Image.asset(
                            'assets/images/no-budgets.png',
                            width: 300,
                            height: 300,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'Vous n\'avez pas encore de budget',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Cliquez sur le bouton + pour ajouter un budget',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          ),
                        ],
                      )
                    : ListView.builder(
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
                          const SizedBox(height: 8),
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
              child: Icon(Icons.add, color: Colors.white,),
              backgroundColor: AppColors.pink500,
            );
          }
        },
      ),
    );
  }
}

