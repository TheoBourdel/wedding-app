class CategoryDto {
  final int? id;
  final String? name;


  CategoryDto({
    this.id,
    required this.name,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: json['ID'] as int?,
      name: json['Name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
    };
  }
}