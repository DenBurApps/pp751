import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp751/bloc/plant_state.dart';

class PlantBloc extends Cubit<PlantState> {
  PlantBloc(PlantState? state) : super(state ?? const PlantState());

  void updateName(String value) {
    emit(state.copyWith(name: value.trim()));
  }

  void updateDescription(String value) {
    emit(state.copyWith(description: value.trim()));
  }

  void updateDate(DateTime value) {
    emit(state.copyWith(date: value));
  }

  void updatePhotos(PhotoState value) {
    late final List<PhotoState> photosCopy;
    if (state.photos.contains(value)) {
      photosCopy = state.photos.toList();
      photosCopy.remove(value);
    } else {
      photosCopy = state.photos.toList();
      photosCopy.add(value);
    }
    emit(state.copyWith(photos: photosCopy));
  }

  void updateFertilizer(DateTime value) {
    final fertilizerCopy = state.fertilizer.toList();
    if (state.fertilizer.contains(value)) {
      fertilizerCopy.remove(value);
    } else {
      fertilizerCopy.add(value);
    }
    emit(state.copyWith(fertilizer: fertilizerCopy));
  }

  void updateReplanting(DateTime value) {
    final replantingCopy = state.replanting.toList();
    if (state.replanting.contains(value)) {
      replantingCopy.remove(value);
    } else {
      replantingCopy.add(value);
    }
    emit(state.copyWith(replanting: replantingCopy));
  }

  void updateWatering(DateTime value) {
    final wateringCopy = state.watering.toList();
    if (state.watering.contains(value)) {
      wateringCopy.remove(value);
    } else {
      wateringCopy.add(value);
    }
    emit(state.copyWith(watering: wateringCopy));
  }

  void addPhoto(String value) {
    emit(
      state.copyWith(
        photos: [
          ...state.photos,
          PhotoState(date: DateUtils.dateOnly(DateTime.now()), path: value),
        ],
      ),
    );
  }

  void deletePhoto() {
    emit(state.copyWith(photos: []));
  }

  bool get canSave =>
      state.name.isNotEmpty &&
      state.description.isNotEmpty &&
      state.date != null &&
      state.photos.isNotEmpty;
}
