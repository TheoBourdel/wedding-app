import 'package:client/dto/organizer_dto.dart';
import 'package:client/features/organizer/bloc/organizer_bloc.dart';
import 'package:client/features/organizer/bloc/organizer_event.dart';
import 'package:client/shared/widget/button.dart';
import 'package:client/shared/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizerBottomModalForm extends StatefulWidget {
  final int weddingId;
  const OrganizerBottomModalForm({super.key, required this.weddingId});

  @override
  State<OrganizerBottomModalForm> createState() => _OrganizerBottomModalFormState();
}

class _OrganizerBottomModalFormState extends State<OrganizerBottomModalForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Inviter un organisateur',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Invite une personne à rejoindre ton équipe d\'organisation.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Form(
            key: formKey,
            child: Column(
              children: [
                Input(
                  hintText: "Email", 
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                Input(
                  hintText: "Nom", 
                  controller: nameController,
                ),
                const SizedBox(height: 20),
                Button(
                  text: 'Inviter',
                  onPressed: () => {
                    if (formKey.currentState!.validate()) {
                      context.read<OrganizerBloc>().add(
                        OrganizerCreateEvent(
                          createOrganizerDto: OrganizerDto(
                            email: emailController.text,
                            firstName: nameController.text,
                          ),
                          weddingId: widget.weddingId,
                        ),
                      ),
                      Navigator.pop(context)
                    }
                  },
                ),
              ],
            )
          ),
          const SizedBox(height: 20),
        ],
      )
    );
  }
}