import 'dart:async';

import 'package:client/dto/message_dto.dart';
import 'package:client/features/message/bloc_message/message_bloc.dart';
import 'package:client/features/message/bloc_room/room_bloc.dart';
import 'package:client/repository/message_repository.dart';
import 'package:client/repository/room_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late RoomRepository roomRepository;
  late MessageRepository messageRepository;

  @override
  void initState() {
    super.initState();
    roomRepository = context.read<RoomRepository>();
    messageRepository = context.read<MessageRepository>();

    roomBlocSubscription = context.read<RoomBloc>().stream.listen((state) {
      if (state is RoomJoined) {
        if (mounted) {
          setState(() {
            channel = roomRepository.getChannel();
          });
        }
      }
    });

    context.read<RoomBloc>().add(JoinRoomEvent(roomId: widget.roomId, userId: widget.userId));
  }

  @override
  void dispose() {
    // Cancel the subscription to avoid memory leaks
    roomBlocSubscription.cancel();
    // Close the WebSocket connection safely
    roomRepository.closeConnection();
    // Dispose of the text controller
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
    return BlocProvider(
      create: (context) => MessageBloc(messageRepository..channel = channel),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.currentChat != null ? 'Edit Chat' : 'New Chat'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<MessageBloc, MessageState>(
                    builder: (context, state) {
                      if (state is MessagesLoaded) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is MessagesLoaded) {
                        return ListView.builder(
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            return ListTile(
                              title: Text(message.content),
                              subtitle: Text('Room: ${message.roomId}'),
                            );
                          },
                        );
                      } else {
                        return Center(child: Text('No messages'));
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a message';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _sendMessage,
                      child: Text('Send'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
