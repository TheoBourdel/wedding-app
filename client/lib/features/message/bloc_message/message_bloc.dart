import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:client/dto/message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/model/message.dart';
import 'package:client/repository/message_repository.dart';

part 'message_state.dart';
part 'message_event.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository messageRepository;

  MessageBloc(this.messageRepository) : super(MessageInitial()) {

    on<SendMessageEvent>((event, emit) async {
      try {
        print('SendMessageEvent $event.messageDto');
        await messageRepository.sendMessage(event.messageDto);
        emit(MessageSent());
      } catch (e) {
        emit(MessageError(e.toString()));
      }
    });

    on<ReceiveMessageEvent>((event, emit) {
      emit(MessageReceived(event.message));
    });

    on<FetchMessagesEvent>((event, emit) async {
      try {
        final messages = await messageRepository.fetchMessages(event.roomId);
        emit(MessagesLoaded(messages));
      } catch (e) {
        emit(MessageError(e.toString()));
      }
    });
  }
}