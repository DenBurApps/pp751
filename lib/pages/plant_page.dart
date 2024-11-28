import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pp751/bloc/plant_bloc.dart';
import 'package:pp751/bloc/plant_state.dart';
import 'package:pp751/bloc/plants_bloc.dart';
import 'package:pp751/navigation/routes.dart';
import 'package:pp751/ui_kit/colors.dart';
import 'package:pp751/ui_kit/text_styles.dart';
import 'package:pp751/utils/assets_paths.dart';
import 'package:pp751/utils/constants.dart';

class PlantPage extends StatelessWidget {
  const PlantPage({super.key, required this.plant});

  final PlantState plant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantBloc(plant),
      child: BlocBuilder<PlantBloc, PlantState>(
        builder: (context, state) {
          final now = DateUtils.dateOnly(DateTime.now());
          return PopScope(
            onPopInvokedWithResult: (didPop, result) async => await context
                .read<PlantsBloc>()
                .updatePlant(plant.id ?? 0, state),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.background,
                surfaceTintColor: AppColors.background,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: Navigator.of(context).pop,
                      child: SvgPicture.asset(AppIcons.back),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.editPlant, arguments: state),
                      child: SvgPicture.asset(AppIcons.edit),
                    ),
                  ],
                ),
                titleSpacing: 20,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _Info(state),
                      const SizedBox(height: 15),
                      _Calendar(state),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () =>
                            context.read<PlantBloc>().updateFertilizer(now),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: AppColors.secondary,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.background,
                                ),
                                child: Image.asset(AppImages.fertilizer),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Fertiliser',
                                style: AppStyles.bodyMedium
                                    .apply(color: AppColors.background),
                              ),
                              const Spacer(),
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.background,
                                ),
                                height: 40,
                                width: 40,
                                child: AnimatedOpacity(
                                  opacity:
                                      state.fertilizer.contains(now) ? 1 : 0,
                                  duration: AppConstants.duration200,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () =>
                            context.read<PlantBloc>().updateReplanting(now),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: AppColors.surface,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.background,
                                ),
                                child: Image.asset(AppImages.replanting),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Replanting',
                                style: AppStyles.bodyMedium
                                    .apply(color: AppColors.background),
                              ),
                              const Spacer(),
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.background,
                                ),
                                height: 40,
                                width: 40,
                                child: AnimatedOpacity(
                                  opacity:
                                      state.replanting.contains(now) ? 1 : 0,
                                  duration: AppConstants.duration200,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () =>
                            context.read<PlantBloc>().updateWatering(now),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: AppColors.blue,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.background,
                                ),
                                child: Image.asset(AppImages.watering),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Watering',
                                style: AppStyles.bodyMedium
                                    .apply(color: AppColors.background),
                              ),
                              const Spacer(),
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.background,
                                ),
                                height: 40,
                                width: 40,
                                child: AnimatedOpacity(
                                  opacity: state.watering.contains(now) ? 1 : 0,
                                  duration: AppConstants.duration200,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
        },
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.plant);

  final PlantState plant;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.secondary,
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 237,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: (MediaQuery.sizeOf(context).width - 40 - 237) / 2,
              ),
              itemBuilder: (context, index) => index == plant.photos.length
                  ? GestureDetector(
                      onTap: () async {
                        final file = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (file != null && context.mounted) {
                          context.read<PlantBloc>().addPhoto(file.path);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.background,
                          ),
                        ),
                        width: 237,
                        height: 237,
                        child: Center(
                          child: SvgPicture.asset(
                            AppIcons.camera,
                            colorFilter: const ColorFilter.mode(
                              AppColors.background,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(plant.photos[index].path),
                            fit: BoxFit.cover,
                            width: 237,
                            height: 237,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.black.withOpacity(.2),
                            ),
                            clipBehavior: Clip.hardEdge,
                            padding: const EdgeInsets.all(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Text(
                                DateFormat('dd.MM.yy')
                                    .format(plant.photos[index].date),
                                style: AppStyles.bodyLarge
                                    .apply(color: AppColors.background),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 10),
              itemCount: plant.photos.length + 1,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              plant.name,
              style: AppStyles.displayLarge.apply(color: AppColors.background),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                plant.description,
                style: AppStyles.bodyMedium.apply(color: AppColors.background),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _Calendar extends StatefulWidget {
  const _Calendar(this.plant);

  final PlantState plant;

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
    setState(() {
      start = start.subtract(const Duration(days: 7));
    });
  }

  void incrementWeek() {
    setState(() {
      start = start.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.background,
        border: Border.all(color: AppColors.surface.withOpacity(.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: decrementWeek,
                child: SvgPicture.asset(AppIcons.arrow),
              ),
              const Spacer(),
              Text(
                DateFormat('MMMM').format(start.add(const Duration(days: 3))),
                style: AppStyles.bodyLarge,
              ),
              const Spacer(),
              GestureDetector(
                onTap: incrementWeek,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: SvgPicture.asset(AppIcons.arrow),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              13,
              (index) {
                if (index.isOdd) return const SizedBox(width: 7);
                final d = start.add(Duration(days: index ~/ 2));
                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        DateFormat('EEE').format(
                          start.add(Duration(days: index ~/ 2)),
                        ),
                        style: AppStyles.displaySmall
                            .apply(color: AppColors.primary),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: d == now ? AppColors.surface : null,
                        ),
                        height: 25,
                        width: 25,
                        child: Center(
                          child: Text(
                            DateFormat('dd').format(d),
                            style: AppStyles.bodyMedium.apply(
                              color: d == now ? AppColors.primary : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.plant.fertilizer.contains(d))
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              child: CircleAvatar(
                                radius: 2.5,
                                backgroundColor: AppColors.secondary,
                              ),
                            ),
                          if (widget.plant.replanting.contains(d))
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              child: CircleAvatar(
                                radius: 2.5,
                                backgroundColor: AppColors.surface,
                              ),
                            ),
                          if (widget.plant.watering.contains(d))
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              child: CircleAvatar(
                                radius: 2.5,
                                backgroundColor: AppColors.blue,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
