import 'package:client/model/user.dart';

enum OrganizerStatus { initial, loading, success, failure }

class OrganizerState {
  final OrganizerStatus status;
  final List<User> organizers;
  final String? error;

  const OrganizerState({
    this.status = OrganizerStatus.initial,
    this.organizers = const [],
    this.error,
  });

  OrganizerState copyWith({
    OrganizerStatus? status,
    List<User>? organizers,
    String? error,
  }) {
    return OrganizerState(
      status: status ?? this.status,
      organizers: organizers ?? this.organizers,
      error: error,
    );
  }
}