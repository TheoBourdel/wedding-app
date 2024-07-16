import 'package:client/core/constant/constant.dart';
import 'package:client/dto/image_dto.dart';
import 'package:client/model/image.dart';
import 'package:client/provider/token_utils.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ImageRepository {
  final String _baseUrl = dotenv.env['API_URL']!;


  Future createImage(ImageDto image) async {
    String? token = await TokenUtils.getToken();

    final res = await post(
      Uri.parse('$_baseUrl/addimage'),
      body: json.encode(image),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 201) {
      return Image.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  Future<List<Image>> getImages() async {
    String? token = await TokenUtils.getToken();

    Response res = await get(
      Uri.parse('$_baseUrl/images'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      Iterable decodedBody = jsonDecode(res.body);
      List<Image> images = decodedBody.map((imageJson) => Image.fromJson(imageJson)).toList();

      return images;
    } else {
      throw Exception(res.body);
    }
  }

  Future<String> deleteImage(int id) async {
    String? token = await TokenUtils.getToken();

    final res = await delete(
      Uri.parse('$_baseUrl/image/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 204) {
      return "deleted image";
    } else {
      throw Exception(res.body);
    }
  }

  Future<List<Image>> getServiceImages(int serviceId) async {
    String? token = await TokenUtils.getToken();

    final response = await get(
        Uri.parse('$_baseUrl/service/$serviceId/images'),
        headers: {
          'Authorization': 'Bearer $token',
        },
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((data) => Image.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load images: ${response.body}');
    }
  }

  static Future<Image> getImageById(int id) async {
    String? token = await TokenUtils.getToken();

    Response res = await get(
      Uri.parse('$apiUrl/image/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      return Image.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

}