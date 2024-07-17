import 'package:flutter/material.dart';
import 'package:client/features/service/widgets/buttons/favorite_button.dart';

class ServiceCard extends StatelessWidget {
  final bool? isFavorite;
  final VoidCallback? onToggleFavorite;
  final Function() loadImages;
  final Widget serviceCardContent;

  const ServiceCard({
    Key? key,
    this.isFavorite,
    this.onToggleFavorite,
    required this.loadImages,
    required this.serviceCardContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loadImages();
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.6), offset: const Offset(4, 4), blurRadius: 16),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Stack(
          children: [
            serviceCardContent,
            if (isFavorite != null && onToggleFavorite != null)
              FavoriteButton(
                isFavorite: isFavorite!,
                onTap: onToggleFavorite!,
              ),
          ],
        ),
      ),
    );
  }
}
