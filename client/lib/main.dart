import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/pages/signin_page.dart';
import 'package:client/features/message/bloc_message/message_bloc.dart';
import 'package:client/features/message/bloc_room/room_bloc.dart';
import 'package:client/repository/message_repository.dart';
import 'package:client/repository/room_repository.dart';
import 'package:client/shared/widget/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final String? token;
  const MyApp({required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    final Widget? page;

    if (token == null) {
      page = const SignInPage();
    } else {
      page = NavigationMenu(token: token);
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RoomRepository>(
          create: (context) => RoomRepository(),
        ),
        RepositoryProvider<MessageRepository>(
          create: (context) => MessageRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RoomBloc>(
            create: (context) => RoomBloc(context.read<RoomRepository>()),
          ),
          BlocProvider<MessageBloc>(
            create: (context) => MessageBloc(context.read<MessageRepository>()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weddy',
          theme: AppTheme.lightTheme,
          home: page,
        ),
      ),
    );
  }
}
