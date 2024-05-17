import 'dart:async';
import 'dart:convert';
import 'package:client/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/dto/message_dto.dart';
import 'package:client/features/message/bloc_message/message_bloc.dart';
import 'package:client/features/message/bloc_room/room_bloc.dart';
import 'package:client/repository/message_repository.dart';
import 'package:client/repository/room_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatForm extends StatefulWidget {
  final String? currentChat;
  final String roomId;
  final int userId;

  const ChatForm({Key? key, this.currentChat, required this.roomId, required this.userId}) : super(key: key);

  @override
  State<ChatForm> createState() => _ChatState();
}

class _ChatState extends State<ChatForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  WebSocketChannel? channel;
  late StreamSubscription roomBlocSubscription;
  late StreamSubscription messageSubscription;
  late RoomRepository roomRepository;
  late MessageRepository messageRepository;

  @override
  void initState() {
    super.initState();
    roomRepository = context.read<RoomRepository>();
    messageRepository = context.read<MessageRepository>();

    roomBlocSubscription = context.read<RoomBloc>().stream.listen((state) {
      print('RoomBloc state: $state');
      if (state is RoomJoined) {
        if (mounted) {
          setState(() {
            channel = roomRepository.getChannel();
            messageRepository.channel = channel;
          });
          print('Room joined, fetching messages for room ID: ${widget.roomId}');
          context.read<MessageBloc>().add(FetchMessagesEvent(int.parse(widget.roomId)));

          // Écouter les nouveaux messages du RoomRepository
          messageSubscription = roomRepository.messageStream.listen((message) {
            context.read<MessageBloc>().add(ReceiveMessageEvent(message));
          });
        }
      }
    });

    print('Adding JoinRoomEvent');
    context.read<RoomBloc>().add(JoinRoomEvent(roomId: widget.roomId, userId: widget.userId));
  }


  @override
  void dispose() {
    roomBlocSubscription.cancel();
    messageSubscription.cancel();
    roomRepository.closeConnection();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_formKey.currentState?.validate() ?? false) {
      final messageContent = _messageController.text;
      final messageDto = MessageDto(
        content: messageContent,
        userId: widget.userId,
        roomId: int.parse(widget.roomId),
      );

      context.read<MessageBloc>().add(SendMessageEvent(messageDto: messageDto));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<MessageBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is MessagesLoaded) {
                    if (state.messages.isEmpty) {
                      return Center(child: Text('No messages'));
                    }

                    return ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMine = message.userId == widget.userId;
                        return Align(
                          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: isMine ? Colors.blueAccent : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(message.content),
                          ),
                        );
                      },
                    );
                  } else if (state is MessageError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(labelText: 'Message'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a message';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _sendMessage,
                      child: Text('Send Message'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
