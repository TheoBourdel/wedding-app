part of 'wedding_bloc.dart';

@immutable
sealed class WeddingEvent {}

// READ
final class WeddingDataLoaded extends WeddingEvent {
  final int userId;

  WeddingDataLoaded({required this.userId});
}

// CREATE
final class WeddingCreated extends WeddingEvent {
  final WeddingDto weddingDto;
  final int userId;

  WeddingCreated({required this.weddingDto, required this.userId});
}

// UPDATE
final class WeddingUpdated extends WeddingEvent {
  final Wedding wedding;

  WeddingUpdated({required this.wedding});
}