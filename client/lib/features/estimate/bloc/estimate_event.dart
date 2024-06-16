import 'package:client/dto/create_estimate_dto.dart';
import 'package:client/model/estimate.dart';

sealed class EstimateEvent {}

final class EstimateCreateEvent extends EstimateEvent {
  final CreateEstimateDto createEstimateDto;
  final int userId;

  EstimateCreateEvent({required this.createEstimateDto, required this.userId});
}

final class EstimateUpdateEvent extends EstimateEvent {
  final Estimate estimate;
  final int userId;

  EstimateUpdateEvent({required this.estimate, required this.userId});
}

final class EstimatesLoadedEvent extends EstimateEvent {
  final int userId;

  EstimatesLoadedEvent({required this.userId});
}

final class EstimateDeleteEvent extends EstimateEvent {
  final int estimateId;
  final int userId;

  EstimateDeleteEvent({required this.estimateId, required this.userId});
}