import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/pages/signin_page.dart';
import 'package:client/features/auth/pages/signup_page.dart';
import 'package:client/features/provider/pages/provider_info_page.dart';
import 'package:client/features/wedding/pages/wedding_info_page.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String role = decodedToken['role'];
    if (token == null) {
      page = const SignInPage();
    } else if (role == 'provider') {
      page = const ProviderInfoPage();
    } else if (role == 'marry') {
      page = const WeddingInfoPage();
    } else {
      page = const SignInPage();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weddy',
      theme: AppTheme.lightTheme,
      home: page
    );
  }
}
