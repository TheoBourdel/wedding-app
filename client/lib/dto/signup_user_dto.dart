class SignUpUserDto {
  final String email;
  final String password;
  final String role;

  SignUpUserDto({
    required this.email,
    required this.password,
    required this.role,
  });

  factory SignUpUserDto.fromJson(Map<String, dynamic> json) {
    return SignUpUserDto(
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Password': password,
      'Role': role,
    };
  }
}
