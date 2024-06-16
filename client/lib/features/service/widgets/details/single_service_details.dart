import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:client/features/service/widgets/details/single_service_details_bottom.dart';
import 'package:client/features/service/services_theme.dart';

AnimatedPadding buildHotelDetails(name, description, price, localisation, Color defaultColor,
    Color secondColor, bool extendDetails, Size size, int ServiceID) {
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
                    top: Radius.circular(40)),
              ),
              width: size.width,
              height: extendDetails ? size.height * 0.53 : size.height * 0.48,
              child: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.03,
                  left: size.width * 0.08,
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
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.pink,
                                  size: size.height * 0.02,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: size.width * 0.015,
                                  ),
                                  child: Text(
                                    localisation,
                                    
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.pink,
                              size: size.height * 0.025,
                            ),
                            Text(
                              "5",
                              
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: defaultColor,
                      thickness: 0.5,
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                      width: size.width * 0.8,
                      height:
                      extendDetails ? size.height * 0.4 : size.height * 0.35,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Text(
                          description,
                          
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
          BuildDetailsBottomBar(price: price, defaultColor: defaultColor, secondColor: secondColor, size: size, serviceID: ServiceID),
        ],
      ),
    ),
  );
}