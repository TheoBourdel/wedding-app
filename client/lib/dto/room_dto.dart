class RoomDto {
  final int? id;
  final String name;
  final List<int>? userIds;

  RoomDto({
    this.id,
    required this.name,
    this.userIds,
  });

  factory RoomDto.fromJson(Map<String, dynamic> json) {
    return RoomDto(
      id: json['id'] != null ? int.parse(json['id']) : null,
      name: json['name'],
      userIds: json['user_ids'] != null ? List<int>.from(json['user_ids']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_ids': userIds,
    };
  }
}
