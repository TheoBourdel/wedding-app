import 'dart:convert';
import 'package:client/core/constant/constant.dart';
import 'package:client/dto/message_dto.dart';
import 'package:client/model/message.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageRepository {
  final String _baseUrl = apiUrl;
  WebSocketChannel? channel;

  Future<void> sendMessage(MessageDto messageDto) async {
    if (channel != null) {
      channel!.sink.add(messageDto.content);
    } else {
      throw Exception('WebSocket is not connected.');
    }
  }

  Future<void> closeConnection() async {
    await channel?.sink.close();
  }

  Future<List<Message>> fetchMessages(int roomId) async {
    print('Fetching messages for room ID: $roomId');
    final res = await http.get(
      Uri.parse('$_baseUrl/room/$roomId/messages'),
      headers: {'Content-Type': 'application/json'},
    );

    print('HTTP response status: ${res.statusCode}');
    if (res.statusCode == 200) {
      Iterable decodedBody = json.decode(res.body);
      print('Decoded messages: $decodedBody');

      return decodedBody.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch messages: ${res.body}');
    }
  }
}