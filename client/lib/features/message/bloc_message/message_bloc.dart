import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:client/dto/message_dto.dart';
import 'package:client/model/message.dart';
import 'package:client/repository/message_repository.dart';

part 'message_state.dart';
part 'message_event.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository messageRepository;

  MessageBloc(this.messageRepository) : super(MessageInitial()) {
    on<SendMessageEvent>((event, emit) async {
      try {
        await messageRepository.sendMessage(event.messageDto);
        emit(MessageSent());
        add(FetchMessagesEvent(event.messageDto.roomId)); // Fetch messages after sending one
      } catch (e) {
        emit(MessageError(e.toString()));
      }
    });

    on<ReceiveMessageEvent>((event, emit) {
      if (state is MessagesLoaded) {
        final updatedMessages = List<Message>.from((state as MessagesLoaded).messages)..add(event.message);
        final b = updatedMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        //updatedMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        updatedMessages.forEach((element) {
          print('${element.content}  ${element.createdAt}');

        });
        emit(MessagesLoaded(updatedMessages));
      } else {
        emit(MessagesLoaded([event.message]));
      }
    });



    on<FetchMessagesEvent>((event, emit) async {
      try {
        final messages = await messageRepository.fetchMessages(event.roomId);
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        emit(MessagesLoaded(messages));
      } catch (e) {
        emit(MessageError(e.toString()));
      }
    });
  }
}