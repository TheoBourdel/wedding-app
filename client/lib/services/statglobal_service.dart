import 'package:client/provider/token_utils.dart';
import 'package:http/http.dart' as http;
import 'package:client/core/constant/constant.dart';

class StatglobalService {
  final String _baseUrl = apiUrl;

  Future<int> fetchTotalProviders() async {
    String? token = await TokenUtils.getToken();

    final response = await http.get(
        Uri.parse('$_baseUrl/total_providers'),
        headers: {
          'Authorization': 'Bearer $token',
        },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total providers');
    }
  }

  Future<int> fetchTotalWeddings() async {
    String? token = await TokenUtils.getToken();
    final response = await http.get(
        Uri.parse('$_baseUrl/total_weddings'),
        headers: {
          'Authorization': 'Bearer $token',
        },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total weddings');
    }
  }

  Future<int> fetchTotalGuests() async {
    String? token = await TokenUtils.getToken();
    final response = await http.get(
        Uri.parse('$_baseUrl/total_guests'),
        headers: {
          'Authorization': 'Bearer $token',
        },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total guests');
    }
  }

  Future<double> fetchAverageBudget() async {
    String? token = await TokenUtils.getToken();

    final response = await http.get(
        Uri.parse('$_baseUrl/average_budget'),
        headers: {
          'Authorization': 'Bearer $token',
        },
    );

    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to load average budget');
    }
  }
}
