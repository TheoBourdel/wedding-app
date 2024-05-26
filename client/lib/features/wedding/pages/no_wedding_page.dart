import 'package:client/features/wedding/pages/wedding_form.dart';
import 'package:client/shared/widget/button.dart';
import 'package:flutter/material.dart';

class NoWeddingPage extends StatelessWidget {
  const NoWeddingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/couple.png',
                    width: 300,
                    height: 300,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Vous n\'avez pas encore de mariage',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Vous devez créer votre mariage pour commencer à utiliser Weddy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Button(
              text: 'Créer un mariage',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const WeddingFormPage(title: "Créer"),
                ));        
              },
            )
          )
        ],
      ),
    );
  }
}