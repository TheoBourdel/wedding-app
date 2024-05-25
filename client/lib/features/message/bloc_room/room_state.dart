part of 'room_bloc.dart';


abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomsLoaded extends RoomState {
  final List<RoomWithUsers> rooms;

  const RoomsLoaded(this.rooms);

  @override
  List<Object> get props => [rooms];
}

class RoomCreated extends RoomState {
  final Room room;

  const RoomCreated(this.room);

  @override
  List<Object> get props => [room];
}

class RoomJoined extends RoomState {
  final Message message;

  const RoomJoined(this.message);

  @override
  List<Object> get props => [message];
}

class RoomError extends RoomState {
  final String message;

  const RoomError(this.message);

  @override
  List<Object> get props => [message];
}