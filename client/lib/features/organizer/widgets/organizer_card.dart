import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/organizer/bloc/organizer_bloc.dart';
import 'package:client/features/organizer/bloc/organizer_event.dart';
import 'package:client/model/user.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:client/shared/widget/badge.dart' as CustomBadge;
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizerCard extends StatelessWidget {
  final User organizer;
  final int weddingId;
  const OrganizerCard({super.key, required this.organizer, required this.weddingId});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userRole = authState is Authenticated ? authState.userRole : null;
    
    return ListTile(
      horizontalTitleGap: 10,
      title: Row(
        children: [
          Text(organizer.firstName ?? ''),
          const SizedBox(width: 10),
          Text(organizer.lastName ?? ''),
          const SizedBox(width: 10),
          organizer.role == "marry" 
            ?  const CustomBadge.Badge(badgeText: "Marié(e)", badgeColor: AppColors.pink400)
            : organizer.role == "provider" 
            ? const CustomBadge.Badge(badgeText: "Planner", badgeColor: AppColors.pink400)
            : const SizedBox.shrink(),
        ]
      ),
      subtitle: Text(organizer.email),
      trailing: (userRole == "marry" && organizer.role != "marry")
        ? IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<OrganizerBloc>().add(
              OrganizerDeleteEvent(
                weddingId: weddingId,
                userId: organizer.id
              )
            );
          },
        )
        : null,
    );
  }
}