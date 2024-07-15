import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/budget/pages/budget.dart';
import 'package:client/features/organizer/pages/organizer_page.dart';
import 'package:client/features/wedding/pages/wedding_form.dart';
import 'package:client/features/wedding/widgets/wedding_countdown_card.dart';
import 'package:client/features/wedding/widgets/wedding_info_card.dart';
import 'package:client/features/wedding/widgets/wedding_info_line.dart';
import 'package:client/model/wedding.dart';
import 'package:client/services/budget_service.dart';
import 'package:client/shared/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class WeddingInfoPage extends StatelessWidget {
  final Wedding wedding;
  const WeddingInfoPage({super.key, required this.wedding});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userRole = authState is Authenticated ? authState.userRole : null;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gérer votre mariage",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Votre mariage est dans : ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 8, right: 20, bottom: 0),
              child: Column(
                children: [
                  WeddingCountDownCard(weddingDate: wedding.date),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      WeddingInfoLine(title: wedding.email, icon: Iconsax.sms),
                      const SizedBox(height: 10),
                      WeddingInfoLine(title: wedding.phone, icon: Iconsax.call),
                      const SizedBox(height: 10),
                      WeddingInfoLine(title: wedding.address, icon: Iconsax.location),
                    ]
                  )
                ],
              )
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Planning',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => BudgetManagementPage(weddingId: wedding.id, budget: wedding.budget),
                        ));
                      },
                      child: const WeddingInfoCard(title: "Budget", value: "", icon: Iconsax.wallet),
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      children: [
                        Expanded(
                          child: WeddingInfoCard(title: "Signets", value: "", icon: Iconsax.archive_tick),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: WeddingInfoCard(title: "Prestations", value: "", icon: Iconsax.briefcase),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Expanded(
                          child: WeddingInfoCard(title: "ToDo", value: "", icon: Iconsax.clipboard_text),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => OrganizerPage(weddingId: wedding.id),
                              ));
                            },
                            child: const WeddingInfoCard(title: "Organisateurs", value: "", icon: Iconsax.profile_2user),
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            userRole == "marry" 
              ? Padding(
              padding: const EdgeInsets.all(20),
              child: Button(
                text: "Modifier",
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => WeddingFormPage(title: "Modifier", wedding: wedding),
                  )); 
                },
                isOutlined: true,
              )
            ): const SizedBox(height: 100,),
          ],
        ),
      )
    );
  }
}