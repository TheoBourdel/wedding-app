class Room {
  final int id;
  final String name;

  Room({required this.id, required this.name});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['ID'] ,
      name: json['RoomName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
