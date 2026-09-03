import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/localization/app_language.dart';

class RegisterComponents {
  RegisterComponents._();

  static Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLanguageController.text(title),
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 2.5,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  /// Premium wrapper for form pages to group fields beautifully.
  static Widget buildFormCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      margin: const EdgeInsets.only(bottom: AppConstants.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  static Widget buildTextField({
    required String label,
    required String fieldKey,
    required Map<String, String> formData,
    required Function(String, String) onChanged,
    required int currentStep,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hint,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: TextFormField(
        key: ValueKey('${fieldKey}_$currentStep'),
        initialValue: formData[fieldKey] ?? '',
        onChanged: (val) => onChanged(fieldKey, val),
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: AppLanguageController.text(label),
          hintText: hint != null ? AppLanguageController.text(hint) : null,
          labelStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          errorStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.error,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
        ),
      ),
    );
  }

  static Widget buildDropdownField({
    required String label,
    required String fieldKey,
    required Map<String, String> formData,
    required Function(String, String) onChanged,
    required int currentStep,
    required List<String> items,
    String? Function(String?)? validator,
  }) {
    final value = formData[fieldKey];
    final selected = items.contains(value) ? value : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: DropdownButtonFormField<String>(
        key: ValueKey('${fieldKey}_$currentStep'),
        initialValue: selected,
        onChanged: (val) => onChanged(fieldKey, val ?? ''),
        validator: (val) {
          final err = validator?.call(val);
          if (err != null) {
            return AppLanguageController.text(err);
          }
          return null;
        },
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 24),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: AppLanguageController.text(label),
          labelStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          errorStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.error,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    AppLanguageController.text(item),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  static Widget buildChoiceSelector({
    required String label,
    required String fieldKey,
    required Map<String, String> formData,
    required Function(String, String) onChanged,
    required List<String> choices,
    String? Function(String?)? validator,
  }) {
    return buildDropdownField(
      label: label,
      fieldKey: fieldKey,
      formData: formData,
      onChanged: onChanged,
      currentStep: 0,
      items: choices,
      validator: validator,
    );
  }
}
