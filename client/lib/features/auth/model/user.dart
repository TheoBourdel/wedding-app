class User {
  final int id;
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  User({
    required this.id,
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'] as int,
      email: json['Email'] as String,
      password: json['Password'] as String,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      createdAt: json['CreatedAt'] as String,
      updatedAt: json['UpdatedAt'] as String,
      deletedAt: json['DeletedAt'] as String?,
    );
  }
}
