class RoomWithUsers {
  final int id;
  final String roomName;
  final String roomId;
  final int userId;
  final String firstname;
  final String lastname;
  final String email;


  RoomWithUsers({
    required this.id,
    required this.roomName,
    required this.userId,
    required this.roomId,
    required this.firstname,
    required this.lastname,
    required this.email,
  });

  factory RoomWithUsers.fromJson(Map<String, dynamic> json) {
    return RoomWithUsers(
      id: json['id'],
      roomName: json['room_name'],
      userId: json['user_id'],
      roomId: json['room_id'],
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_name': roomName,
      'room_id': roomId,
      'user_id': userId,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
    };
  }
}
