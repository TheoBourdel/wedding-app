import 'package:client/core/constant/constant.dart';
import 'package:client/dto/wedding_dto.dart';
import 'package:client/model/wedding.dart';
import 'package:http/http.dart';
import 'dart:convert';


class WeddingRepository {
  final String _baseUrl = apiUrl;

  Future createWedding(WeddingDto wedding) async {
    final res = await post(
      Uri.parse('$_baseUrl/wedding'),
      body: json.encode(wedding),
    );

    if (res.statusCode == 201) {
      return Wedding.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  Future updateWedding(WeddingDto wedding) async {
    final id = wedding?.id;
    try{
      Response res = await patch(
        Uri.parse('$_baseUrl/wedding/$id'),
        body: json.encode(wedding),
      );

      if (res.statusCode == 201) {
        return Wedding.fromJson(jsonDecode(res.body));
      } else {
        throw Exception(res.body);
      }
    }catch(e){
      print('wedding repo $e ');
    }
  }


  Future<Wedding> getUserWedding(int userId) async {
    Response res = await get(
      Uri.parse('$_baseUrl/userwedding/$userId'),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(res.body);
      Wedding wedding = Wedding.fromJson(decodedBody);
      return wedding;
    } else {
      throw Exception(res.body);
    }
  }


  Future<List<Wedding>> getWeddings() async {
    Response res = await get(
      Uri.parse('$_baseUrl/weddings'),
    );

    if (res.statusCode == 200) {
      Iterable decodedBody = jsonDecode(res.body);
      List<Wedding> weddings = decodedBody.map((weddingJson) => Wedding.fromJson(weddingJson)).toList();
      print(weddings);

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
