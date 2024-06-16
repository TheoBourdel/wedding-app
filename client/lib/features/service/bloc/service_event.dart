sealed class ServiceEvent {}

final class GetServiceByIdEvent extends ServiceEvent {
  final int serviceId;

  GetServiceByIdEvent({required this.serviceId});
}