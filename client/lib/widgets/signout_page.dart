// lib/pages/signout_page.dart
import 'package:flutter/material.dart';

class SignOutPage extends StatelessWidget {
  const SignOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Out'),
      ),
      body: Center(
        child: Text('Sign Out Page'),
      ),
    );
  }
}
