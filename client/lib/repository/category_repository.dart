import 'package:client/core/constant/constant.dart';
import 'package:client/dto/category_dto.dart';
import 'package:client/model/category.dart';
import 'package:client/provider/token_utils.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class CategoryRepository {
  final String _baseUrl = dotenv.env['API_URL']!;

  Future createCategory(CategoryDto category) async {
    String? token = await TokenUtils.getToken();

    final res = await post(
      Uri.parse('$_baseUrl/addcategory'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: json.encode(category),
    );

    if (res.statusCode == 201) {
      return Category.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  Future updateCategory(CategoryDto category) async {
    String? token = await TokenUtils.getToken();

    final id = category.id;
    try{
      Response res = await patch(
        Uri.parse('$_baseUrl/category/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: json.encode(category),
      );

      if (res.statusCode == 201) {
        return Category.fromJson(jsonDecode(res.body));
      } else {
        throw Exception(res.body);
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<Category>> getCategorys() async {
    String? token = await TokenUtils.getToken();
    Response res = await get(
      Uri.parse('$_baseUrl/categorys'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      Iterable decodedBody = jsonDecode(res.body);
      List<Category> categorys = decodedBody.map((categoryJson) => Category.fromJson(categoryJson)).toList();

      return categorys;
    } else {
      throw Exception(res.body);
    }
  }

  Future deleteCategory(int id) async {
    String? token = await TokenUtils.getToken();

    final res = await delete(
      Uri.parse('$_baseUrl/category/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      return;
    } else {
      throw Exception(res.body);
    }
  }
}