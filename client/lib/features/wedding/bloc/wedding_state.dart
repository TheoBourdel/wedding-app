part of 'wedding_bloc.dart';

@immutable
sealed class WeddingState {}

final class WeddingInitial extends WeddingState {}

final class WeddingLoading extends WeddingState {}

final class WeddingDataLoadedSuccess extends WeddingState {
  final List<Wedding> wedding;

  WeddingDataLoadedSuccess({required this.wedding});
}
final class WeddingDataLoadedFailure extends WeddingState {
  final String error;

  WeddingDataLoadedFailure({required this.error});
}