import 'package:flutter/material.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final VoidCallback? onClear;
  final VoidCallback? onFilterPressed;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = 'Search by name, education, or occupation...',
    this.onClear,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surface, AppColors.surfaceMuted],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: AppConstants.cardShadow,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.textLight,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller != null && controller!.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                  onPressed: onClear,
                ),
              if (onFilterPressed != null)
                IconButton(
                  icon: const Icon(Icons.tune_rounded, color: AppColors.secondaryDark, size: 20),
                  onPressed: onFilterPressed,
                ),
              const SizedBox(width: AppConstants.spacingXS),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        ),
      ),
    );
  }
}
