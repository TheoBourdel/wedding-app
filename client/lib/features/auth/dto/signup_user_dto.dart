class SignUpUserDto {
  final String email;
  final String password;

  SignUpUserDto({
    required this.email,
    required this.password,
  });

  factory SignUpUserDto.fromJson(Map<String, dynamic> json) {
    return SignUpUserDto(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}
