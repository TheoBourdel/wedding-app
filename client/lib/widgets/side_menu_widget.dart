import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/data/side_menu_data.dart';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:client/main.dart';


class SideMenuWidget extends StatefulWidget {
  final String currentPage;
  final ValueChanged<String> onPageSelected;

  const SideMenuWidget({super.key, required this.currentPage, required this.onPageSelected});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
  }

  void _loadSwitchValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = prefs.getString('flipping_value') == 'enabled';
    });
  }

  void _onMenuItemSelected(BuildContext context, String pageTitle, int index) {
    if (index == 5) {
      context.read<AuthBloc>().add(SignOutEvent());
    } else {
      widget.onPageSelected(pageTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: const Color(0xFF171821),
      child: ListView.builder(
        itemCount: data.menu.length + 1, // +1 pour le switch
        itemBuilder: (context, index) {
          if (index < data.menu.length) {
            return buildMenuEntry(data, index);
          } else if (index == data.menu.length) {
            return buildSwitch(context);
          }
        },
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

  Widget buildSwitch(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            child: Text(
              'Activer/Désactiver',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Switch(
            value: _isSwitched,
            onChanged: (value) async {

            },
            activeColor: Colors.pink,
          ),
        ],
      ),
    );
  }
}
