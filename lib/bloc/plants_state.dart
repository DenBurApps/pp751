import 'package:equatable/equatable.dart';
import 'package:pp751/bloc/plant_state.dart';

class PlantsState extends Equatable {
  const PlantsState({this.plants = const [], this.search = '', this.sort = 0});

  final List<PlantState> plants;
  final String search;
  final int sort;

  @override
  List<Object?> get props => [plants, search, sort];

  PlantsState copyWith({
    List<PlantState>? plants,
    String? search,
    int? sort,
  }) {
    return PlantsState(
      plants: plants ?? this.plants,
      search: search ?? this.search,
      sort: sort ?? this.sort,
    );
  }
}
