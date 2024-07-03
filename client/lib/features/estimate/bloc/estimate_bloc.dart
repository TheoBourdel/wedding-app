import 'package:client/features/estimate/bloc/estimate_event.dart';
import 'package:client/features/estimate/bloc/estimate_state.dart';
import 'package:client/model/estimate.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:client/repository/estimate_repository.dart';

class EstimateBloc extends Bloc<EstimateEvent, EstimateState> {
  final EstimateRepository estimateRepository;

  EstimateBloc(this.estimateRepository) : super(const EstimateState()) {
    on<EstimateCreateEvent>((event, emit) async {
      emit(state.copyWith(status: EstimateStatus.loading));

      try {
        final Estimate estimate = await EstimateRepository.createEstimate(event.userId, event.createEstimateDto);
        final currentState = state;
        final updatedEstimates = [...currentState.estimates, estimate];

        emit(state.copyWith(status: EstimateStatus.success, estimates: updatedEstimates));

      } catch (e) {
        emit(state.copyWith(status: EstimateStatus.failure, error: "Error while creating estimate"));
      }
    });

    on<EstimatesLoadedEvent>((event, emit) async {
      emit(state.copyWith(status: EstimateStatus.loading));

      try {
        final List<Estimate> estimates = await EstimateRepository.getEstimates(event.userId);
        emit(state.copyWith(status: EstimateStatus.success, estimates: estimates));
      } catch (e) {
        emit(state.copyWith(status: EstimateStatus.failure, error: "Error while loading estimates"));
      }
    });

    on<EstimateUpdateEvent>((event, emit) async {
      emit(state.copyWith(status: EstimateStatus.loading));

      try {
        final Estimate updatedEstimate = await EstimateRepository.updateEstimate(event.userId, event.estimate);

        final currentState = state;
        final updatedEstimates = currentState.estimates.map((estimate) {
          if (estimate.id == updatedEstimate.id) {
            return updatedEstimate;
          }
          return estimate;
        }).toList();

        emit(state.copyWith(status: EstimateStatus.success, estimates: updatedEstimates));

      } catch (e) {
        emit(state.copyWith(status: EstimateStatus.failure, error: "Error while updating estimate"));
      }
    });

    on<EstimateDeleteEvent>((event, emit) async {
      emit(state.copyWith(status: EstimateStatus.loading));

      try {
        await EstimateRepository.deleteEstimate(event.userId, event.estimateId);

        final currentState = state;
        final updatedEstimates = currentState.estimates.where((estimate) => estimate.id != event.estimateId).toList();
        emit(state.copyWith(status: EstimateStatus.success, estimates: updatedEstimates));

      } catch (e) {
        emit(state.copyWith(status: EstimateStatus.failure, error: "Error while deleting estimate"));
      }
    });
  }
}