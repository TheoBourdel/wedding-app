import 'package:client/features/organizer/pages/organizers_page.dart';
import 'package:client/features/wedding/pages/wedding_form.dart';
import 'package:client/features/wedding/widgets/wedding_countdown_card.dart';
import 'package:client/features/wedding/widgets/wedding_info_card.dart';
import 'package:client/model/wedding.dart';
import 'package:client/shared/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class WeddingInfoPage extends StatelessWidget {
  final Wedding wedding;
  const WeddingInfoPage({super.key, required this.wedding});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 8, right: 20, bottom: 0),
                //child: Container(color: Colors.red,)
                child: Column(
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Votre mariage est dans :",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    WeddingCountDownCard()
                  ],
                )
              )
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                //child: Container(color: Colors.blue,)
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
                    WeddingInfoCard(title: "Budget", value: "TOTAL : ${wedding.budget}€", icon: Iconsax.wallet),
                    const SizedBox(height: 15),
                    const Row(
                      children: [
                        Expanded(
                          child: WeddingInfoCard(title: "Invités", value: "0", icon: Iconsax.people),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: WeddingInfoCard(title: "Prestations", value: "0", icon: Iconsax.briefcase),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Expanded(
                          child: WeddingInfoCard(title: "ToDo", value: "11/20", icon: Iconsax.clipboard_text),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const OrganizersPage(),
                              ));
                            },
                            child: const WeddingInfoCard(title: "Organisateurs", value: "0", icon: Iconsax.profile_2user),
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
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
            )
          ],
        ),
      )
    );
  }
}