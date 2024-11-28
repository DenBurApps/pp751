import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pp751/bloc/plant_state.dart';
import 'package:pp751/bloc/plants_bloc.dart';
import 'package:pp751/navigation/routes.dart';
import 'package:pp751/pages/calendar_page.dart';
import 'package:pp751/pages/edit_plant_page.dart';
import 'package:pp751/pages/home_page.dart';
import 'package:pp751/pages/onboarding_page.dart';
import 'package:pp751/pages/plant_page.dart';
import 'package:pp751/pages/privacy_page.dart';
import 'package:pp751/pages/settings_page.dart';
import 'package:pp751/pages/splash_page.dart';
import 'package:pp751/remote_config.dart';
import 'package:pp751/storages/isar.dart';
import 'package:pp751/storages/shared_preferences.dart';
import 'package:pp751/ui_kit/colors.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await RemoteConfigService.init();
  await AppSharedPreferences.init();
  await AppIsarDatabase.init();

  final isFirstRun = AppSharedPreferences.getIsFirstRun() ?? true;
  if (isFirstRun) await AppSharedPreferences.setNotFirstRun();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    AppInfo(
      data: await AppInfoData.get(),
      child: MyApp(isFirstRun: isFirstRun),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isFirstRun});

  final bool isFirstRun;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantsBloc(),
      child: _AppWidget(isFirstRun: isFirstRun),
    );
  }
}

class _AppWidget extends StatelessWidget {
  const _AppWidget({required this.isFirstRun});

  final bool isFirstRun;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<PlantsBloc>().getPlants(),
      builder: (context, snapshot) => MaterialApp(
        title: '',
        themeMode: ThemeMode.light,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          brightness: Brightness.light,
        ),
        onUnknownRoute: (settings) => CupertinoPageRoute(
          builder: (context) => const HomePage(),
        ),
        onGenerateRoute: (settings) => switch (settings.name) {
          AppRoutes.onBoarding => CupertinoPageRoute(
              settings: settings,
              builder: (context) => const OnBoardingPage(),
            ),
          AppRoutes.editPlant => CupertinoPageRoute(
              settings: settings,
              builder: (context) =>
                  EditPlantPage(plant: settings.arguments as PlantState?),
            ),
          AppRoutes.home => CupertinoPageRoute(
              settings: settings,
              builder: (context) => const HomePage(),
            ),
          AppRoutes.plant => CupertinoPageRoute(
              settings: settings,
              builder: (context) =>
                  PlantPage(plant: settings.arguments! as PlantState),
            ),
          AppRoutes.privacy => CupertinoPageRoute(
              settings: settings,
              builder: (context) => const PrivacyPage(),
            ),
          AppRoutes.settings => CupertinoPageRoute(
              settings: settings,
              builder: (context) => const SettingsPage(),
            ),
          AppRoutes.calendar => CupertinoPageRoute(
              settings: settings,
              builder: (context) => const CalendarPage(),
            ),
          _ => null,
        },
        home: SplashPage(isFirstRun: isFirstRun),
      ),
    );
  }
}
