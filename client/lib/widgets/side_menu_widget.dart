import 'package:client/data/side_menu_data.dart';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_event.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/widgets/user_list_page.dart';
import 'package:client/widgets/categorie_page.dart';
import 'package:client/widgets/dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'main_scaffold.dart';
import 'package:client/widgets/signout_page.dart';
import 'package:flutter/material.dart';


class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 0;

  void _onMenuItemSelected(BuildContext context, int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 4) {
      context.read<AuthBloc>().add(SignOutEvent());
    } else {
      Widget page;
      switch (index) {
        case 0:
          page = DashboardWidget();
          break;
        case 1:
          page = CategoryPage();
          break;
        case 2:
          page = UserListPage();
          break;

          break;
        default:
          page = DashboardWidget();
          break;
      }


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScaffold(content: page),
        ),
      );
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
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
        color: isSelected ? Colors.pink : Colors.transparent,
      ),
      child: InkWell(
        onTap: () => _onMenuItemSelected(context, index),
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
