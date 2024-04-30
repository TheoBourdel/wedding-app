import 'package:client/model/user.dart';

class Wedding {
  final int? id;
  final String name;
  final String description;
  final String? profileImage;
  final String address;
  final String phone;
  final String email;
  final int budget;
  final int UserID;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final List? organizers;

  Wedding({
    this.id,
    required this.name,
    required this.description,
    this.profileImage,
    required this.address,
    required this.phone,
    required this.email,
    required this.budget,
    required this.UserID,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.organizers,
  });

  factory Wedding.fromJson(Map<String, dynamic> json) {
    return Wedding(
      id: json['ID'] as int?,
      name: json['Name'] as String,
      description: json['Description'] as String,
      profileImage: json['ProfileImage'] as String?,
      address: json['Address'] as String,
      phone: json['Phone'] as String,
      email: json['Email'] as String,
      budget: json['Budget'] as int,
      UserID: json['UserID'] as int,
      createdAt: json['CreatedAt'] as String?,
      updatedAt: json['UpdatedAt'] as String?,
      deletedAt: json['DeletedAt'] as String?,
      organizers: json['User']?.map((organizer) => User.fromJson(organizer)).toList(),
    );
  }
}
