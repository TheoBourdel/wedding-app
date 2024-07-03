import 'package:client/features/message/widgets/rooms_list.dart';
import 'package:flutter/material.dart';

class MessageListPage extends StatelessWidget {
  const MessageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: SafeArea(
        child: RoomsView(),
      ),
    );
  }
}
