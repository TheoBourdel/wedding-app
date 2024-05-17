class Message {
  final int id;
  final int roomId;
  final int userId;
  final String content;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['ID'],
      roomId: json['RoomID'],
      userId: json['UserID'],
      content: json['Content'],
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}
