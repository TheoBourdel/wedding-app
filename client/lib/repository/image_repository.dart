import 'package:client/core/constant/constant.dart';
import 'package:client/dto/image_dto.dart';
import 'package:client/model/image.dart';
import 'package:http/http.dart';
import 'dart:convert';


class ImageRepository {
  final String _baseUrl = apiUrl;

  Future createImage(ImageDto image) async {
    final res = await post(
      Uri.parse('$_baseUrl/addimage'),
      body: json.encode(image),
    );

    if (res.statusCode == 201) {
      return Image.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }


  /*Future<Image> getUserImage(int userId) async {
    Response res = await get(
      Uri.parse('$_baseUrl/userimage/$userId'),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(res.body);
      Image image = Image.fromJson(decodedBody);
      return image;
    } else {
      throw Exception(res.body);
    }
  }*/


  Future<List<Image>> getImages() async {
    Response res = await get(
      Uri.parse('$_baseUrl/images'),
    );

    if (res.statusCode == 200) {
      Iterable decodedBody = jsonDecode(res.body);
      List<Image> images = decodedBody.map((imageJson) => Image.fromJson(imageJson)).toList();
      print(images);

      return images;
    } else {
      throw Exception(res.body);
    }
  }

  Future deleteImage(int id) async {
    final res = await delete(
      Uri.parse('$_baseUrl/image/$id'),
    );

    if (res.statusCode == 200) {
      return;
    } else {
      throw Exception(res.body);
    }
  }
}