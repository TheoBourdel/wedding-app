import 'package:client/core/theme/theme.dart';
import 'package:client/features/api/firebase_api.dart';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_event.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/auth/pages/signin_page.dart';
import 'package:client/features/estimate/bloc/estimate_bloc.dart';
import 'package:client/features/estimate/bloc/estimate_event.dart';
import 'package:client/features/organizer/bloc/organizer_bloc.dart';
import 'package:client/features/profile/bloc/profile_bloc.dart';
import 'package:client/features/service/bloc/service_bloc.dart';
import 'package:client/features/wedding/bloc/wedding_bloc.dart';
import 'package:client/firebase_options.dart';
import 'package:client/repository/auth_repository.dart';
import 'package:client/repository/estimate_repository.dart';
import 'package:client/repository/organizer_repository.dart';
import 'package:client/repository/service_repository.dart';
import 'package:client/services/budget_service.dart';
import 'package:client/repository/user_repository.dart';
import 'package:client/shared/bottom_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:client/features/message/bloc_message/message_bloc.dart';
import 'package:client/features/message/bloc_room/room_bloc.dart';
import 'package:client/repository/message_repository.dart';
import 'package:client/repository/room_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/screens/main_screen.dart';
import 'dart:io' show Platform;
import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:client/features/budget/pages/budget.dart';
import 'package:client/features/budget/pages/category_budget_page.dart';



class LocaleProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  Locale get currentLocale => _currentLocale;
  void setLocale(String localeCode) {
    _currentLocale = Locale(localeCode);
    notifyListeners();
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  //Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;

  if (Platform.isAndroid) {
    print('Running on Android');
   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    String roomId = 'test_room_id';
    //FirebaseApi firebaseApi = FirebaseApi();
    //await firebaseApi.initNotifications(roomId);
    //await firebaseApi.initPushNotifications();
  }




  SharedPreferences prefs = await SharedPreferences.getInstance();
  String localeCode = prefs.getString('locale_code') ?? 'en';
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider()..setLocale(localeCode),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthRepository authRepository = AuthRepository();
  final UserRepository userRepository = UserRepository();
  final RoomRepository roomRepository = RoomRepository();
  final MessageRepository messageRepository = MessageRepository();
  final EstimateRepository estimateRepository = EstimateRepository();
  final ServiceRepository serviceRepository = ServiceRepository();
  final OrganizerRepository organizerRepository = OrganizerRepository();

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return BlocProvider(
      // Laisser le AuthProvider au dessus des autres providers
      create: (context) => AuthBloc(authRepository)..add(const AppStartedEvent()),

      // Voir pour supprimer le MultiRepositoryProvider
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<RoomRepository>(
            create: (context) => roomRepository,
          ),
          RepositoryProvider<MessageRepository>(
            create: (context) => messageRepository,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                final authState = context.read<AuthBloc>().state;
                final userId = authState is Authenticated ? authState.userId : null;

                return WeddingBloc()..add(WeddingDataLoaded(userId: userId!));
              },
            ),
            BlocProvider(
              create: (context) => RoomBloc(context.read<RoomRepository>()),
            ),
            BlocProvider(
              create: (context) => MessageBloc(context.read<MessageRepository>()),
            ),
            BlocProvider(
              create: (context) {
                final authState = context.read<AuthBloc>().state;
                final userId = authState is Authenticated ? authState.userId : null;
              
                return EstimateBloc(estimateRepository)..add(EstimatesLoadedEvent(userId: userId!));
              }
            ),
            BlocProvider(
              create: (context) => ServiceBloc(serviceRepository)
            ),
            BlocProvider(
              create: (context) => OrganizerBloc(organizerRepository)
            ),
            BlocProvider(
              create: (context) => ProfileBloc(userRepository)
            )
            // Mettez ici les autres blocs providers
          ],
          child: MaterialApp(
            locale: localeProvider.currentLocale,
            debugShowCheckedModeBanner: false,
            title: 'Weddy',
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routes: {
              '/': (context) => const AuthScreen(),
              '/dashboard': (context) => const MainScreen(),
              '/home': (context) => const BottomNavigation(),
            },
          ),
        ),
      )
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {

        if (state is AuthInitial || state is AuthUnauthenticated) {

          return const SignInPage();
        }

        if (state is AuthLoading) {
          return const SafeArea(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (state is Authenticated) {
          if (UniversalPlatform.isWeb ) {
            if(state.userRole == 'admin'){
              Future.microtask(() => Navigator.pushReplacementNamed(context, '/dashboard'));
            } else {
              //context.read<AuthBloc>().add(const SignOutEvent());
              return const SignInPage(
                errorMessage: 'Access denied: You must be an admin to use this application on the web.',
              );
              /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );*/
            }
          } else {
            Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
          }
          return const SizedBox();
        }

        if (state is AuthError) {
          return const SafeArea(
            child: Scaffold(
              body: Text('Error'),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}