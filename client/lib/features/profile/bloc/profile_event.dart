import 'package:client/model/user.dart';

sealed class ProfileEvent {}

final class ProfileUserLoaded extends ProfileEvent {
  final int userId;

  ProfileUserLoaded({required this.userId});
}

final class ProfileUserUpdated extends ProfileEvent {
  final User user;

  ProfileUserUpdated({required this.user});
}