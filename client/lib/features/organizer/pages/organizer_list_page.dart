import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/organizer/widgets/organizer_bottom_modal_form.dart';
import 'package:client/features/organizer/widgets/organizer_card.dart';
import 'package:client/model/user.dart';
import 'package:client/shared/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizerListPage extends StatelessWidget {
  final List<User> organizers;
  final int weddingId;
  final BuildContext parentContext; 
  const OrganizerListPage({super.key, required this.organizers, required this.weddingId, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userRole = authState is Authenticated ? authState.userRole : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisateurs'),
      ),
      body: SafeArea(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            color: AppColors.pink300,
            thickness: 1,
          ),
          padding: const EdgeInsets.all(20),
          itemCount: organizers.length,
          itemBuilder: (context, index) {
            return OrganizerCard(organizer: organizers[index], weddingId: weddingId);
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
      bottomSheet: userRole == "marry"
        ? Container(
          color: Colors.grey[100],
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(40),
          child: Button(
            text: 'Inviter un organisateur',
            onPressed: () => {
              showModalBottomSheet(
                context: context,
                builder: (context) => OrganizerBottomModalForm(weddingId: weddingId)
              )
            },
          )
        )
      : null,
    );
  }
}
