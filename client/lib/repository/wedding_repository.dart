import 'dart:convert';

import 'package:client/core/constant/constant.dart';
import 'package:client/dto/organizer_dto.dart';
import 'package:client/model/user.dart';
import 'package:client/model/wedding.dart';
import 'package:http/http.dart';

class WeddingRepository {
  final String _baseUrl = apiUrl;

  Future<User> addOrganizer(OrganizerDto user, int weddingId) async {

    Response res = await post(
      Uri.parse('$_baseUrl/wedding/$weddingId/organizer'),
      body: user.toJson(),
    );

    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }
  
}