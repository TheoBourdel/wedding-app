import 'package:flutter/material.dart';
import 'package:client/core/theme/app_colors.dart';

class WeddingInfoCard extends StatelessWidget {
  final String title;
  final dynamic value;
  final IconData icon;

  const WeddingInfoCard({
    super.key, 
    required this.title, 
    required this.value,
    required this.icon
    });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.pink100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.pink200,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.pink600
                  )
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppColors.pink300
                  )
                ),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              icon,
              color: AppColors.pink600,
              size: 100,
            ),
          ),
        ],
      ),
    );
  }
}
