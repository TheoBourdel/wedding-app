import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:client/features/service/widgets/details/single_service_details_bottom.dart';
import 'package:iconsax/iconsax.dart';

AnimatedPadding buildServiceDetails(service, Color defaultColor,
    Color secondColor, bool extendDetails, Size size,int ServiceID) {
  return AnimatedPadding(
    padding: EdgeInsets.only(
      top: extendDetails ? size.height * 0.3 : size.height * 0.35,
    ),
    duration: const Duration(milliseconds: 300),
    child: SingleChildScrollView(
      child: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Container(
              decoration: BoxDecoration(
                color: secondColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)),
              ),
              width: size.width,
              height: extendDetails ? size.height * 0.53 : size.height * 0.48,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          service?.name,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                            color: defaultColor,
                            fontSize: size.height * 0.035,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Iconsax.location,
                          color: AppColors.pink,
                          size: size.height * 0.02,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          service?.localisation,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Iconsax.call,
                          color: AppColors.pink,
                          size: size.height * 0.02,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          service?.phone,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Iconsax.sms,
                          color: AppColors.pink,
                          size: size.height * 0.02,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          service?.mail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Text(
                        service!.description.toString(),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: size.height * 0.018,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),        
              ),
            ),
          ),
          SingleServiceDetailsBottom(
            price: service.price,
            defaultColor: defaultColor,
            secondColor: secondColor,
            size: size,
            service: service,
            serviceID: ServiceID
          ),
        ],
      ),
    ),
  );
}