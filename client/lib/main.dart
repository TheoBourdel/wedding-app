import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/pages/signin_page.dart';
import 'package:client/features/wedding/pages/wedding_form.dart';
import 'package:client/features/wedding/pages/wedding_page.dart';
import 'package:client/provider/user_provider.dart';
import 'package:client/shared/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/shared/widget/navigation_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:client/features/message/bloc_message/message_bloc.dart';
import 'package:client/features/message/bloc_room/room_bloc.dart';
import 'package:client/repository/message_repository.dart';
import 'package:client/repository/room_repository.dart';
import 'package:client/shared/widget/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocaleProvider with ChangeNotifier {
  Locale _currentLocale = Locale('en');
  Locale get currentLocale => _currentLocale;
  void setLocale(String localeCode) {
    _currentLocale = Locale(localeCode ?? 'en');
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String localeCode = prefs.getString('locale_code') ?? 'en';
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider()..setLocale(localeCode),
      child: MyApp(token: prefs.getString('token')),
    ),
  );
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
      page = BottomNavigation(token: token);
      //page = NavigationMenu(token: token);
    }
    final localeProvider = Provider.of<LocaleProvider>(context);

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
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => UserProvider()
            ),
          ],
          child: MaterialApp(
            locale: localeProvider.currentLocale,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            title: 'Weddy',
            theme: AppTheme.lightTheme,
            home: page,
          )
        )
      ),
    );
  }
}
