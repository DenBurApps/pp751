import 'package:flutter/material.dart';
import 'package:pp751/ui_kit/colors.dart';

abstract class AppStyles {
  static const displayLarge = TextStyle(
    fontFamily: 'Outfit',
    height: 1.1,
    fontSize: 25,
    fontWeight: FontWeight.w700,
    color: AppColors.secondary,
  );
  static const displayMedium = TextStyle(
    fontFamily: 'Outfit',
    height: 1.1,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.secondary,
  );
  static const displaySmall = TextStyle(
    fontFamily: 'Outfit',
    height: 1.1,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.secondary,
  );
  static const bodyLarge = TextStyle(
    fontFamily: 'Outfit',
    height: 1.1,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary,
  );
  static const bodyMedium = TextStyle(
    fontFamily: 'Outfit',
    height: 1.1,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary,
  );
  static const bodySmall = TextStyle(
    fontFamily: 'Outfit',
    height: 1.1,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.secondary,
  );
}
