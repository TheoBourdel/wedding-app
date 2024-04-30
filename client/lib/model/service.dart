class Service {
  final int? id;
  final String name;
  final String description;
  final String? profileImage;
  final String localisation;
  final String phone;
  final String mail;
  final int price;
  final int UserID;
  final int CategoryID;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Service({
    this.id,
    required this.name,
    required this.description,
    this.profileImage,
    required this.localisation,
    required this.phone,
    required this.mail,
    required this.price,
    required this.UserID,
    required this.CategoryID,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['ID'] as int?,
      name: json['Name'] as String,
      description: json['Description'] as String,
      profileImage: json['ProfileImage'] as String?,
      localisation: json['Localisation'] as String,
      phone: json['Phone'] as String,
      mail: json['Email'] as String,
      price: json['Budget'] as int,
      UserID: json['UserID'] as int,
      CategoryID: json['CategoryID'] as int,
      createdAt: json['CreatedAt'] as String?,
      updatedAt: json['UpdatedAt'] as String?,
      deletedAt: json['DeletedAt'] as String?,
    );
  }
}