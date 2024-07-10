import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/profile/bloc/profile_bloc.dart';
import 'package:client/features/profile/bloc/profile_event.dart';
import 'package:client/features/profile/bloc/profile_state.dart';
import 'package:client/features/profile/pages/user_form_page.dart';
import 'package:client/shared/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.userId : null;
    context.read<ProfileBloc>().add(ProfileUserLoaded(userId: userId!));
    
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      backgroundColor: Colors.grey[100],
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if(state.status == ProfileStatus.success) {
            return Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prénom',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(state.user?.firstName ?? '', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  const Text(
                    'Nom',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(state.user?.lastName ?? '', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  const Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(state.user?.email ?? '', style: const TextStyle(fontSize: 20)),
                ],
              ),
            );
          }

          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProfileStatus.failure) {
            return const Center(child: Text('Erreur lors du chargement du profil'));
          }
          return const SizedBox();
        }
      ),
      bottomSheet: Container(
        color: Colors.grey[100],
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(40),
        child: Button(
          text: 'Modifier',
          isOutlined: true,
          onPressed: () => {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => UserFormPage(user: context.read<ProfileBloc>().state.user!),
            ))
          },
        )
      )
    );
  }
}