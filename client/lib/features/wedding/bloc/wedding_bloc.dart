import 'package:client/dto/wedding_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/model/wedding.dart';
import 'package:client/repository/wedding_repository.dart';

part 'wedding_event.dart';
part 'wedding_state.dart';

class WeddingBloc extends Bloc<WeddingEvent, WeddingState> {
  WeddingBloc() : super(const WeddingState()) {

    on<WeddingDataLoaded>((event, emit) async {
      emit(state.copyWith(status: WeddingStatus.loading));
      try {
        final List<Wedding> wedding = await WeddingRepository.getUserWedding(event.userId);
        emit(state.copyWith(status: WeddingStatus.success, wedding: wedding));
      } catch (error) {
        emit(state.copyWith(status: WeddingStatus.failure, error: "Error while loading wedding"));
      }
    });

    on<WeddingCreated>((event, emit) async {
      try {
        final Wedding wedding = await WeddingRepository.createWedding(event.weddingDto, event.userId);
        emit(state.copyWith(status: WeddingStatus.success, wedding: [wedding]));
      } catch (error) {
        emit(state.copyWith(status: WeddingStatus.failure, error: "Error while creating wedding"));
      }
    });

    on<WeddingUpdated>((event, emit) async {
      emit(state.copyWith(status: WeddingStatus.loading));
      try {
        print('bloc');
        print(event.wedding);
        final Wedding wedding = await WeddingRepository.updateWedding(event.wedding);
        emit(state.copyWith(status: WeddingStatus.success, wedding: [wedding]));
      } catch (error) {
        print('bloc error');
        print(error);
        emit(state.copyWith(status: WeddingStatus.failure, error: "Error while updating wedding"));
      }
    });

  }
}
