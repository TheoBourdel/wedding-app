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
  String? androidToken;

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
    this.androidToken,
    required this.role,
    this.weddings,
  });

  User copyWith({
    int? id,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    String? androidToken,
    String? role,
    List? weddings,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      androidToken: androidToken ?? this.androidToken,
      role: role ?? this.role,
      weddings: weddings ?? this.weddings,
    );
  }

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
      androidToken: json['AndroidToken'] as String?,
      role: json['Role'] as String,
      weddings: json['Weddings']?.map((wedding) => Wedding.fromJson(wedding)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id.toString(),
      'Email': email,
      'Password': password,
      'Firstname': firstName,
      'Lastname': lastName,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt,
      'Role': role,
    };
  }
}
