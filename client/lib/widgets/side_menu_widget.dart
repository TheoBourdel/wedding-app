import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/data/side_menu_data.dart';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_event.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/widgets/signout_page.dart';

class SideMenuWidget extends StatefulWidget {
  final String currentPage;
  final ValueChanged<String> onPageSelected;

  const SideMenuWidget({super.key, required this.currentPage, required this.onPageSelected});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  void _onMenuItemSelected(BuildContext context, String pageTitle, int index) {
    if (index == 4) { // Assuming index 4 is for SignOut
      context.read<AuthBloc>().add(SignOutEvent());
    } else {
      widget.onPageSelected(pageTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SignOutPage()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        color: const Color(0xFF171821),
        child: ListView.builder(
          itemCount: data.menu.length,
          itemBuilder: (context, index) => buildMenuEntry(data, index),
        ),
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = widget.currentPage == data.menu[index].title;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
        color: isSelected ? Colors.pink : Colors.transparent,
      ),
      child: InkWell(
        onTap: () => _onMenuItemSelected(context, data.menu[index].title, index),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              child: Icon(
                data.menu[index].icon,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
            Text(
              data.menu[index].title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
