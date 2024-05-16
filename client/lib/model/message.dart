class Message {
  final int id;
  final String content;
  final int senderId;
  final int roomId;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.roomId,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0, // Provide default value if null
      content: json['content'] ?? '',
      senderId: json['senderId'] ?? 0,
      roomId: json['roomId'] ?? 0,
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'roomId': roomId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
