import 'package:client/features/organizer/bloc/organizer_event.dart';
import 'package:client/features/organizer/bloc/organizer_state.dart';
import 'package:client/repository/organizer_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

class OrganizerBloc extends Bloc<OrganizerEvent, OrganizerState> {
  final OrganizerRepository organizerRepository;

  OrganizerBloc(this.organizerRepository) : super(const OrganizerState()) {
    on<OrganizerLoadEvent>((event, emit) async {
      emit(state.copyWith(status: OrganizerStatus.loading));

      try {
        final organizers = await OrganizerRepository.getOrganizers(event.weddingId);
        emit(state.copyWith(status: OrganizerStatus.success, organizers: organizers));
      } catch (e) {
        emit(state.copyWith(status: OrganizerStatus.failure, error: "Error while loading organizers"));
      }
    });

    on<OrganizerCreateEvent>((event, emit) async {
      emit(state.copyWith(status: OrganizerStatus.loading));

      try {
        final organizer = await OrganizerRepository.addOrganizer(event.createOrganizerDto, event.weddingId);
        final currentState = state;
        final updatedOrganizers = [...currentState.organizers, organizer];
        
        emit(state.copyWith(status: OrganizerStatus.success, organizers: updatedOrganizers));
      } catch (error) {
        emit(state.copyWith(status: OrganizerStatus.failure, error: error.toString()));
      }
    });

    on<OrganizerDeleteEvent>((event, emit) async {
      emit(state.copyWith(status: OrganizerStatus.loading));

      try {
        await OrganizerRepository.deleteOrganizer(event.weddingId, event.userId);
        final currentState = state;
        final updatedOrganizers = currentState.organizers.where((organizer) => organizer.id != event.userId).toList();
        
        emit(state.copyWith(status: OrganizerStatus.success, organizers: updatedOrganizers));
      } catch (e) {
        emit(state.copyWith(status: OrganizerStatus.failure, error: "Error while deleting organizer"));
      }
    });
  }
}