import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pp751/bloc/plant_state.dart';
import 'package:pp751/bloc/plants_bloc.dart';
import 'package:pp751/bloc/plants_state.dart';
import 'package:pp751/navigation/routes.dart';
import 'package:pp751/ui_kit/colors.dart';
import 'package:pp751/ui_kit/text_styles.dart';
import 'package:pp751/utils/assets_paths.dart';
import 'package:pp751/utils/constants.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime selected;
  late DateTime start;
  late int offset;

  @override
  void initState() {
    super.initState();
    selected = DateUtils.dateOnly(DateTime.now());
    start = selected.copyWith(day: 1);
    offset = start.weekday - 1;
  }

  void selectDate(DateTime value) {
    setState(() {
      selected = value;
      start = selected.copyWith(day: 1);
      offset = start.weekday - 1;
    });
  }

  void decrementMonth() {
    setState(() {
      final previousMonthDays =
          DateUtils.getDaysInMonth(selected.year, selected.month - 1);
      if (selected.day > previousMonthDays) {
        selected = selected.copyWith(
          month: selected.month - 1,
          day: previousMonthDays,
        );
      } else {
        selected = selected.copyWith(month: selected.month - 1);
      }
      start = selected.copyWith(day: 1);
      offset = start.weekday - 1;
    });
  }

  void incrementMonth() {
    setState(() {
      final nextMonthDays =
          DateUtils.getDaysInMonth(selected.year, selected.month + 1);
      if (selected.day > nextMonthDays) {
        selected = selected.copyWith(
          month: selected.month + 1,
          day: nextMonthDays,
        );
      } else {
        selected = selected.copyWith(month: selected.month + 1);
      }
      start = selected.copyWith(day: 1);
      offset = start.weekday - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        title: GestureDetector(
          onTap: Navigator.of(context).pop,
          child: SvgPicture.asset(AppIcons.back),
        ),
        titleSpacing: 20,
      ),
      body: BlocSelector<PlantsBloc, PlantsState, List<PlantState>>(
        selector: (state) => state.plants,
        builder: (context, state) {
          final works = state
              .expand(
                (e) => [...e.fertilizer, ...e.replanting, ...e.watering],
              )
              .toList();
          final plants = state
              .where(
                (e) =>
                    e.fertilizer.contains(selected) ||
                    e.replanting.contains(selected) ||
                    e.watering.contains(selected),
              )
              .toList();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: AppColors.surface.withOpacity(.5)),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: decrementMonth,
                          child: SvgPicture.asset(AppIcons.arrow),
                        ),
                        Text(
                          DateFormat('MMMM').format(selected),
                          style: AppStyles.bodyLarge,
                        ),
                        GestureDetector(
                          onTap: incrementMonth,
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: SvgPicture.asset(AppIcons.arrow),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: List.generate(
                      13,
                      (index) => index.isEven
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  DateFormat('EEE').format(
                                    DateTime(2024, 11, 25 + index ~/ 2),
                                  ),
                                  style: AppStyles.displaySmall
                                      .apply(color: AppColors.primary),
                                ),
                              ),
                            )
                          : const SizedBox(width: 7),
                    ),
                  ),
                  BlocSelector<PlantsBloc, PlantsState, List<PlantState>>(
                    selector: (state) => state.plants,
                    builder: (context, plants) {
                      return Column(
                        children: List.generate(
                          ((DateUtils.getDaysInMonth(
                                        selected.year,
                                        selected.month,
                                      ) +
                                      offset) /
                                  7)
                              .ceil(),
                          (row) => Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: List.generate(13, (index) {
                                if (index.isOdd) {
                                  return const SizedBox(width: 7);
                                }
                                final d = start.add(
                                  Duration(days: row * 7 - offset + index ~/ 2),
                                );
                                final thisMonth = d.month == selected.month;
                                final isSelected = selected == d;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => selectDate(d),
                                    behavior: HitTestBehavior.translucent,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          AnimatedContainer(
                                            duration: AppConstants.duration200,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : null,
                                            ),
                                            width: 22,
                                            height: 22,
                                            child: Center(
                                              child: Text(
                                                d.day.toString(),
                                                style:
                                                    AppStyles.bodyLarge.apply(
                                                  color: isSelected
                                                      ? AppColors.background
                                                      : thisMonth
                                                          ? null
                                                          : AppColors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          if (works.contains(d))
                                            const CircleAvatar(
                                              radius: 6,
                                              backgroundColor:
                                                  AppColors.primary,
                                            )
                                          else
                                            const SizedBox(height: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Works on this day',
                    style: AppStyles.displayLarge,
                  ),
                  const SizedBox(height: 5),
                  BlocSelector<PlantsBloc, PlantsState, List<PlantState>>(
                    selector: (state) => state.plants,
                    builder: (context, state) {
                      return plants.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  Image.asset(AppImages.emptyWorks, width: 137),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'There was no plant work\non this day',
                                    style: AppStyles.displayMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: List.generate(
                                plants.length,
                                (index) => _PlantTile(plants[index]),
                              ),
                            );
                    },
                  ),
                  SizedBox(
                    height: 20 + MediaQuery.of(context).viewPadding.bottom,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PlantTile extends StatelessWidget {
  const _PlantTile(this.plant);

  final PlantState plant;

  @override
  Widget build(BuildContext context) {
    final fertilizer = plant.fertilizer.lastOrNull;
    final replanting = plant.replanting.lastOrNull;
    final watering = plant.watering.lastOrNull;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.plant, arguments: plant),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.surface.withOpacity(.5)),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(plant.photos.first.path),
                  width: 138,
                  height: 138,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      plant.name,
                      style: AppStyles.displaySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (fertilizer != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.secondary,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.background,
                                ),
                                child: Image.asset(
                                  AppImages.fertilizer,
                                  width: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Fertilizer',
                                style: AppStyles.bodyMedium
                                    .apply(color: AppColors.background),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (replanting != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.surface,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.background,
                                ),
                                child: Image.asset(
                                  AppImages.replanting,
                                  width: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Replanting',
                                style: AppStyles.bodyMedium
                                    .apply(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (watering != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.blue,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.background,
                                ),
                                child: Image.asset(
                                  AppImages.watering,
                                  width: 20,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Watering',
                                style: AppStyles.bodyMedium
                                    .apply(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
