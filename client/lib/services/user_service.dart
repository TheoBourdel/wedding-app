import 'dart:convert';
import 'package:client/repository/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:client/model/user.dart';
import 'package:client/core/constant/constant.dart';
import 'package:client/provider/token_utils.dart';



class UserService {
  final String _baseUrl = apiUrl;
  Future<List<User>> fetchUsers({int page = 1, int pageSize = 10, String query = ''}) async {
   // final response = await http.get(Uri.parse('$_baseUrl/users?page=$page&pageSize=$pageSize&query=$query'));
    String? token = await TokenUtils.getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Request headers: ${response.request?.headers}');


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

