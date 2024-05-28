import 'package:client/features/auth/pages/signin_page.dart';
import 'package:client/features/message/widgets/rooms_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageListPage extends StatelessWidget {
  const MessageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RoomsView(),
      ),
    );
  }
}
