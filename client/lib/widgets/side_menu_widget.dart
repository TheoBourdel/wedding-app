import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:client/data/side_menu_data.dart';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_event.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/widgets/signout_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  bool isPaymentEnabled = false;
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    _fetchPaymentStatus();
    _loadSwitchValue();
  }

  void _fetchPaymentStatus() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/payment-status'));
    if (response.statusCode == 200) {
      setState(() {
        isPaymentEnabled = jsonDecode(response.body)['is_payment_enabled'];
      });
    }
  }

  void _togglePaymentStatus(bool newValue) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/payment-status/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'is_payment_enabled': newValue}),
    );
    if (response.statusCode == 200) {
      setState(() {
        isPaymentEnabled = newValue;
      });
    }
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.menu.length,
                itemBuilder: (context, index) => buildMenuEntry(data, index),
              ),
            ),
            SwitchListTile(
              title: Text(
                'Enable Payment',
                style: TextStyle(color: Colors.white),
              ),
              value: isPaymentEnabled,
              onChanged: (bool value) {
                _togglePaymentStatus(value);
              },
            ),
          ],
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
