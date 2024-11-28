import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pp751/storages/models/plant.dart';

class PlantState extends Equatable {
  const PlantState({
    this.id,
    this.name = '',
    this.description = '',
    this.date,
    this.photos = const [],
    this.fertilizer = const [],
    this.replanting = const [],
    this.watering = const [],
  });

  factory PlantState.fromIsarModel(Plant plant) {
    return PlantState(
      id: plant.id,
      name: plant.name ?? '',
      description: plant.description ?? '',
      date: plant.date,
      photos: plant.photos?.map((e) => PhotoState.fromIsarModel(e)).toList() ??
          const [],
      fertilizer: plant.fertilizer ?? const [],
      replanting: plant.replanting ?? const [],
      watering: plant.watering ?? const [],
    );
  }

  final int? id;
  final String name;
  final String description;
  final DateTime? date;
  final List<PhotoState> photos;
  final List<DateTime> fertilizer;
  final List<DateTime> replanting;
  final List<DateTime> watering;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        date,
        photos,
        fertilizer,
        replanting,
        watering,
      ];

  PlantState copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? date,
    List<PhotoState>? photos,
    List<DateTime>? fertilizer,
    List<DateTime>? replanting,
    List<DateTime>? watering,
  }) {
    return PlantState(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      photos: photos ?? this.photos,
      fertilizer: fertilizer ?? this.fertilizer,
      replanting: replanting ?? this.replanting,
      watering: watering ?? this.watering,
    );
  }

  Plant toIsarModel() {
    return Plant()
      ..name = name
      ..description = description
      ..date = date
      ..photos = photos.map((e) => e.toIsarModel()).toList()
      ..fertilizer = fertilizer
      ..replanting = replanting
      ..watering = watering;
  }
}

class PhotoState extends Equatable {
  const PhotoState({this.path = '', required this.date});

  factory PhotoState.fromIsarModel(Photo photo) {
    return PhotoState(
      path: photo.path ?? '',
      date: photo.date ?? DateUtils.dateOnly(DateTime.now()),
    );
  }

  final String path;
  final DateTime date;

  @override
  List<Object?> get props => [path, date];

  Photo toIsarModel() {
    return Photo()
      ..path = path
      ..date = date;
  }
}
