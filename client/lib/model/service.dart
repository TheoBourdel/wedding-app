import 'package:client/model/category.dart';

class Service {
  final int? id;
  final String? name;
  final String? description;
  final String? profileImage;
  final String? localisation;
  final String? phone;
  final String? mail;
  final int? price;
  final int UserID;
  final int? CategoryID;
  final Category category;
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
    required this.category,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['ID'] as int?,
      name: json['Name'] as String?,
      description: json['Description'] as String?,
      profileImage: json['ProfileImage'] as String?,
      localisation: json['Localisation'] as String?,
      phone: json['Phone'] as String?,
      mail: json['Mail'] as String?,
      price: json['Price'] as int?,
      UserID: json['UserID'] as int,
      CategoryID: json['CategoryID'] as int?,
      category: Category.fromJson(json['Category']),
      createdAt: json['CreatedAt'] as String?,
      updatedAt: json['UpdatedAt'] as String?,
      deletedAt: json['DeletedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id.toString(),
      'Name': name,
      'Description': description,
      'ProfileImage': profileImage,
      'Localisation': localisation,
      'Phone': phone,
      'Mail': mail,
      'Price': price.toString(),
      'UserID': UserID.toString(),
      'CategoryID': CategoryID.toString(),
      'Category': category.toJson(),
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt,
      'DeletedAt': deletedAt,
    };
  }
}