class WeddingDto {
  final int? id;
  final String? name;
  final String? description;
  final String? address;
  final String? phone;
  final String? email;
  final int? budget;
  final int? UserID;


  WeddingDto({
    this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    required this.budget,
    required this.UserID,
  });

  factory WeddingDto.fromJson(Map<String, dynamic> json) {
    return WeddingDto(
      id: json['ID'] as int?,
      name: json['Name'] as String,
      description: json['Description'] as String,
      address: json['Address'] as String,
      phone: json['Phone'] as String,
      email: json['Email'] as String,
      budget: json['Budget'] as int ,
      UserID: json['UserID'] as int ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Description': description,
      'Address': address,
      'Phone': phone,
      'Email': email,
      'Budget': budget,
      'UserID': UserID,
    };
  }
}
