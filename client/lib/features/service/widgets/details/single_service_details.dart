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
                padding: EdgeInsets.only(
                  top: size.height * 0.02,
                  left: size.width * 0.06,
                  right: size.width * 0.08,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width * 0.65,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Row(
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
                                    const SizedBox(width: 10),
                                    // Container(
                                    //   color: AppColors.pink500,
                                    //   child: Padding(
                                    //     padding: EdgeInsets.symmetric(
                                    //       vertical: size.height * 0.005,
                                    //       horizontal: size.width * 0.04,
                                    //     ),
                                    //     child: Text('service?.category.name')
                                    //   ),
                                    // )
                                  ],
                                )
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Iconsax.location,
                                  color: Colors.grey,
                                  size: size.height * 0.02,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  service?.localisation,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Icon(
                                  Iconsax.sms,
                                  color: Colors.grey,
                                  size: size.height * 0.02,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  service?.mail,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.width * 0.8,
                      height: extendDetails ? size.height * 0.4 : size.height * 0.35,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Text(
                          service?.description,
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: size.height * 0.018,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: defaultColor,
            height: size.height * 0.01,
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