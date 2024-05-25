import 'package:client/dto/wedding_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/model/wedding.dart';
import 'package:client/repository/wedding_repository.dart';

part 'wedding_event.dart';
part 'wedding_state.dart';

class WeddingBloc extends Bloc<WeddingEvent, WeddingState> {
  WeddingBloc() : super(WeddingInitial()) {

    on<WeddingDataLoaded>((event, emit) async {
      emit(WeddingLoading());
      try {
        final List<Wedding> wedding = await WeddingRepository.getUserWedding(event.userId);
        emit(WeddingDataLoadedSuccess(wedding: wedding));
      } catch (error) {
        emit(WeddingDataLoadedFailure(error: "Error while loading wedding data"));
      }
    });

    on<WeddingCreated>((event, emit) async {
      try {
        final Wedding wedding = await WeddingRepository.createWedding(event.weddingDto, event.userId);
        emit(WeddingDataLoadedSuccess(wedding: [wedding]));
      } catch (error) {
        emit(WeddingDataLoadedFailure(error: "Error while creating wedding"));
      }
    });

    on<WeddingUpdated>((event, emit) async {
      try {
        final Wedding wedding = await WeddingRepository.updateWedding(event.weddingDto);
        emit(WeddingDataLoadedSuccess(wedding: [wedding]));        
      } catch (error) {
        emit(WeddingDataLoadedFailure(error: "Error while updating wedding"));
      }
    });

  }
}
