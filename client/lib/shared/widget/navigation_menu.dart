import 'package:client/features/service/provider_services_page.dart';
import 'package:client/features/message/pages/message_list_page.dart';
import 'package:client/features/provider/pages/provider_info_page.dart';
import 'package:client/features/search/pages/search_page.dart';
import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/service/provider_services_page.dart';
import 'package:client/features/service/pages/service_info_page.dart';
import 'package:client/features/wedding/pages/wedding_info_page.dart';
import 'package:client/features/wedding/pages/wedding_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class NavigationMenu extends StatefulWidget {
  final token;
  const NavigationMenu({required this.token, super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenu();
}

class _NavigationMenu extends State<NavigationMenu> {
  late String role;
  late PageController _pageController;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);

    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
    role = decodedToken['role'];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> destinations = [];
    List<Widget> _screens = [];

    _screens.add(const SearchPage());
    destinations.add(const BottomNavigationBarItem(
      icon: Icon(Iconsax.search_normal_1),
      label: "Search",
    ));
    if (role == 'provider') {
      /*destinations.add(const BottomNavigationBarItem(
        icon: Icon(Iconsax.profile),
        label: "Profile",
      ));
        _screens.add(const ProviderInfoPage());*/

      // Assurez-vous que cet onglet est ajouté seulement pour le role 'provider'
      destinations.add(const BottomNavigationBarItem(
        icon: Icon(Iconsax.briefcase), // Changez l'icône si nécessaire
        label: "Services",
      ));
      _screens.add(ProviderServicesScreen());

    } else if (role == 'marry') {
      destinations.add(const BottomNavigationBarItem(
        icon: Icon(Iconsax.profile_2user),
        label: "Profile",
      ));
      _screens.add(const WeddingPage());
    }
    destinations.add(const BottomNavigationBarItem(
      icon: Icon(Iconsax.message),
      label: "Messages",
    ));
    _screens.add(const MessageListPage());

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.pink500,
        items: destinations,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        currentIndex: _selectedIndex,
        elevation: 1,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => {
          setState(() {
            _selectedIndex = index;
          })
        },
        children: _screens,
      ),
    );
  }
}