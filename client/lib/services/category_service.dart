import 'dart:convert';
import 'package:client/provider/token_utils.dart';
import 'package:http/http.dart' as http;
import 'package:client/model/category.dart';
import 'package:client/core/constant/constant.dart';

class CategoryService {
  final String _baseUrl = apiUrl;

  Future<List<Category>> fetchCategories() async {
    String? token = await TokenUtils.getToken();

    final response = await http.get(
        Uri.parse('$_baseUrl/categorys'),
        headers: {
          'Authorization': 'Bearer $token',
        },
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Category> createCategory(String name) async {
    String? token = await TokenUtils.getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/addcategory'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"name": name}),
    );

    if (response.statusCode == 201) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create category: ${response.body}');
    }
  }

  Future<void> deleteCategory(int id) async {
    String? token = await TokenUtils.getToken();

    final response = await http.delete(
      Uri.parse('$_baseUrl/category/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete category');
    }
  }
}
