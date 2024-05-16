part of 'room_bloc.dart';


abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class FetchRoomsEvent extends RoomEvent {
  final int userId;

  FetchRoomsEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CreateRoomEvent extends RoomEvent {
  final String roomName;

  const CreateRoomEvent(this.roomName);

  @override
  List<Object> get props => [roomName];
}

class JoinRoomEvent extends RoomEvent {
  final String roomId;
  final int userId;

  const JoinRoomEvent({required this.roomId, required this.userId});

  @override
  List<Object> get props => [roomId, userId];
}
