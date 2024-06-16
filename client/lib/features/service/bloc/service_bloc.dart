import 'package:bloc/bloc.dart';
import 'package:client/features/service/bloc/service_event.dart';
import 'package:client/features/service/bloc/service_state.dart';
import 'package:client/model/service.dart';
import 'package:client/repository/service_repository.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository serviceRepository;

  ServiceBloc(this.serviceRepository) : super (const ServiceState()) {
    on<GetServiceByIdEvent>((event, emit) async {
      emit(state.copyWith(status: ServiceStatus.loading));

      try {
        final Service service = await ServiceRepository.getServiceById(event.serviceId);
        emit(state.copyWith(status: ServiceStatus.success, service: service));
      } catch (e) {
        emit(state.copyWith(status: ServiceStatus.failure, error: "Error while loading service"));
      }
    });
  }
}
