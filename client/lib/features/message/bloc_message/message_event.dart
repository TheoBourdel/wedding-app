part of 'message_bloc.dart';


abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends MessageEvent {
  final MessageDto messageDto;

  SendMessageEvent({required this.messageDto});

  @override
  List<Object> get props => [messageDto];
}

class ReceiveMessageEvent extends MessageEvent {
  final Message message;

  const ReceiveMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class FetchMessagesEvent extends MessageEvent {
  final int roomId;

  const FetchMessagesEvent(this.roomId);

  @override
  List<Object> get props => [roomId];
}
