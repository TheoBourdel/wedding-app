import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/model/user.dart';
import 'package:client/core/constant/constant.dart';

class UserService {
  final String _baseUrl = apiUrl;

  Future<List<User>> fetchUsers({int page = 1, int pageSize = 10, String query = ''}) async {
    final response = await http.get(Uri.parse('$_baseUrl/users?page=$page&pageSize=$pageSize&query=$query'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map<User>((user) => User.fromJson(user)).toList();
    } else if (response.body.isEmpty) {
      return [];
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/users/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user: ${response.body}');
    }
  }
}
