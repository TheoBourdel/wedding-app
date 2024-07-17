import 'package:client/features/organizer/bloc/organizer_bloc.dart';
import 'package:client/features/organizer/bloc/organizer_event.dart';
import 'package:client/features/organizer/bloc/organizer_state.dart';
import 'package:client/features/organizer/pages/organizer_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizerPage extends StatelessWidget {

  final int weddingId;
  const OrganizerPage({super.key, required this.weddingId});

  @override
  Widget build(BuildContext context) {
    context.read<OrganizerBloc>().add(OrganizerLoadEvent(weddingId: weddingId));

    return Scaffold(
      body: BlocListener<OrganizerBloc, OrganizerState>(
        listener: (context, state) {
          if (state.status == OrganizerStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<OrganizerBloc, OrganizerState>(
          builder: (context, state) {
            if (state.status == OrganizerStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == OrganizerStatus.success) {
              return OrganizerListPage(
                organizers: state.organizers,
                weddingId: weddingId,
                parentContext: context,
              );
            }

            if (state.status == OrganizerStatus.failure) {
              return OrganizerListPage(
                organizers: state.organizers,
                weddingId: weddingId,
                parentContext: context,
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
