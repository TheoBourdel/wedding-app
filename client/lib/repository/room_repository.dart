import 'dart:async';
import 'dart:convert';
import 'package:client/core/constant/constant.dart';
import 'package:client/dto/room_dto.dart';
import 'package:client/model/message.dart';
import 'package:client/model/room.dart';
import 'package:client/model/room_with_users.dart';
import 'package:client/model/user.dart';
import 'package:client/provider/token_utils.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:web_socket_channel/web_socket_channel.dart';

class RoomRepository {
  final String _baseUrl = apiUrl;
  final String _baseWsUrl = wsApiUrl;
  WebSocketChannel? channel;
  final StreamController<Message> _messageController = StreamController<Message>.broadcast();
  Stream<Message> get messageStream => _messageController.stream;

  Future<Room> createRoom(RoomDto roomDto, int userId, int otherUser) async {
    String? token = await TokenUtils.getToken();

    roomDto = RoomDto(
      id: roomDto.id,
      name: roomDto.name,
      userIds: [userId, otherUser],
    );

    final res = await http.post(
      Uri.parse('$_baseUrl/ws/createRoom'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',

      },
      body: json.encode(roomDto.toJson()),
    );

    if (res.statusCode == 200) {
      return Room.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to create room: ${res.body}');
    }
  }

  Future<Message> joinRoom(String roomId, int userId) {
    final url = '$_baseWsUrl/ws/joinRoom/$roomId?userId=$userId';
    channel = WebSocketChannel.connect(Uri.parse(url));
    final completer = Completer<Message>();
    channel?.stream.listen((message) {
      final messageObj = Message.fromJson(json.decode(message));
      _messageController.add(messageObj);
      if (!completer.isCompleted) {
        completer.complete(messageObj);
      }
    }, onError: (error) {
      if (!completer.isCompleted) {
        completer.completeError('Error: $error');
      }
    });

    return completer.future;
  }

  WebSocketChannel? getChannel() {
    return channel;
  }

  void closeConnection() {
    channel?.sink.close();
  }

  Future<List<RoomWithUsers>> fetchRooms(int userId) async {
    String? token = await TokenUtils.getToken();

    final response = await http.get(
        Uri.parse('$_baseUrl/ws/users/$userId/rooms'),
        headers: {
          'Authorization': 'Bearer $token',
        },
    );
    if (response.statusCode == 200) {
      if (response.body == "null") {
        return [];
      } else {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => RoomWithUsers.fromJson(json)).toList();
      }
    } else {
      return [];
    }
  }

  Future<String?> checkExistingRoom(int userId, int otherUserId) async {
    String? token = await TokenUtils.getToken();

    final request = {
      "user1_id": userId,
      "user2_id": otherUserId
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/ws/check-room-exists'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',

      },
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['exists']) {
        return data['room']['ID'].toString();
      }
    }
    return null;
  }

  Future<List<User>> getSessionChats(int roomId) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/ws/getParticipants/$roomId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode == 200) {
      Iterable decodedBody = json.decode(res.body);
      return decodedBody.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch session chats: ${res.body}');
    }
  }

  Future<List<RoomWithUsers>> getUsersInCommonRooms(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/ws/users/$userId/rooms'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => RoomWithUsers.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
