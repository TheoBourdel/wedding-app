import 'package:client/model/user.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState {
  final ProfileStatus status;
  final User? user;
  final String? error;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.error,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    User? user,
    int? userId,
    String? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}