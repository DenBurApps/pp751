import 'package:flutter/material.dart';
import 'package:pp751/ui_kit/colors.dart';
import 'package:pp751/ui_kit/text_styles.dart';
import 'package:pp751/utils/constants.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isActive = true,
  });

  final String buttonText;
  final void Function() onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: AppConstants.duration200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive ? AppColors.primary : AppColors.grey.withOpacity(.5),
        ),
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        child: Center(
          child: Text(
            buttonText,
            style: AppStyles.displayMedium.apply(color: AppColors.background),
          ),
        ),
      ),
    );
  }
}
