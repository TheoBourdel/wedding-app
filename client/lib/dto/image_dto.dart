class ImageDto {
  final int? id;
  final String? path;
  final int? ServiceID;


  ImageDto({
    this.id,
    required this.path,
    required this.ServiceID,
  });

  factory ImageDto.fromJson(Map<String, dynamic> json) {
    return ImageDto(
      id: json['ID'] as int?,
      path: json['Path'] as String?,
      ServiceID: json['ServiceID'] as int? ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Path': path,
      'ServiceID': ServiceID,
    };
  }
}