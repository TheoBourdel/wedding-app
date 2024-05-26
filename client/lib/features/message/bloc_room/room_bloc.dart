import 'package:client/dto/room_dto.dart';
import 'package:client/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/model/room.dart';
import 'package:equatable/equatable.dart';
import 'package:client/repository/room_repository.dart';
import 'package:client/model/room_with_users.dart';

part 'room_state.dart';
part 'room_event.dart';



class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository roomRepository;

  RoomBloc(this.roomRepository) : super(RoomInitial()) {

    on<FetchRoomsEvent>((event, emit) async {
      try {
        final rooms = await roomRepository.fetchRooms(event.userId);
        emit(RoomsLoaded(rooms));
      } catch (e) {
        emit(RoomError(e.toString()));
      }
    });

    on<CreateRoomEvent>((event, emit) async {
      emit(RoomLoading());
      try {
        final roomDto = RoomDto(name: event.roomName);
        final room = await roomRepository.createRoom(roomDto, event.userId, event.otherUser);
        final message = await roomRepository.joinRoom(room.id.toString(), event.userId);
        emit(RoomCreated(room));
      } catch (e) {
        emit(RoomError(e.toString()));
      }
    });

    on<JoinRoomEvent>((event, emit) async {
      try {
        final message = await roomRepository.joinRoom(event.roomId, event.userId);
        emit(RoomJoined(Room(id:int.parse(event.roomId), name: ''), message));
      } catch (e) {
        emit(RoomError(e.toString()));
      }
    });
  }
}