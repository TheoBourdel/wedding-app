import 'package:client/model/estimate.dart';

enum EstimateStatus { initial, loading, success, failure }

class EstimateState {
  final EstimateStatus status;
  final List<Estimate> estimates;
  final String? error;

  const EstimateState({
    this.status = EstimateStatus.initial,
    this.estimates = const [],
    this.error,
  });

  EstimateState copyWith({
    EstimateStatus? status,
    List<Estimate>? estimates,
    int? userId,
    String? error,
  }) {
    return EstimateState(
      status: status ?? this.status,
      estimates: estimates ?? this.estimates,
      error: error,
    );
  }
}