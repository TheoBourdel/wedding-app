import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationSender {
  final _credentials = ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "project_id": dotenv.env['PROJECT_ID']!,
    "private_key_id": dotenv.env['PRIVATE_KEY_ID']!,
    "private_key": dotenv.env['PRIVATE_KEY']!.replaceAll(r'\n', '\n'),
    "client_email": dotenv.env['CLIENT_EMAIL']!,
    "client_id": dotenv.env['CLIENT_ID']!,
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": dotenv.env['CLIENT_X509_CERT_URL']!
  });

  final _scopes = ['https://www.googleapis.com/auth/cloud-platform'];

  Future<void> sendNotification(String targetToken) async {
    final httpClient = http.Client();
    final client = await clientViaServiceAccount(_credentials, _scopes);

    final accessToken = client.credentials.accessToken.data;

    final url = 'https://fcm.googleapis.com/v1/projects/${dotenv.env['PROJECT_ID']}/messages:send';
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    };
    final payload = jsonEncode({
      'message': {
        'token': targetToken,
        'notification': {
          'title': 'Hello World',
          'body': 'This is an FCM notification message!'
        }
      }
    });

    final response = await http.post(Uri.parse(url), headers: headers, body: payload);

    if (response.statusCode == 200) {
      print('Message sent successfully');
    } else {
      print('Failed to send message: ${response.body}');
    }
  }
}
