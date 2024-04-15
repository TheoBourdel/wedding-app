import 'package:client/core/constant/constant.dart';
import 'package:client/features/auth/dto/signup_user_dto.dart';
import 'package:client/features/auth/model/user.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AuthRepository {
  final String _baseUrl = apiUrl;

  Future<User> signUp(SignUpUserDto user) async {
    Response res = await post(Uri.parse('$_baseUrl/signup'));

    if (res.statusCode == 200) {
      print(res.body);
      print(User.fromJson(jsonDecode(res.body)));
      return User.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to sign up');
    }
  }
}
