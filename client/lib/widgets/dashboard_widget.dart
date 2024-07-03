import 'package:client/widgets/activity_details_card.dart';
import 'package:client/widgets/header_widget.dart';
import 'package:client/widgets/line_chart_card.dart';
import 'package:flutter/material.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            SizedBox(height: 18),
            HeaderWidget(),
            SizedBox(height: 18),
            ActivityDetailsCard(),
            SizedBox(height: 18),
            RevenueTable(),
            SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}