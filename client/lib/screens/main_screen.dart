import 'package:client/features/logs/pages/logspage.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/dashboard_widget.dart';
import 'package:client/widgets/side_menu_widget.dart';
import 'package:client/widgets/user_list_page.dart';
import 'package:client/widgets/categorie_page.dart';
import 'package:client/widgets/history_page.dart';
import 'package:client/widgets/main_scaffold.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String currentPage = 'Dashboard';

  void _updatePage(String page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (currentPage) {
      case 'Dashboard':
        content = const DashboardWidget();
        break;
      case 'Categorie':
        content = const CategoryPage();
        break;
      case 'Utilisateurs':
        content = const UserListPage();
        break;
      case 'Historique':
        content = HistoryPage(year:  DateTime.now().year);
        break;
      case 'Logs':
        content = LogsPage();
        break;
      case 'SignOut':
        content = const Center(child: Text('SignOut Page'));
        break;
      default:
        content = const DashboardWidget();
    }

    return MainScaffold(
      currentPage: currentPage,
      content: content,
      onPageSelected: _updatePage,
    );
  }
}
