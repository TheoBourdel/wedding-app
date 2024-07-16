import 'dart:convert';
import 'package:client/core/constant/constant.dart';
import 'package:client/provider/token_utils.dart';
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

  Future updateUserAndroidToken(User user, String token) async {
    try {
      Response res = await put(
        Uri.parse('$_baseUrl/user/${user.id}/token'),
        body: json.encode({'token': token}),
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        return User.fromJson(jsonDecode(res.body));
      } else {
        throw Exception(res.body);
      }

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future updateUser(User user) async {
    String? token = await TokenUtils.getToken();

    try {
      Response res = await patch(
        Uri.parse('$_baseUrl/user/${user.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: user.toJson(),
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return User.fromJson(jsonDecode(res.body));
      } else {
        throw Exception(res.body);
      }

    } catch (e) {
      throw Exception(e.toString());
    }
  }
}