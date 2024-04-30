import 'package:client/core/constant/constant.dart';
import 'package:client/dto/service_dto.dart';
import 'package:client/model/service.dart';
import 'package:http/http.dart';
import 'dart:convert';


class ServiceRepository {
  final String _baseUrl = apiUrl;

  Future createService(ServiceDto service) async {
    print(service);
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

  Future updateService(ServiceDto service) async {
    final id = service?.id;
    try{
      Response res = await patch(
        Uri.parse('$_baseUrl/service/$id'),
        body: json.encode(service),
      );

      if (res.statusCode == 201) {
        return Service.fromJson(jsonDecode(res.body));
      } else {
        throw Exception(res.body);
      }
    }catch(e){
      print('service repo $e ');
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
}