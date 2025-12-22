import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final bool enabled;

  const CustomDropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        filled: true,
        fillColor: enabled
            ? (isDark ? AppColors.darkGrey40 : AppColors.lightGrey10)
            : (isDark ? AppColors.darkGrey60 : AppColors.lightGrey20),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.primaryColor)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkGrey20 : AppColors.lightGrey40,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkGrey20 : AppColors.lightGrey40,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      dropdownColor: isDark ? AppColors.darkGrey40 : AppColors.lightBackground,
      icon: Icon(
        Icons.arrow_drop_down,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
    );
  }
}