import 'package:client/core/constant/constant.dart';
import 'package:client/dto/create_estimate_dto.dart';
import 'package:client/model/estimate.dart';
import 'package:client/provider/token_utils.dart';
import 'package:http/http.dart';
import 'dart:convert';

class EstimateRepository {

  static Future<Estimate> createEstimate(int userId, CreateEstimateDto estimateDto) async {
    String? token = await TokenUtils.getToken();
    Response res = await post(
      Uri.parse('$apiUrl/user/$userId/estimate'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: estimateDto.toJson(),
    );

    if(res.statusCode == 200) {
      return Estimate.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  static Future<List<Estimate>> getEstimates(int clientId) async {
    String? token = await TokenUtils.getToken();

    Response res = await get(
      Uri.parse('$apiUrl/user/$clientId/estimates'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
    String? token = await TokenUtils.getToken();

    Response res = await patch(
      Uri.parse('$apiUrl/user/$userId/estimate/$estimateId'),
      body: jsonEncode(estimateJson),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if(res.statusCode == 200) {
      return Estimate.fromJson(jsonDecode(res.body));
    } else {
      throw Exception(res.body);
    }
  }

  static Future<void> deleteEstimate(int userId, int estimateId) async {
    String? token = await TokenUtils.getToken();

    Response res = await delete(
      Uri.parse('$apiUrl/user/$userId/estimate/$estimateId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if(res.statusCode != 204) {
      throw Exception(res.body);
    }
  }

  static Future<void> payEstimate(int estimateId, String nonce) async {
    String? token = await TokenUtils.getToken();

    final res = await post(
      Uri.parse('$apiUrl/pay'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'estimate_id': estimateId,
        'nonce': nonce,
      }),
    );

    if(res.statusCode != 200) {
      throw Exception(res.body);
    }
  }
}
