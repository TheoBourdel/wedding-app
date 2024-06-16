import 'package:client/model/service.dart';
import 'package:client/model/user.dart';

class Estimate {
  final int id;
  final int price;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int clientId;
  final int providerId;
  final String status;
  final String content;
  final int serviceId;
  final Service? service;

  Estimate({
    required this.id,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.status,
    required this.content,
    required this.clientId,
    required this.providerId,
    required this.serviceId,
    this.service,
  });

  Estimate copyWith({String? status, String? content, int? price}) {
    return Estimate(
      id: id,
      content: content!,
      price: price!,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      clientId: clientId,
      providerId: providerId,
      serviceId: serviceId,
      service: service,
    );
  }

  factory Estimate.fromJson(Map<String, dynamic> json) {
    return Estimate(
      id: json['ID'] as int,
      price: json['Price'] as int,
      createdAt: json['CreatedAt'] as String,
      updatedAt: json['UpdatedAt'] as String,
      deletedAt: json['DeletedAt'] as String?,
      status: json['Status'] as String,
      content: json['Content'] as String,
      clientId: json['ClientID'] as int,
      providerId: json['ProviderID'] as int,
      serviceId: json['ServiceID'] as int,
      service: json['Service'] != null ? Service.fromJson(json['Service']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Price': price,
      'CreatedAt': createdAt as String,
      'UpdatedAt': updatedAt as String,
      'Status': status as String,
      'Content': content as String,
      'ClientID': clientId,
      'ProviderID': providerId,
      'ServiceID': serviceId,
      'Service': service?.toJson(),
    };
  }
}