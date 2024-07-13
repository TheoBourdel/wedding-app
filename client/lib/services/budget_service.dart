import 'dart:convert';
import 'package:client/core/constant/constant.dart';
import 'package:http/http.dart' as http;
import 'package:client/model/budget_model.dart';

class BudgetService {

  Future<void> submitBudgets(int weddingId, List<Map<String, dynamic>> categoryBudgets) async {
    final url = '$apiUrl/budgets';
    final body = jsonEncode({
      'wedding_id': weddingId,
      'category_budgets': categoryBudgets,
    });
    print('Sending data to server: $body');
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to submit budgets: ${response.body}');
    }
  }

  Future<List<WeddingBudget>> getBudgets(int weddingId) async {
    final response = await http.get(Uri.parse('$apiUrl/weddings/$weddingId/budgets'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((budget) => WeddingBudget.fromJson(budget)).toList();
    } else {
      throw Exception('Failed to load budgets');
    }
  }

  Future<WeddingBudget> createBudget(WeddingBudget budget) async {

    final response = await http.post(
      Uri.parse('$apiUrl/budgets'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(budget.toJson()),
    );

    if (response.statusCode == 201) {
      return WeddingBudget.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create budget: ${response.body}');
    }
  }

  Future<void> updateBudget(WeddingBudget budget) async {
    final url = '$apiUrl/budgets/${budget.id}';
    final body = jsonEncode(budget);

    print('Sending data to server: $body');

    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update budget: ${response.body}');
    }
  }

  Future<void> deleteBudget(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/budgets/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete budget: ${response.body}');
    }
  }

  Future<double> getTotalBudget(int weddingId) async {
    final response = await http.get(Uri.parse('$apiUrl/weddings/$weddingId/total_budget'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['total_budget'].toDouble();
    } else {
      throw Exception('Failed to load total budget');
    }
  }
}