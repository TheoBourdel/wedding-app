import 'dart:convert';
import 'package:client/core/constant/constant.dart';
import 'package:client/model/favorite.dart';
import 'package:client/provider/token_utils.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class FavoriteRepository {
  final String _baseUrl = apiUrl;

  Future createFavorite(Favorite favorite) async {
    String? token = await TokenUtils.getToken();

    final res = await post(
      Uri.parse('$_baseUrl/addFavorite'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: json.encode(favorite),
    );

    if (res.statusCode == 201) {
      return Favorite.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  Future<List<Favorite>> getFavoritesByUserID(int userId) async {
    String? token = await TokenUtils.getToken();

    final res = await http.get(
      Uri.parse('$_baseUrl/user/$userId/favorites'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final List<dynamic> decodedBody = jsonDecode(res.body);
      final List<Favorite> favorites = decodedBody.map((favoriteJson) => Favorite.fromJson(favoriteJson)).toList();
      return favorites;
    } else {
      throw Exception('Failed to load favorites: ${res.body}');
    }
  }

  Future<List<Favorite>> getFavorites() async {
    String? token = await TokenUtils.getToken();

    Response res = await get(
      Uri.parse('$_baseUrl/favorites'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      Iterable decodedBody = jsonDecode(res.body);
      List<Favorite> favorites = decodedBody.map((favoriteJson) => Favorite.fromJson(favoriteJson)).toList();

      return favorites;
    } else {
      throw Exception(res.body);
    }
  }

  Future deleteFavorite(int id) async {
    String? token = await TokenUtils.getToken();

    final res = await delete(
      Uri.parse('$_baseUrl/favorite/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 204) {
      return;
    } else {
      throw Exception(res.body);
    }
  }

  static Future<List<Favorite>> getFavoritesByUserId(int userId) async {
    String? token = await TokenUtils.getToken();

    Response res = await get(
      Uri.parse('$apiUrl/user/$userId/favorites'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final List<dynamic> decodedBody = jsonDecode(res.body);
      final List<Favorite> favorites = decodedBody.map((favoriteJson) => Favorite.fromJson(favoriteJson)).toList();
      return favorites;
    } else {
      throw Exception(res.body);
    }
  }
}