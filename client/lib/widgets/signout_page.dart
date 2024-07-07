import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_event.dart';
import 'package:client/features/auth/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignOutPage extends StatelessWidget {
  const SignOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const SignOutEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Out'),
      ),
      body: const Center(
        child: Text('Vous êtes déconnecté'),
      ),
    );
  }
}
