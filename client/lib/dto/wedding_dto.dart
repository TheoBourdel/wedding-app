import 'package:client/model/user.dart';

class WeddingDto {
  final String address;
  final String phone;
  final String email;
  final int budget;
  final String date;
  final List<User>? organizers;


  WeddingDto({
    required this.address,
    required this.phone,
    required this.email,
    required this.budget,
    required this.date,
    this.organizers,
  });

  factory WeddingDto.fromJson(Map<String, dynamic> json) {

    var organizersJson = json['User'] as List<dynamic>?;
    List<User>? organizers = organizersJson?.map((organizer) => User.fromJson(organizer as Map<String, dynamic>)).toList();

    return WeddingDto(
      address: json['Address'] as String,
      phone: json['Phone'] as String,
      email: json['Email'] as String,
      budget: json['Budget'] as int,
      date: json['Date'] as String,
      organizers: organizers,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'Address': address,
      'Phone': phone,
      'Email': email,
      'Budget': budget.toString(),
      'Date': date,
    };

    if (organizers != null) {
      data['User'] = organizers;
    }

    return data;
  }
}
