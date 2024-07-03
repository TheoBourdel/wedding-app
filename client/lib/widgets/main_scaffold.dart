import 'package:flutter/material.dart';
import 'side_menu_widget.dart';

class MainScaffold extends StatelessWidget {
  final Widget content;

  const MainScaffold({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;

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
              const Expanded(
                flex: 2,
                child: SizedBox(
                  child: SideMenuWidget(),
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
