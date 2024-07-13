import 'package:client/features/profile/bloc/profile_event.dart';
import 'package:client/features/profile/bloc/profile_state.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:client/model/user.dart';
import 'package:client/repository/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc(this.userRepository) : super(const ProfileState()) {
    on<ProfileUserLoaded>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loading));

      try {
        final User user = await userRepository.getUser(event.userId);
        emit(state.copyWith(status: ProfileStatus.success, user: user));
      } catch (e) {
        emit(state.copyWith(status: ProfileStatus.failure, error: "Error while loading user"));
      }
    });

    on<ProfileUserUpdated>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loading));
      try {
        await userRepository.updateUser(event.user);
        final updatedUser = event.user;
        emit(state.copyWith(status: ProfileStatus.success, user: updatedUser));

      } catch (e) {
        emit(state.copyWith(status: ProfileStatus.failure, error: "Error while updating user"));
      }
    });
  }
}