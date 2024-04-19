class SignInUserDto {
  final String email;
  final String password;

  SignInUserDto({
    required this.email,
    required this.password,
  });

  factory SignInUserDto.fromJson(Map<String, dynamic> json) {
    return SignInUserDto(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Password': password,
    };
  }
}
