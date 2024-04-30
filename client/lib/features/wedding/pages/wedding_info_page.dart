import 'package:client/features/guest/pages/guest_page.dart';
import 'package:client/features/organizer/pages/organizers_page.dart';
import 'package:flutter/material.dart';

class WeddingInfoPage extends StatefulWidget {
  const WeddingInfoPage({super.key});

  @override
  State<WeddingInfoPage> createState() => _WeddingInfoPageState();
}

class _WeddingInfoPageState extends State<WeddingInfoPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text('Wedding Info Page'),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GuestPage(),
                  ),
                );
              },
              child: const Text('Go to Guest Page'),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrganizersPage(),
                  ),
                );
              },
              child: const Text('Go to Organizer Page'),
            )
          ],
        ),
      )
    );
  }
}