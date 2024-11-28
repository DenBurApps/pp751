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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20 +
                      MediaQuery.of(context).viewInsets.top +
                      MediaQuery.of(context).viewPadding.top,
                ),
                Row(
                  children: [
                    const Text('Your plants', style: AppStyles.displayLarge),
                    const Spacer(),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.settings),
                      child: SvgPicture.asset(AppIcons.settings),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const _Calendar(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: BlocSelector<PlantsBloc, PlantsState, String>(
                        selector: (state) => state.search,
                        builder: (context, search) => TextFormField(
                          initialValue: search,
                          style: AppStyles.bodyMedium
                              .apply(color: AppColors.black),
                          cursorHeight: 20,
                          cursorWidth: 1,
                          onChanged: context.read<PlantsBloc>().updateSearch,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            hintStyle: AppStyles.bodyMedium
                                .apply(color: AppColors.grey),
                            hintText: 'Search',
                            filled: true,
                            isDense: true,
                            fillColor: AppColors.background,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: AppColors.surface.withOpacity(.5),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: AppColors.surface.withOpacity(.5),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: AppColors.surface.withOpacity(.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        backgroundColor: AppColors.background,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => const _SortSheet(),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface.withOpacity(.5),
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset(AppIcons.filter),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                BlocBuilder<PlantsBloc, PlantsState>(
                  builder: (context, state) {
                    final plants = state.plants
                        .where((e) => e.name.contains(state.search))
                        .toList();
                    return plants.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.surface.withOpacity(.5),
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            AppColors.surface.withOpacity(.5),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(19),
                                      child: Image.asset(
                                        AppImages.empty,
                                        width: 138,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(AppRoutes.editPlant),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: AppColors.primary,
                                        ),
                                        height: 138,
                                        padding: const EdgeInsets.all(10),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "You don't have any plants added",
                                                style: AppStyles.displaySmall
                                                    .apply(
                                                  color: AppColors.background,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Click here to add',
                                                style:
                                                    AppStyles.bodySmall.apply(
                                                  color: AppColors.background,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              SvgPicture.asset(AppIcons.plus),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .pushNamed(AppRoutes.editPlant),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.primary,
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(AppIcons.plus),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Add plant',
                                          style: AppStyles.bodyMedium.apply(
                                            color: AppColors.background,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ...List.generate(
                                plants.length,
                                (index) => _PlantTile(plants[index]),
                              ),
                            ],
                          );
                  },
                ),
                SizedBox(
                  height: 20 + MediaQuery.of(context).viewPadding.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Calendar extends StatefulWidget {
  const _Calendar();

  @override
  State<_Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  late DateTime start;
  late DateTime now;

  @override
  void initState() {
    super.initState();
    now = DateUtils.dateOnly(DateTime.now());
    start = now.subtract(Duration(days: now.weekday - 1));
  }

  void decrementWeek() {
    setState(() => start = start.subtract(const Duration(days: 7)));
  }

  void incrementWeek() {
    setState(() => start = start.add(const Duration(days: 7)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.background,
        border: Border.all(color: AppColors.surface.withOpacity(.5)),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              color: AppColors.surface,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.background,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: decrementWeek,
                        child: SvgPicture.asset(AppIcons.arrow),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: incrementWeek,
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: SvgPicture.asset(AppIcons.arrow),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('MMMM')
                            .format(start.add(const Duration(days: 3))),
                        style: AppStyles.bodyLarge,
                      ),
                      const Spacer(),
                      const SizedBox(width: 34),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoutes.calendar),
                        child: SvgPicture.asset(AppIcons.calendar),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(
                    13,
                    (index) => index.isEven
                        ? Expanded(
                            child: Center(
                              child: Text(
                                DateFormat('EEE').format(
                                  start.add(Duration(days: index ~/ 2)),
                                ),
                                style: AppStyles.displaySmall
                                    .apply(color: AppColors.primary),
                              ),
                            ),
                          )
                        : const SizedBox(width: 7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: BlocSelector<PlantsBloc, PlantsState, List<PlantState>>(
              selector: (state) => state.plants,
              builder: (context, plants) {
                final works = plants
                    .expand(
                      (e) => [...e.fertilizer, ...e.replanting, ...e.watering],
                    )
                    .toList();
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    13,
                    (index) {
                      if (index.isOdd) return const SizedBox(width: 7);
                      final d = start.add(Duration(days: index ~/ 2));
                      return Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: d == now ? AppColors.primary : null,
                                ),
                                height: 19,
                                width: 19,
                                child: Center(
                                  child: Text(
                                    DateFormat('dd').format(d),
                                    style: AppStyles.bodyMedium.apply(
                                      color: d == now
                                          ? AppColors.background
                                          : AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              if (works.contains(d))
                                const Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: CircleAvatar(
                                    radius: 6,
                                    backgroundColor: AppColors.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  const _SortSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(.2),
            ),
            width: 36,
            height: 5,
          ),
          const SizedBox(height: 30),
          BlocSelector<PlantsBloc, PlantsState, int>(
            selector: (state) => state.sort,
            builder: (context, sort) => Column(
              children: List.generate(
                AppConstants.sorts.length * 2 - 1,
                (index) => index.isEven
                    ? GestureDetector(
                        onTap: () =>
                            context.read<PlantsBloc>().updateSort(index ~/ 2),
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppConstants.sorts[index ~/ 2].$1,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                AppConstants.sorts[index ~/ 2].$2,
                                style: AppStyles.bodyMedium,
                              ),
                              const Spacer(),
                              Stack(
                                children: [
                                  SvgPicture.asset(AppIcons.circle),
                                  AnimatedOpacity(
                                    opacity: sort == index ~/ 2 ? 1 : 0,
                                    duration: AppConstants.duration200,
                                    child: SvgPicture.asset(AppIcons.check),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Divider(height: 1, color: AppColors.grey),
              ),
            ),
          ),
          SizedBox(height: 20 + MediaQuery.of(context).viewPadding.bottom),
        ],
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.secondary,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          plant.name,
                          style: AppStyles.displaySmall
                              .apply(color: AppColors.background),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          height: 45,
                          child: Text(
                            plant.description,
                            style: AppStyles.bodyMedium
                                .apply(color: AppColors.background),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 30,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          children: [
                            if (fertilizer != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.surface,
                                  ),
                                  padding: const EdgeInsets.all(5),
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
                                        DateFormat('dd.MM.yyyy')
                                            .format(fertilizer),
                                        style: AppStyles.bodySmall
                                            .apply(color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (replanting != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.surface,
                                  ),
                                  padding: const EdgeInsets.all(5),
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
                                        DateFormat('dd.MM.yyyy')
                                            .format(replanting),
                                        style: AppStyles.bodySmall
                                            .apply(color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (watering != null)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.surface,
                                ),
                                padding: const EdgeInsets.all(5),
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
                                    const SizedBox(width: 10),
                                    Text(
                                      DateFormat('dd.MM.yyyy').format(watering),
                                      style: AppStyles.bodySmall
                                          .apply(color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
