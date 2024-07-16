import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/service/widgets/services_theme.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteButton({
    Key? key,
    required this.isFavorite,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color.fromARGB(188, 255, 255, 255),
            ),
            padding: const EdgeInsets.all(10),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: child.key == ValueKey<bool>(isFavorite) ? Tween<double>(begin: 0.75, end: 1.0).animate(animation) : Tween<double>(begin: 1.0, end: 0.75).animate(animation),
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: isFavorite
                  ? Icon(Iconsax.archive_tick1, color: AppColors.pink500, size: 25.0, key: ValueKey<bool>(isFavorite))
                  : Icon(Iconsax.archive_add, size: 25.0, color: ServiceTheme.buildLightTheme().primaryColor, key: ValueKey<bool>(isFavorite)),
            ),
          ),
        ),
      ),
    );
  }
}
