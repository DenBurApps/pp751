import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pp751/storages/models/plant.dart';

abstract class AppIsarDatabase {
  static late final Isar _instance;

  static Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();
    return _instance = await Isar.open(
      [PlantSchema],
      directory: dir.path,
    );
  }

  static Future<List<Plant>> getPlants() async {
    return await _instance
        .writeTxn(() async => await _instance.plants.where().findAll());
  }

  static Future<void> addPlant(Plant plant) async {
    await _instance
        .writeTxn(() async => await _instance.plants.put(plant));
  }

  static Future<void> deletePlant(int id) async {
    await _instance
        .writeTxn(() async => await _instance.plants.delete(id));
  }

  static Future<void> updatePlant(int id, Plant newPlant) async {
    await _instance.writeTxn(() async {
      final plant = await _instance.plants.get(id);
      if (plant != null) {
        plant
          ..name = newPlant.name
          ..description = newPlant.description
          ..date = newPlant.date
          ..photos = newPlant.photos
          ..fertilizer = newPlant.fertilizer
          ..replanting = newPlant.replanting
          ..watering = newPlant.watering;
        return await _instance.plants.put(plant);
      }
    });
  }
}
