import 'package:client/core/theme/app_colors.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';

class WeddingCountDownCard extends StatelessWidget {
  final String weddingDate;
  const WeddingCountDownCard({super.key, required this.weddingDate});

  @override
  Widget build(BuildContext context) {
    int days = weddingDate.split("-").length > 2 ? int.parse(weddingDate.split("-")[2]) : 0;
    int months = weddingDate.split("-").length > 1 ? int.parse(weddingDate.split("-")[1]) : 0;
    int years = weddingDate.split("-").isNotEmpty ? int.parse(weddingDate.split("-")[0]) : 0;

    return (
      Container(
        alignment: Alignment.bottomLeft,
        child: CountDownText(
          due: DateTime(years, months, days),
          finishedText: "Mariage terminé",
          showLabel: true,
          daysTextShort: "j  ",
          hoursTextShort: "h  ",
          minutesTextShort: "m  ",
          secondsTextShort: "s ",
          style: const TextStyle(
            fontSize: 40,
            color: AppColors.pink500,
            fontWeight: FontWeight.bold
          ),
        ),
      )
    );
  }
}