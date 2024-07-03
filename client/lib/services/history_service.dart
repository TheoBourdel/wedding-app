import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/core/constant/constant.dart';

class HistoryService {
  final String _baseUrl = apiUrl;

  Future<List<Map<String, dynamic>>> fetchWeddingsByYear(int year) async {
    final response = await http.get(Uri.parse('$_baseUrl/weddingsByYear?year=$year'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => {
        "name": data['name'],
        "budget": data['budget']
      }).toList();
    } else {
      throw Exception('Failed to load weddings for the year $year');
    }
  }
}
