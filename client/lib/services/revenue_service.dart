import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/core/constant/constant.dart';

class RevenueService {
  final String _baseUrl = apiUrl;

  Future<List<Map<String, dynamic>>> fetchMonthlyRevenueByYear(int year) async {
    final response = await http.get(Uri.parse('$_baseUrl/monthly_revenue?year=$year'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => {
        "year": data['year'],
        "month": data['month'],
        "revenue": data['revenue']
      }).toList();
    } else {
      throw Exception('Failed to load monthly revenue by year');
    }
  }
}