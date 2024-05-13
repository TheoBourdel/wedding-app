import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/message/pages/message_list_page.dart';
import 'package:client/features/search/pages/search_page.dart';
import 'package:client/features/wedding/pages/wedding_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    const SearchPage(),
    const WeddingPage(),
    const MessageListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.search_normal_1),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.heart),
            label: "Wedding",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.message),
            label: "Message",
          ),
        ],
        selectedItemColor: AppColors.pink500,
      ),
    );
  }
}