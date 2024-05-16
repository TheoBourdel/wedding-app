class RoomDto {
  final int? id;
  final String name;

  RoomDto({
    this.id,
    required this.name,
  });

  factory RoomDto.fromJson(Map<String, dynamic> json) {
    return RoomDto(
      id: json['id'] != null ? int.parse(json['id']) : null,
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
