import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/estimate/pages/estimate_page.dart';
import 'package:client/features/message/pages/message_list_page.dart';
import 'package:client/features/profile/pages/profile_page.dart';
import 'package:client/features/service/pages/my_services_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/wedding/pages/wedding_page.dart';
import 'package:client/repository/user_repository.dart';
import 'package:client/features/service/pages/services_page.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final UserRepository userRepository = UserRepository();
  int _currentIndex = 0;
  String? role = '';

  void getUserRole() {
    final authState = context.read<AuthBloc>().state;
    role = authState is Authenticated ? authState.userRole : null;

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

    if (role == 'marry' || role == 'organizer' || role == 'provider') {
      screens.add(ServicesScreen());
      destinations.add(const BottomNavigationBarItem(
        icon: Icon(Iconsax.search_normal_1),
        label: "Rechercher",
      ));
    }

    if(role != 'organizer') {
      screens.add(const EstimatePage());
      destinations.add(const BottomNavigationBarItem(
        icon: Icon(Iconsax.document),
        label: "Devis",
      ));
    }

    if (role == 'provider') {
      destinations.add(const BottomNavigationBarItem(
        icon: Icon(Iconsax.briefcase),
        label: "Prestations",
      ));
      screens.add(const MyServicesPage());

    } else if (role == 'marry' || role == 'organizer') {
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
