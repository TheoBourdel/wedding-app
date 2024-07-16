import 'package:flutter/material.dart';
import 'side_menu_widget.dart';

class MainScaffold extends StatelessWidget {
  final Widget content;
  final String currentPage;
  final ValueChanged<String> onPageSelected;

  const MainScaffold({
    super.key,
    required this.content,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      drawer: !isDesktop
          ? SizedBox(
        width: 250,
        child: SideMenuWidget(
          currentPage: currentPage,
          onPageSelected: onPageSelected,
        ),
      )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 2,
                child: SideMenuWidget(
                  currentPage: currentPage,
                  onPageSelected: onPageSelected,
                ),
              ),
            Expanded(
              flex: 8,
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
