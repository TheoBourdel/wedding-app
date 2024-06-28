import 'package:client/model/user.dart';

class WeddingDto {
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final int budget;
  final List<User>? organizers;


  WeddingDto({
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    required this.budget,
    this.organizers,
  });

  factory WeddingDto.fromJson(Map<String, dynamic> json) {

    var organizersJson = json['User'] as List<dynamic>?;
    List<User>? organizers = organizersJson?.map((organizer) => User.fromJson(organizer as Map<String, dynamic>)).toList();

    return WeddingDto(
      name: json['Name'] as String,
      description: json['Description'] as String,
      address: json['Address'] as String,
      phone: json['Phone'] as String,
      email: json['Email'] as String,
      budget: json['Budget'] as int,
      organizers: organizers,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'Name': name,
      'Description': description,
      'Address': address,
      'Phone': phone,
      'Email': email,
      'Budget': budget.toString(),
    };

    if (organizers != null) {
      data['User'] = organizers;
    }

    return data;
  }
}
