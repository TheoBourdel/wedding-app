import 'dart:convert';
import 'package:client/core/constant/constant.dart';
import 'package:http/http.dart';
import '../model/user.dart';

class UserRepository {
  final String _baseUrl = apiUrl;

  Future<User> getUser(int userId) async {
    Response res = await get(
      Uri.parse('$_baseUrl/user/$userId'),
    );
    
    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }
}