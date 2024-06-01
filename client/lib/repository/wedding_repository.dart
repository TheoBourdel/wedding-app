import 'dart:convert';

import 'package:client/core/constant/constant.dart';
import 'package:client/core/error/failure.dart';
import 'package:client/dto/organizer_dto.dart';
import 'package:client/model/user.dart';
import 'package:client/model/wedding.dart';
import 'package:http/http.dart';
import 'package:client/dto/wedding_dto.dart';

class WeddingRepository {
  final String _baseUrl = apiUrl;

  Future<User> addOrganizer(OrganizerDto user, int weddingId) async {

    Response res = await post(
      Uri.parse('$_baseUrl/wedding/$weddingId/organizer'),
      body: user.toJson(),
    );

    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    }else {
      throw Exception(res.body);
    }
  }

  static Future<List<Wedding>> getUserWedding(int userId) async {
    try {
      final response = await get(Uri.parse('$apiUrl/userwedding/$userId'));

      print(userId);
      
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(
          message: 'Erreur lors de la récupérations des informations', 
          statusCode: response.statusCode
        );
      }
      final decodedBody = jsonDecode(response.body);
      return decodedBody.map<Wedding>((wedding) => Wedding.fromJson(wedding)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
  
  static Future createWedding(WeddingDto wedding, int userId) async {
    try {
      final response = await post(
        Uri.parse('$apiUrl/user/$userId/wedding'),
        body: wedding.toJson(),
      );

      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(
          message: 'Erreur lors de la création du mariage', 
          statusCode: response.statusCode
        );
      }
      return Wedding.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future updateWedding(Wedding wedding) async {
    try {
      final response = await patch(
        Uri.parse('$apiUrl/wedding/${wedding.id}'),
        body: wedding.toJson(),
      );

      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(
          message: 'Erreur lors de la mise à jour du mariage', 
          statusCode: response.statusCode
        );
      }
      return Wedding.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Wedding>> getWeddings() async {
    Response res = await get(
      Uri.parse('$_baseUrl/weddings'),
    );

    if (res.statusCode == 200) {
      Iterable decodedBody = jsonDecode(res.body);
      List<Wedding> weddings = decodedBody.map((weddingJson) => Wedding.fromJson(weddingJson)).toList();

      return weddings;
    } else {
      throw Exception(res.body);
    }
  }

  Future deleteWedding(int weddingId) async {
    final res = await delete(
      Uri.parse('$_baseUrl/wedding/$weddingId'),
    );

    if (res.statusCode == 200) {
      return;
    } else {
      throw Exception(res.body);
    }
  }
}
