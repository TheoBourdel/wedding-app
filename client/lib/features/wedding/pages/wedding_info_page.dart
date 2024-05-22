import 'package:flutter/material.dart';

class WeddingInfoPage extends StatefulWidget {
  const WeddingInfoPage({super.key});

  @override
  State<WeddingInfoPage> createState() => _WeddingInfoPageState();
}

class _WeddingInfoPageState extends State<WeddingInfoPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Wedding Info Page'),
      ),
    );
  }
}