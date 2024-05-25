import 'package:client/core/constant/constant.dart';
import 'package:client/dto/category_dto.dart';
import 'package:client/model/category.dart';
import 'package:http/http.dart';
import 'dart:convert';


class CategoryRepository {
  final String _baseUrl = apiUrl;

  Future createCategory(CategoryDto category) async {
    final res = await post(
      Uri.parse('$_baseUrl/addcategory'),
      body: json.encode(category),
    );

    if (res.statusCode == 201) {
      return Category.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  Future updateCategory(CategoryDto category) async {
    final id = category?.id;
    try{
      Response res = await patch(
        Uri.parse('$_baseUrl/category/$id'),
        body: json.encode(category),
      );

      if (res.statusCode == 201) {
        return Category.fromJson(jsonDecode(res.body));
      } else {
        throw Exception(res.body);
      }
    }catch(e){
      print('category repo $e ');
    }
  }


  /*Future<Category> getUserCategory(int userId) async {
    Response res = await get(
      Uri.parse('$_baseUrl/usercategory/$userId'),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(res.body);
      Category category = Category.fromJson(decodedBody);
      return category;
    } else {
      throw Exception(res.body);
    }
  }*/


  Future<List<Category>> getCategorys() async {
    Response res = await get(
      Uri.parse('$_baseUrl/categorys'),
    );

    if (res.statusCode == 200) {
      Iterable decodedBody = jsonDecode(res.body);
      List<Category> categorys = decodedBody.map((categoryJson) => Category.fromJson(categoryJson)).toList();
      print(categorys);

      return categorys;
    } else {
      throw Exception(res.body);
    }
  }

  Future deleteCategory(int id) async {
    final res = await delete(
      Uri.parse('$_baseUrl/category/$id'),
    );

    if (res.statusCode == 200) {
      return;
    } else {
      throw Exception(res.body);
    }
  }
}