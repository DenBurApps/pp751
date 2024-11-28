import 'package:isar/isar.dart';

part 'plant.g.dart';

@collection
class Plant {
  Id id = Isar.autoIncrement;

  String? name;
  String? description;
  DateTime? date;
  List<Photo>? photos;
  List<DateTime>? fertilizer;
  List<DateTime>? replanting;
  List<DateTime>? watering;
}

@embedded
class Photo {
  String? path;
  DateTime? date;
}
