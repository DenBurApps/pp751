import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:pp751/ui_kit/widgets/app_elevated_button.dart';
import 'package:pp751/ui_kit/widgets/app_text_form_field.dart';
import 'package:pp751/utils/assets_paths.dart';
import 'package:pp751/utils/constants.dart';

class EditPlantPage extends StatelessWidget {
  const EditPlantPage({super.key, this.plant});

  final PlantState? plant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocProvider(
        create: (context) => PlantBloc(plant),
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
                if (plant != null)
                  GestureDetector(
                    onTap: () async {
                      await context
                          .read<PlantsBloc>()
                          .deletePlant(plant!.id ?? 0);
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.home,
                          (route) => false,
                        );
                      }
                    },
                    child: SvgPicture.asset(AppIcons.trash),
                  ),
              ],
            ),
            titleSpacing: 20,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Name', style: AppStyles.displayMedium),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BlocSelector<PlantBloc, PlantState, String>(
                          selector: (state) => state.name,
                          builder: (context, name) => AppTextFormField(
                            initialValue: name,
                            hint: 'Name',
                            onChanged: context.read<PlantBloc>().updateName,
                            formatters: [LengthLimitingTextInputFormatter(40)],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Description',
                          style: AppStyles.displayMedium,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BlocSelector<PlantBloc, PlantState, String>(
                          selector: (state) => state.description,
                          builder: (context, description) => AppTextFormField(
                            initialValue: description,
                            hint: 'Description',
                            onChanged:
                                context.read<PlantBloc>().updateDescription,
                            maxLines: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Date of planting',
                          style: AppStyles.displayMedium,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BlocSelector<PlantBloc, PlantState, DateTime?>(
                          selector: (state) => state.date,
                          builder: (context, date) => GestureDetector(
                            onTap: () => showCupertinoModalPopup<void>(
                              context: context,
                              builder: (_) => Container(
                                height: 216,
                                padding: const EdgeInsets.only(top: 6.0),
                                margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                color: AppColors.background,
                                child: SafeArea(
                                  top: false,
                                  child: CupertinoDatePicker(
                                    initialDateTime: date ??
                                        DateUtils.dateOnly(DateTime.now()),
                                    maximumDate: DateTime.now(),
                                    mode: CupertinoDatePickerMode.date,
                                    use24hFormat: true,
                                    showDayOfWeek: true,
                                    onDateTimeChanged:
                                        context.read<PlantBloc>().updateDate,
                                  ),
                                ),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.surface.withOpacity(.5),
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  date != null
                                      ? DateFormat('dd.MM.yyyy').format(date)
                                      : '00.00.0000',
                                  style: AppStyles.bodyMedium.apply(
                                    color: date != null
                                        ? AppColors.black
                                        : AppColors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Photo', style: AppStyles.displayMedium),
                      ),
                      const _Photos(),
                      SizedBox(
                        height: 80 + MediaQuery.of(context).viewPadding.bottom,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 10 -
                    MediaQuery.of(context).viewInsets.bottom +
                    MediaQuery.of(context).viewPadding.bottom,
                child: BlocBuilder<PlantBloc, PlantState>(
                  builder: (context, state) => AppElevatedButton(
                    buttonText: 'Save',
                    onTap: () async {
                      if (plant != null) {
                        await context
                            .read<PlantsBloc>()
                            .updatePlant(plant!.id ?? 0, state);
                      } else {
                        await context.read<PlantsBloc>().addPlant(state);
                      }
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.home,
                          (route) => false,
                        );
                      }
                    },
                    isActive: context.read<PlantBloc>().canSave,
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

class _Photos extends StatelessWidget {
  const _Photos();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlantBloc, PlantState, List<PhotoState>>(
      selector: (state) => state.photos,
      builder: (context, photos) => SizedBox(
        height: 153,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) => index == photos.length
              ? Padding(
                  padding: const EdgeInsets.only(top: 17),
                  child: GestureDetector(
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
                          color: AppColors.surface.withOpacity(.5),
                        ),
                      ),
                      width: 136,
                      height: 136,
                      child: Center(child: SvgPicture.asset(AppIcons.camera)),
                    ),
                  ),
                )
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 17, 17, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.surface.withOpacity(.5),
                          ),
                        ),
                        width: 136,
                        height: 136,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: Image.file(
                            File(photos[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: AnimatedOpacity(
                        opacity: photos.isEmpty ? 0 : 1,
                        duration: AppConstants.duration200,
                        child: GestureDetector(
                          onTap: photos.isEmpty
                              ? null
                              : context.read<PlantBloc>().deletePhoto,
                          behavior: HitTestBehavior.deferToChild,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(width: 10),
          itemCount: photos.length + 1,
        ),
      ),
    );
  }
}
