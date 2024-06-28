import 'package:http/http.dart' as http;
import 'package:client/core/constant/constant.dart';

class StatglobalService {
  final String _baseUrl = apiUrl;

  Future<int> fetchTotalProviders() async {
    final response = await http.get(Uri.parse('$_baseUrl/total_providers'));

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total providers');
    }
  }

  Future<int> fetchTotalWeddings() async {
    final response = await http.get(Uri.parse('$_baseUrl/total_weddings'));

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total weddings');
    }
  }

  Future<int> fetchTotalGuests() async {
    final response = await http.get(Uri.parse('$_baseUrl/total_guests'));

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total guests');
    }
  }

  Future<double> fetchAverageBudget() async {
    final response = await http.get(Uri.parse('$_baseUrl/average_budget'));

    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to load average budget');
    }
  }
}
