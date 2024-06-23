import 'package:client/dto/organizer_dto.dart';

sealed class OrganizerEvent {}

final class OrganizerCreateEvent extends OrganizerEvent {
  final OrganizerDto createOrganizerDto;
  final int weddingId;

  OrganizerCreateEvent({required this.createOrganizerDto, required this.weddingId});
}

final class OrganizerLoadEvent extends OrganizerEvent {
  final int weddingId;

  OrganizerLoadEvent({required this.weddingId});
}

final class OrganizerDeleteEvent extends OrganizerEvent {
  final int weddingId;
  final int userId;

  OrganizerDeleteEvent({required this.weddingId, required this.userId});
}