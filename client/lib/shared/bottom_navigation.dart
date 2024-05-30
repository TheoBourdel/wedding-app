import 'package:client/features/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:iconsax/iconsax.dart';
import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/message/pages/message_list_page.dart';
import 'package:client/features/wedding/pages/wedding_page.dart';
import 'package:client/repository/user_repository.dart';
import 'package:client/features/service/services_page.dart';

class BottomNavigation extends StatefulWidget {
  final String? token;
  const BottomNavigation({super.key, required this.token});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final UserRepository userRepository = UserRepository();
  int _currentIndex = 0;
  String role = '';

  void getUserRole() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token!);
    role = decodedToken['role'];
  }

  @override
  void initState() {
    getUserRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> destinations = [];
    List<Widget> screens = [];


    if (role == 'marry') {
      screens.add(ProviderServicesScreen());
      destinations.add(const BottomNavigationBarItem(
        icon: Icon(Iconsax.search_normal_1),
        label: "Search",
      ));
    }

    if (role == 'provider') {
      destinations.add(const BottomNavigationBarItem(
        icon: Icon(Iconsax.briefcase),
        label: "Prestations",
      ));
      screens.add(ProviderServicesScreen());

    } else if (role == 'marry') {
      destinations.add(const BottomNavigationBarItem(
        icon: Icon(Iconsax.profile_2user),
        label: "Mariage",
      ));
      screens.add(const WeddingPage());
    }
    destinations.add(const BottomNavigationBarItem(
      icon: Icon(Iconsax.message),
      label: "Messages",
    ));
    screens.add(const MessageListPage());

    destinations.add(const BottomNavigationBarItem(
      icon: Icon(Iconsax.setting),
      label: "Settings",
    ));
    screens.add(const ProfilePage());


    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: destinations,
        selectedItemColor: AppColors.pink500,
        unselectedItemColor: Colors.grey[400],
      ),
    );
  }
}
