class ServiceDto {
  final int? id;
  final String? name;
  final String? description;
  final String? localisation;
  final String? phone;
  final String? profileImage;
  final String? mail;
  final int? price;
  final int? UserID;
  final int? CategoryID;


  ServiceDto({
    this.id,
    required this.name,
    required this.description,
    required this.localisation,
    required this.phone,
    this.profileImage,
    required this.mail,
    required this.price,
    required this.UserID,
    this.CategoryID,
  });

  factory ServiceDto.fromJson(Map<String, dynamic> json) {
    return ServiceDto(
      id: json['ID'] as int?,
      name: json['Name'] as String,
      description: json['Description'] as String,
      localisation: json['Address'] as String,
      phone: json['Phone'] as String,
      profileImage: json['Phone'] as String,
      mail: json['Email'] as String,
      price: json['Budget'] as int ,
      UserID: json['UserID'] as int ,
      CategoryID: json['CategoryID'] as int ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Description': description,
      'localisation': localisation,
      'Phone': phone,
      'ProfileImage': profileImage,
      'Mail': mail,
      'Price': price,
      'UserID': UserID,
      'CategoryID': CategoryID,
    };
  }
}