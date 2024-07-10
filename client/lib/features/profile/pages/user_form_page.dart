import 'package:client/features/profile/bloc/profile_bloc.dart';
import 'package:client/features/profile/bloc/profile_event.dart';
import 'package:client/model/user.dart';
import 'package:client/shared/widget/button.dart';
import 'package:client/shared/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserFormPage extends StatefulWidget {
  final User user;
  const UserFormPage({super.key, required this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final formKey = GlobalKey<FormState>();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstnameController.text = widget.user.firstName!;
    lastnameController.text = widget.user.lastName!;
    emailController.text = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
      backgroundColor: Colors.grey[100],
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Input(hintText: 'Prénom', controller: firstnameController),
              const SizedBox(height: 20),
              Input(hintText: 'Nom', controller: lastnameController),
              const SizedBox(height: 20),
              Input(hintText: 'Email', controller: emailController),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.grey[100],
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(40),
        child: Button(
          text: 'Enregistrer',
          onPressed: () => {
            if (formKey.currentState!.validate()) {
              context.read<ProfileBloc>().add(
                ProfileUserUpdated(
                  user: widget.user.copyWith(
                    id: widget.user.id,
                    firstName: firstnameController.text,
                    lastName: lastnameController.text,
                    email: emailController.text,
                  ),
                ),
              ),
              Navigator.pop(context)
            }
          },
        ),
      ),
    );
  }
}