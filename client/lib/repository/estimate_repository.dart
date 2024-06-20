import 'package:client/core/constant/constant.dart';
import 'package:client/dto/create_estimate_dto.dart';
import 'package:client/model/estimate.dart';
import 'package:http/http.dart';
import 'dart:convert';

class EstimateRepository {

  static Future<Estimate> createEstimate(int userId, CreateEstimateDto estimateDto) async {
    Response res = await post(
      Uri.parse('$apiUrl/user/$userId/estimate'),
      body: estimateDto.toJson(),
    );

    if(res.statusCode == 200) {
      return Estimate.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  static Future<List<Estimate>> getEstimates(int clientId) async {
    Response res = await get(
      Uri.parse('$apiUrl/user/$clientId/estimates'),
    );

    if(res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Estimate> estimates = body.map((dynamic item) => Estimate.fromJson(item)).toList();
      return estimates;
    } else {
      throw Exception(res.body);
    }
  }

  static Future<Estimate> updateEstimate(int userId, Estimate estimate) async {
    int estimateId = estimate.id;
    Map<String, dynamic> estimateJson = estimate.toJson();
    estimateJson.remove('Service');
    
    Response res = await patch(
      Uri.parse('$apiUrl/user/$userId/estimate/$estimateId'),
      body: jsonEncode(estimateJson),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(res.statusCode == 200) {
      return Estimate.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  static Future<void> deleteEstimate(int userId, int estimateId) async {
    Response res = await delete(
      Uri.parse('$apiUrl/user/$userId/estimate/$estimateId'),
    );

    if(res.statusCode != 204) {
      throw Exception(res.body);
    }
  }
}
