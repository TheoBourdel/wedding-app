import 'package:client/core/theme/app_colors.dart';
import 'package:client/model/user.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:client/shared/widget/badge.dart' as CustomBadge;

class OrganizerCard extends StatelessWidget {
  final User organizer;
  const OrganizerCard({super.key, required this.organizer});

  @override
  Widget build(BuildContext context) {
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
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          // Add delete functionality here
        },
      ),
    );
  }
}