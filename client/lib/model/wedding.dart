import 'package:client/model/user.dart';

class Wedding {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String name;
  final String description;
  final String address;
  final String profileImage;
  final String phone;
  final String email;
  final int budget;
  final List? organizers;

  Wedding({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.description,
    required this.address,
    required this.profileImage,
    required this.phone,
    required this.email,
    required this.budget,
    this.organizers,
  });

  factory Wedding.fromJson(Map<String, dynamic> json) {
    return Wedding(
      id: json['ID'] as int,
      createdAt: json['CreatedAt'] as String,
      updatedAt: json['UpdatedAt'] as String,
      deletedAt: json['DeletedAt'] as String?,
      name: json['Name'] as String,
      description: json['Description'] as String,
      address: json['Address'] as String,
      profileImage: json['ProfileImage'] as String,
      phone: json['Phone'] as String,
      email: json['Email'] as String,
      budget: json['Budget'] as int,
      organizers: json['User']?.map((organizer) => User.fromJson(organizer)).toList(),
    );
  }
}