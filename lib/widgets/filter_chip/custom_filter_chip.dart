import 'package:flutter/material.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final Widget? avatar;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onSelected,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilterChip(
        avatar: avatar,
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        checkmarkColor: Colors.white,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        disabledColor: AppColors.surfaceMuted,
        shadowColor: Colors.transparent,
        selectedShadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: 1.2,
        ),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }
}
