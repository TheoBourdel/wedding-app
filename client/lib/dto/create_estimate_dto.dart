class CreateEstimateDto {
  final String content;
  final String firstName;
  final String lastName;
  final int serviceId;

  CreateEstimateDto({
    required this.content,
    required this.firstName,
    required this.lastName,
    required this.serviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'Content': content,
      'Firstname': firstName,
      'Lastname': lastName,
      'ServiceID': serviceId.toString(),
    };
  }
}
