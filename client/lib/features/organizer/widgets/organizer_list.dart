import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:client/shared/widget/badge.dart' as CustomBadge;

class OrganizerList extends StatelessWidget {
  final List organizers;
  const OrganizerList({super.key, required this.organizers});
  
  @override
  Widget build(BuildContext context) {
    return organizers.isEmpty
      ? const Center(
        child: Text('No organizers found'),
      )
      : ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: AppColors.pink300,
          thickness: 1,
        ),
        padding: const EdgeInsets.all(20),
        itemCount: organizers.length,
        itemBuilder: (context, index) {
          final organizer = organizers[index];
          return ListTile(
            horizontalTitleGap: 10,
            title: Row(
              children: [
                Text(organizer.firstName ?? ''),
                const SizedBox(width: 10),
                Text(organizer.lastName ?? ''),
                const SizedBox(width: 10),
                organizer.role == "marry" 
                  ?  const CustomBadge.Badge(badgeText: "Vous", badgeColor: AppColors.pink400)
                  : organizer.role == "provider" 
                  ? const CustomBadge.Badge(badgeText: "Planner", badgeColor: AppColors.pink400)
                  : const SizedBox.shrink(),
              ]
            ),
            subtitle: Text(organizer.email ?? ''),
            // trailing: IconButton(
            //   icon: const Icon(Icons.delete),
            //   onPressed: () {
            //     // Add delete functionality here
            //   },
            // ),
          );
        },
      );
  }
}