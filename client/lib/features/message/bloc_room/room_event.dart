part of 'room_bloc.dart';


abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class FetchRoomsEvent extends RoomEvent {
  final int userId;

  const FetchRoomsEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CreateRoomEvent extends RoomEvent {
  final String roomName;
  final int userId;
  final int otherUser;


  const CreateRoomEvent(this.roomName, {required this.userId, required this.otherUser});

  @override
  List<Object> get props => [roomName, userId];
}

class JoinRoomEvent extends RoomEvent {
  final String roomId;
  final int userId;

  const JoinRoomEvent({required this.roomId, required this.userId});

  @override
  List<Object> get props => [roomId, userId];
}