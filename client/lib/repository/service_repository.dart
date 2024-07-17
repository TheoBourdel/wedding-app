import 'dart:convert';
import 'package:client/core/constant/constant.dart';
import 'package:client/dto/service_dto.dart';
import 'package:client/model/service.dart';
import 'package:client/provider/token_utils.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ServiceRepository {
  final String _baseUrl = apiUrl;

  Future createService(ServiceDto service) async {
    String? token = await TokenUtils.getToken();

    final res = await post(
      Uri.parse('$_baseUrl/addservice'),
      body: json.encode(service),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 201) {
      return Service.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  Future<Service?> updateService(ServiceDto service) async {
    String? token = await TokenUtils.getToken();

    final id = service.id;
    try {
      Response res = await patch(
        Uri.parse('$_baseUrl/service/$id'),
        body: json.encode(service),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 204) {
        final updatedService = await getServiceById(id!);
        return updatedService;
      } else {
        throw Exception('Erreur lors de la mise à jour du service');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du service');
    }
  }

  Future<Service> getUserService(int userId) async {
    String? token = await TokenUtils.getToken();

    Response res = await get(
      Uri.parse('$_baseUrl/userservice/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> decodedBody = jsonDecode(res.body);
      Service service = Service.fromJson(decodedBody);
      return service;
    } else {
      throw Exception(res.body);
    }
  }


  Future<List<Service>> getServicesByUserID(int userId) async {
    String? token = await TokenUtils.getToken();

    final res = await http.get(
      Uri.parse('$_baseUrl/user/$userId/services'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      final List<dynamic> decodedBody = jsonDecode(res.body);
      final List<Service> services = decodedBody.map((serviceJson) => Service.fromJson(serviceJson)).toList();
      return services;
    } else {
      throw Exception('Failed to load services: ${res.body}');
    }
  }


  Future<List<Service>> getServices() async {
    String? token = await TokenUtils.getToken();

    Response res = await get(
      Uri.parse('$_baseUrl/services'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      Iterable decodedBody = jsonDecode(res.body);
      List<Service> services = decodedBody.map((serviceJson) => Service.fromJson(serviceJson)).toList();

      return services;
    } else {
      throw Exception(res.body);
    }
  }

  Future deleteService(int id) async {
    String? token = await TokenUtils.getToken();

    final res = await delete(
      Uri.parse('$_baseUrl/service/$id'),
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


  Future<void> uploadImages(int serviceId, List<XFile> images) async {

    Uri uri = Uri.parse('$_baseUrl/images/upload');
    for (var image in images) {
      var request = http.MultipartRequest('POST', uri);
      request.fields['serviceId'] = serviceId.toString();
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      try {
        var streamedResponse = await request.send();
        if (streamedResponse.statusCode == 200) {
        } else {
          streamedResponse.stream.transform(utf8.decoder).listen((value) {
          });
        }
      } catch (e) {
        throw Exception('Erreur lors de l\'envoi des images');
      }
    }
  }

  Future<List<Service>> searchServicesByName(String name) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/services/search?name=$name'),
    );

    if (res.statusCode == 200) {
      final List<dynamic> decodedBody = jsonDecode(res.body);
      final List<Service> services = decodedBody.map((serviceJson) => Service.fromJson(serviceJson)).toList();
      return services;
    } else {
      return [];
     // throw Exception('Failed to load services: ${res.body}');
    }
  }

  static Future<Service> getServiceById(int serviceId) async {
    String? token = await TokenUtils.getToken();
    Response res = await get(
      Uri.parse('$apiUrl/service/$serviceId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      return Service.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  static Future<List<Service>> getFavoritesServicesByUserId(int userId) async {
    String? token = await TokenUtils.getToken();
    Response res = await get(
      Uri.parse('$apiUrl/user/$userId/favorites/services'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final List<dynamic> decodedBody = jsonDecode(res.body);
      final List<Service> services = decodedBody.map((serviceJson) => Service.fromJson(serviceJson)).toList();
      return services;
    } else {
      throw Exception(res.body);
    }
  }
}