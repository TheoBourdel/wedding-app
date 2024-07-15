import 'package:client/model/Log.dart';
import 'package:client/provider/token_utils.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class LogRepository {
  final String _baseUrl = dotenv.env['API_URL']!;


  Future<List<Log>> getLogs() async {
    String? token = await TokenUtils.getToken();

    Response res = await get(
      Uri.parse('$_baseUrl/logs'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      Iterable decodedBody = jsonDecode(res.body);
      List<Log> logs = decodedBody.map((logJson) => Log.fromJson(logJson)).toList();

      return logs;
    } else {
      throw Exception(res.body);
    }
  }

}