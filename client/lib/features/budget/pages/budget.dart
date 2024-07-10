import 'package:flutter/material.dart';
import 'package:client/model/budget_model.dart';
import 'package:client/services/budget_service.dart';
import 'package:client/services/category_service.dart';
import 'package:client/model/category.dart';

class BudgetManagementPage extends StatefulWidget {
  final int weddingId;
  final BudgetService budgetService;

  BudgetManagementPage({required this.weddingId, required this.budgetService});

  @override
  _BudgetManagementPageState createState() => _BudgetManagementPageState();
}

class _BudgetManagementPageState extends State<BudgetManagementPage> {
  late Future<List<WeddingBudget>> futureBudgets;
  late Future<List<Category>> futureCategories;
  final Map<int, TextEditingController> _controllers = {};
  Map<int, String> categoryNames = {};

  @override
  void initState() {
    super.initState();
    futureBudgets = widget.budgetService.getBudgets(widget.weddingId);
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

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _saveBudget(int categoryId, double amount) {
    final newBudget = WeddingBudget(
      id: 0,
      weddingId: widget.weddingId,
      categoryId: categoryId,
      amount: amount,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    print('Creating new budget: ${newBudget.toJson()}');

    widget.budgetService.createBudget(newBudget).then((createdBudget) {
      setState(() {
        futureBudgets = widget.budgetService.getBudgets(widget.weddingId);
      });
    }).catchError((error) {
      print('Failed to save budget: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save budget: $error')),
      );
    });
  }

  void _updateBudget(WeddingBudget budget, double amount) {
    final updatedBudget = WeddingBudget(
      id: budget.id,
      weddingId: budget.weddingId,
      categoryId: budget.categoryId,
      amount: amount,
      createdAt: budget.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: budget.deletedAt,
    );

    print('Updating budget: ${updatedBudget.toJson()}');

    widget.budgetService.updateBudget(updatedBudget).then((_) {
      setState(() {
        futureBudgets = widget.budgetService.getBudgets(widget.weddingId);
      });
    }).catchError((error) {
      print('Failed to update budget: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update budget: $error')),
      );
    });
  }



  void _deleteBudget(int id) {
    widget.budgetService.deleteBudget(id).then((_) {
      setState(() {
        futureBudgets = widget.budgetService.getBudgets(widget.weddingId);
      });
    }).catchError((error) {
      print('Failed to delete budget: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete budget: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Management'),
      ),
      body: FutureBuilder<List<WeddingBudget>>(
        future: futureBudgets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load budgets'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No budgets available'));
          } else {
            final budgets = snapshot.data!;
            return ListView.builder(
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final budget = budgets[index];
                if (!_controllers.containsKey(budget.categoryId)) {
                  _controllers[budget.categoryId] = TextEditingController(text: budget.amount.toString());
                }
                final categoryName = categoryNames[budget.categoryId] ?? 'Unknown Category';
                return ListTile(
                  title: Text(categoryName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        child: TextField(
                          controller: _controllers[budget.categoryId],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '€',
                          ),
                          onSubmitted: (value) {
                            final amount = double.tryParse(value) ?? 0;
                            _updateBudget(budget, amount);
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteBudget(budget.id);
                        },
                      ),
                    ],
                  ),
                );
              },
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
            );
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.error),
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
                      title: Text('Add Budget'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButtonFormField<Category>(
                            decoration: InputDecoration(
                              labelText: 'Select Category',
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
                              labelText: 'Amount',
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
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            );
          }
        },
      ),
    );
  }
}
