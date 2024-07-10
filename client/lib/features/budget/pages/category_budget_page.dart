import 'package:flutter/material.dart';
import 'package:client/services/category_service.dart';
import 'package:client/services/budget_service.dart';
import 'package:client/model/category.dart';
import 'package:client/model/budget_model.dart';
import 'package:client/core/constant/constant.dart';

class CategoryBudgetPage extends StatefulWidget {
  final int weddingId;

  CategoryBudgetPage({required this.weddingId});

  @override
  _CategoryBudgetPageState createState() => _CategoryBudgetPageState();
}

class _CategoryBudgetPageState extends State<CategoryBudgetPage> {
  final CategoryService categoryService = CategoryService();
  final BudgetService budgetService = BudgetService(baseUrl: apiUrl);
  final Map<int, double> _selectedAmounts = {};
  List<Category> categories = [];
  List<WeddingBudget> budgets = [];
  double totalBudget = 0;
  double remainingBudget = 0;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchBudgets();
    _fetchTotalBudget();
  }

  void _fetchCategories() async {
    try {
      List<Category> fetchedCategories = await categoryService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    }
  }

  void _fetchBudgets() async {
    try {
      List<WeddingBudget> fetchedBudgets = await budgetService.getBudgets(widget.weddingId);
      setState(() {
        budgets = fetchedBudgets;
        _updateSelectedAmounts();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load budgets: $e')),
      );
    }
  }

  void _fetchTotalBudget() async {
    try {
      double fetchedTotalBudget = await budgetService.getTotalBudget(widget.weddingId);
      setState(() {
        totalBudget = fetchedTotalBudget;
        remainingBudget = totalBudget - _calculateUsedBudget();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load total budget: $e')),
      );
    }
  }

  void _updateSelectedAmounts() {
    _selectedAmounts.clear();
    budgets.forEach((budget) {
      _selectedAmounts[budget.categoryId] = budget.amount;
    });
    _updateRemainingBudget();
  }

  void _updateRemainingBudget() {
    double usedBudget = _calculateUsedBudget();
    setState(() {
      remainingBudget = totalBudget - usedBudget;
    });
    print('Updated remaining budget: $remainingBudget');
  }

  double _calculateUsedBudget() {
    double usedBudget = 0;
    _selectedAmounts.forEach((_, amount) {
      usedBudget += amount;
    });
    return usedBudget;
  }

  void _submitBudgets() async {
    List<Map<String, dynamic>> categoryBudgets = [];
    _selectedAmounts.forEach((categoryId, amount) {
      categoryBudgets.add({
        'category_id': categoryId,
        'amount': amount,
      });
    });

    try {
      await budgetService.submitBudgets(widget.weddingId, categoryBudgets);
      _fetchBudgets();
      _updateRemainingBudget();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit budgets: $e')),
      );
    }
  }

  void _updateBudget(WeddingBudget budget, double amount) async {
    final updatedBudget = WeddingBudget(
      id: budget.id,
      weddingId: budget.weddingId,
      categoryId: budget.categoryId,
      amount: amount,
      createdAt: budget.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: budget.deletedAt,
    );

    try {
      await budgetService.updateBudget(updatedBudget);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget updated successfully')),
      );
      _fetchBudgets();
      _updateRemainingBudget();
    } catch (e) {
    }
  }

  void _saveBudget(int categoryId, double amount) {
    WeddingBudget? existingBudget;
    for (var budget in budgets) {
      if (budget.categoryId == categoryId) {
        existingBudget = budget;
        break;
      }
    }

    if (existingBudget != null) {
      _updateBudget(existingBudget, amount);
    } else {
      final newBudget = WeddingBudget(
        id: 0,
        weddingId: widget.weddingId,
        categoryId: categoryId,
        amount: amount,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
      );
      budgetService.createBudget(newBudget).then((createdBudget) {
        setState(() {
          budgets.add(createdBudget);
          _selectedAmounts[categoryId] = createdBudget.amount;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save budget: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Définir le Budget par Catégorie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: categories.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Text(
              'Budget total : €${totalBudget.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.green),
            ),
            Text(
              'Budget restant : €${remainingBudget.toStringAsFixed(2)}',
              style: TextStyle(color: remainingBudget >= 0 ? Colors.green : Colors.red),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  Category category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Budget pour ${category.name}'),
                        Slider(
                          value: _selectedAmounts[category.id] ?? 0,
                          min: 0,
                          max: totalBudget,
                          divisions: 100,
                          label: (_selectedAmounts[category.id] ?? 0).toStringAsFixed(2),
                          activeColor: Colors.pink,
                          onChanged: (double value) {
                            setState(() {
                              _selectedAmounts[category.id] = value;
                              _updateRemainingBudget();
                            });
                          },
                          onChangeEnd: (double value) {
                            _saveBudget(category.id, value);
                          },
                        ),
                        Text('Montant : €${(_selectedAmounts[category.id] ?? 0).toStringAsFixed(2)}'),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _submitBudgets,
              child: Text('Valider les Budgets'),
            ),
          ],
        ),
      ),
    );
  }
}
