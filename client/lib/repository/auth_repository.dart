import 'package:client/core/constant/constant.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/dto/signin_user_dto.dart';
import 'package:client/dto/signup_user_dto.dart';
import 'package:client/model/user.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AuthRepository {
  final String _baseUrl = apiUrl;

  Future<User> signUp(SignUpUserDto user) async {
    print('ooooo');
    Response res = await post(
      Uri.parse('$_baseUrl/signup'),
      body: user.toJson(),
    );

    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    } else {
      var errorResponse = jsonDecode(res.body);
      var errorMessage = errorResponse['error'] ?? 'An unknown error occurred';
      throw ApiException(message: errorMessage, statusCode: res.statusCode);
    }
  }

  static Future<String> signIn(SignInUserDto user) async {
    Response res = await post(
      Uri.parse('$apiUrl/signin'),
      body: user.toJson(),
    );

    if(res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception(res.body);
    }
  }
}
