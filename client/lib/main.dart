import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/shared/widget/navigation_menu.dart';

void main() async {
  // Ensure Flutter App is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Get token from shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  // Run the app
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {

  final token;
  const MyApp({required this.token, super.key});

  @override
  
  Widget build(BuildContext context) {
    final Widget? page;
    
    if (token == null) {
      page = const SignInPage();
    } else {
      page = NavigationMenu(token: token);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weddy',
      theme: AppTheme.lightTheme,
      home: page,
    );
  }
}
