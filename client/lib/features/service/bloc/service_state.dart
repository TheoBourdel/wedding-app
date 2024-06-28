import 'package:client/model/service.dart';

enum ServiceStatus { initial, loading, success, failure }

class ServiceState {
  final ServiceStatus status;
  final Service? service;
  final String? error;

  const ServiceState({
    this.status = ServiceStatus.initial,
    this.service,
    this.error,
  });

  ServiceState copyWith({
    ServiceStatus? status,
    Service? service,
    String? error,
  }) {
    return ServiceState(
      status: status ?? this.status,
      service: service ?? this.service,
      error: error,
    );
  }
}