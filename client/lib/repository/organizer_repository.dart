import 'dart:convert';

import 'package:client/dto/organizer_dto.dart';
import 'package:client/model/user.dart';
import 'package:http/http.dart';
import 'package:client/core/constant/constant.dart';

class OrganizerRepository {
  static Future<List<User>> getOrganizers(int weddingId) async {
    Response res = await get(
      Uri.parse('$apiUrl/wedding/$weddingId/organizers'),
    );

    if(res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<User> organizers = body.map((dynamic item) => User.fromJson(item)).toList();
      return organizers;
    } else {
      throw Exception(res.body);
    }
  }

  static Future<User> addOrganizer(OrganizerDto user, int weddingId) async {

    Response res = await post(
      Uri.parse('$apiUrl/wedding/$weddingId/organizer'),
      body: user.toJson(),
    );

    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    }else {
      throw Exception(res.body);
    }
  }
}