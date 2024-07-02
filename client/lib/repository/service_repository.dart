import 'dart:convert';
import 'package:client/core/constant/constant.dart';
import 'package:client/dto/service_dto.dart';
import 'package:client/model/service.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ServiceRepository {
  final String _baseUrl = apiUrl;

  Future createService(ServiceDto service) async {
    final res = await post(
      Uri.parse('$_baseUrl/addservice'),
      body: json.encode(service),
    );

    if (res.statusCode == 201) {
      return Service.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  Future<Service?> updateService(ServiceDto service) async {
    final id = service.id;
    try {
      Response res = await patch(
        Uri.parse('$_baseUrl/service/$id'),
        body: json.encode(service),
      );

      if (res.statusCode == 204) {
        final updatedService = await getServiceById(id!);
        return updatedService;
      } else {
        throw Exception('Erreur lors de la mise à jour du service');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du service: $e');
      return null;
    }
  }

  Future<Service> getUserService(int userId) async {
    Response res = await get(
      Uri.parse('$_baseUrl/userservice/$userId'),
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
    final res = await http.get(
      Uri.parse('$_baseUrl/user/$userId/services'),
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
    Response res = await get(
      Uri.parse('$_baseUrl/services'),
    );

    if (res.statusCode == 200) {
      Iterable decodedBody = jsonDecode(res.body);
      List<Service> services = decodedBody.map((serviceJson) => Service.fromJson(serviceJson)).toList();
      print(services);

      return services;
    } else {
      throw Exception(res.body);
    }
  }

  Future deleteService(int id) async {
    final res = await delete(
      Uri.parse('$_baseUrl/service/$id'),
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
          print("Image uploaded successfully");
        } else {
          print("Failed to upload image: ${streamedResponse.statusCode}");
          streamedResponse.stream.transform(utf8.decoder).listen((value) {
            print(value);
          });
        }
      } catch (e) {
        print("Error uploading image: $e");
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
    Response res = await get(
      Uri.parse('$apiUrl/service/$serviceId'),
    );

    if (res.statusCode == 200) {
      return Service.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }
}