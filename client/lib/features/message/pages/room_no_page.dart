import 'package:flutter/material.dart';

class NoRoomPage extends StatelessWidget {
  const NoRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('No rooms available.'),
      ),
    );
  }
}
