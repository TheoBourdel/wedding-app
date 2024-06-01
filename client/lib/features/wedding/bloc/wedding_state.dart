part of 'wedding_bloc.dart';

enum WeddingStatus { initial, loading, success, failure }

class WeddingState {
  final WeddingStatus status;
  final List<Wedding> wedding;
  final int? userId;
  final String? error;

  const WeddingState({
    this.status = WeddingStatus.initial,
    this.wedding = const [],
    this.userId,
    this.error,
  });

  WeddingState copyWith({
    WeddingStatus? status,
    List<Wedding>? wedding,
    int? userId,
    String? error,
  }) {
    return WeddingState(
      status: status ?? this.status,
      wedding: wedding ?? this.wedding,
      userId: userId ?? this.userId,
      error: error,
    );
  }
}