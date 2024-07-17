// service_card_content.dart
import 'package:flutter/material.dart';
import 'package:client/features/service/widgets/services_theme.dart';

class ServiceCardContent extends StatelessWidget {
  final String imagePath;
  final Widget serviceDetails;

  const ServiceCardContent({
    Key? key,
    required this.imagePath,
    required this.serviceDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2,
          child: Image.network(imagePath, fit: BoxFit.cover),
        ),
        Container(
          color: ServiceTheme.buildLightTheme().colorScheme.background,
          child: serviceDetails,
        ),
      ],
    );
  }
}
