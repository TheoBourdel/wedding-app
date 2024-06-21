part of 'message_bloc.dart';


abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends MessageEvent {
  final MessageDto messageDto;
  final String token;

  SendMessageEvent({required this.messageDto, required this.token});

  @override
  List<Object> get props => [messageDto, token];
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
