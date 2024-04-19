import 'package:flutter/material.dart';

class ProviderInfoPage extends StatefulWidget {
  const ProviderInfoPage({super.key});

  @override
  State<ProviderInfoPage> createState() => _ProviderInfoPageState();
}

class _ProviderInfoPageState extends State<ProviderInfoPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Provider Info Page'),
      ),
    );
  }
}