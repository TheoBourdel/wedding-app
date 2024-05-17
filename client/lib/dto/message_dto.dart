import 'package:client/model/message.dart';


class MessageDto {
  final int? id;
  final int roomId;
  final int userId;
  final String content;
  final DateTime? createdAt;

  MessageDto({
    this.id,
    required this.roomId,
    required this.userId,
    required this.content,
    this.createdAt,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      id: json['ID'] as int?,
      roomId: json['RoomID'] as int,
      userId: json['UserID'] as int,
      content: json['Content'] as String,
      createdAt: DateTime.parse(json['CreatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
