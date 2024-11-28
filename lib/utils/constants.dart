import 'package:pp751/utils/assets_paths.dart';

abstract class AppConstants {
  static const isFirstRun = "isFirstRun";
  static const duration200 = Duration(milliseconds: 200);
  static const sorts = [
    (AppIcons.sortingAZ, 'From A to Z'),
    (AppIcons.sortingZA, 'From Z to A'),
    (AppIcons.sorting2, 'First planted earlier'),
    (AppIcons.sorting1, 'First planted later'),
  ];
}
