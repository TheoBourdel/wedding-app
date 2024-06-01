import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildDetailsBottomBar(
  int price,
  Color defaultColor,
  Color secondColor,
  Size size,
) {
  return Padding(
    padding: EdgeInsets.only(
      top: size.height * 0.01,
      left: size.width * 0.08,
      right: size.width * 0.08,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'prix d\'estimation',
              
            ),
            Row(
              children: [
                Text(
                  "\$ ${price}",
                  
                ),
              ],
            ),
          ],
        ),
        InkWell(
          onTap: () => print('book now'),
          child: Container(
            width: size.width * 0.35,
            height: size.height * 0.07,
            decoration: BoxDecoration(
              color: AppColors.pink,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              child: Text(
                'Devis',
              ),
            ),
          ),
        )
      ],
    ),
  );
}
