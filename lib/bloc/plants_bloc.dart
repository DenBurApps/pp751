import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp751/bloc/plant_state.dart';
import 'package:pp751/bloc/plants_state.dart';
import 'package:pp751/storages/isar.dart';

class PlantsBloc extends Cubit<PlantsState> {
  PlantsBloc() : super(const PlantsState());

  Future<void> getPlants() async {
    final plants = await AppIsarDatabase.getPlants();

    final ps = plants.map((e) => PlantState.fromIsarModel(e)).toList();
    ps.sort(
      (a, b) => switch (state.sort) {
        0 => a.name.compareTo(b.name),
        1 => b.name.compareTo(a.name),
        2 => a.date!.compareTo(b.date!),
        _ => b.date!.compareTo(a.date!),
      },
    );
    emit(
      state.copyWith(
        plants: plants.map((e) => PlantState.fromIsarModel(e)).toList(),
      ),
    );
  }

  Future<void> addPlant(PlantState plant) async {
    await AppIsarDatabase.addPlant(plant.toIsarModel());
    await getPlants();
  }

  Future<void> deletePlant(int id) async {
    await AppIsarDatabase.deletePlant(id);
    await getPlants();
  }

  Future<void> updatePlant(int id, PlantState plant) async {
    await AppIsarDatabase.updatePlant(id, plant.toIsarModel());
    await getPlants();
  }

  Future<void> updateSearch(String value) async {
    emit(state.copyWith(search: value));
    await getPlants();
  }

  Future<void> updateSort(int value) async {
    emit(state.copyWith(sort: value));
    await getPlants();
  }
}
