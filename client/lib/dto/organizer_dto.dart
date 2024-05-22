class OrganizerDto {
  final String email;
  final String firstName;

  OrganizerDto({
    required this.email,
    required this.firstName,
  });

  factory OrganizerDto.fromJson(Map<String, dynamic> json) {
    return OrganizerDto(
      email: json['Email'] as String,
      firstName: json['FirstName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Firstname': firstName,
    };
  }
}
