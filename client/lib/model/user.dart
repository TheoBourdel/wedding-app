import 'package:client/model/wedding.dart';

class User {
  final int id;
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String role;
  final List? weddings;

  User({
    required this.id,
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.role,
    this.weddings,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'] as int,
      email: json['Email'] as String,
      password: json['Password'] as String,
      firstName: json['Firstname'] as String?,
      lastName: json['Lastname'] as String?,
      createdAt: json['CreatedAt'] as String,
      updatedAt: json['UpdatedAt'] as String,
      deletedAt: json['DeletedAt'] as String?,
      role: json['Role'] as String,
      weddings: json['Weddings']?.map((wedding) => Wedding.fromJson(wedding)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Email': email,
      'Password': password,
      'Firstname': firstName,
      'Lastname': lastName,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt,
      'DeletedAt': deletedAt,
      'Role': role,
    };
  }
}
