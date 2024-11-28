import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pp751/ui_kit/colors.dart';
import 'package:pp751/ui_kit/text_styles.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.hint,
    this.initialValue,
    required this.onChanged,
    this.formatters,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String hint;
  final String? initialValue;
  final void Function(String) onChanged;
  final List<TextInputFormatter>? formatters;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      style: AppStyles.bodyMedium.apply(color: AppColors.black),
      cursorHeight: 20,
      cursorWidth: 1,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: formatters,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintStyle: AppStyles.bodyMedium.apply(color: AppColors.grey),
        hintText: hint,
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
    );
  }
}
