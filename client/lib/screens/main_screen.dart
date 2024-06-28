import 'package:client/util/responsive.dart';
import 'package:client/widgets/dashboard_widget.dart';
import 'package:client/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      drawer: !isDesktop
          ? const SizedBox(
        width: 250,
        child: SideMenuWidget(),
      )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: SideMenuWidget(),
                ),
              ),
            Expanded(
              flex: 8,
              child: DashboardWidget(),
            ),
          ],
        ),
      ),
    );
  }
}