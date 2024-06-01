import 'package:bloc/bloc.dart';
import 'package:client/dto/signin_user_dto.dart';
import 'package:client/features/auth/bloc/auth_event.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/model/user.dart';
import 'package:client/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:equatable/equatable.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final SignInUserDto user = SignInUserDto(
          email: event.email,
          password: event.password,
        );
        final String token = await AuthRepository.signIn(user);

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);

          final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          final int userId = decodedToken['sub'];
          final String userRole = decodedToken['role'];
          print('User role: $userRole');

          emit(Authenticated(token, userId, userRole));
        } else {
          emit(const AuthError('Error while signing in'));
        }
      } catch (e) {
        emit(const AuthError('Error while signing in'));
      }
    });

    on<SignOutEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      print('SignOutEvent');
      emit(AuthUnauthenticated());
    });

    on<AppStartedEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token != null && !JwtDecoder.isExpired(token)) {
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        final int userId = decodedToken['sub'];
        final String userRole = decodedToken['role'];
        emit(Authenticated(token, userId, userRole));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
}