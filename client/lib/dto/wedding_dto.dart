import 'package:client/model/user.dart';

class WeddingDto {
  final int? id;
  final String name; // Required, so it shouldn't be nullable
  final String description; // Required, so it shouldn't be nullable
  final String address; // Required, so it shouldn't be nullable
  final String phone; // Required, so it shouldn't be nullable
  final String email; // Required, so it shouldn't be nullable
  final int budget; // Required, so it shouldn't be nullable
  final List<User>? organizers;


  WeddingDto({
    this.id,
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
      id: json['ID'] as int?,
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
