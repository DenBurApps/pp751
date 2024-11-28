import 'package:pp751/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSharedPreferences {
  static late final SharedPreferences _instance;

  static Future<SharedPreferences> init() async =>
      _instance = await SharedPreferences.getInstance();

  static bool? getIsFirstRun() => _instance.getBool(AppConstants.isFirstRun);

  static Future<bool> setNotFirstRun() async =>
      await _instance.setBool(AppConstants.isFirstRun, false);
}
