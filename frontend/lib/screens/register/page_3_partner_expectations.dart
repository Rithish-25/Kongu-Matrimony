import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import 'register_components.dart';

class Page3PartnerExpectations extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;
  final VoidCallback? onSkipExpectation;

  const Page3PartnerExpectations({
    super.key,
    required this.formData,
    required this.onChanged,
    required this.currentStep,
    this.onSkipExpectation,
  });

  @override
  Widget build(BuildContext context) {
    final isHoroscopeYes = formData['partnerHoroscopeMatch'] == 'Yes';
    final isSevvaiMatch = formData['partnerSevvaiMatch'] == 'Yes';
    final isRaguKethuMatch = formData['partnerRaguKethuMatch'] == 'Yes';
    final isSuthaaMatch = formData['partnerSuthaaMatch'] == 'Yes';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- SECTION 1: PARTNER PREFERENCES ---
        RegisterComponents.buildSectionHeader('Partner Preference Details'),
        RegisterComponents.buildFormCard(
          children: [
            // Age Preference
            RegisterComponents.buildTextField(
              label: "Partner's Age (Optional)",
              fieldKey: 'partnerAge',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              hint: "e.g. 22 - 27 or Doesn't matter",
              validator: (val) => null,
            ),

            // Height Preference
            RegisterComponents.buildTextField(
              label: 'Height Preference (Optional)',
              fieldKey: 'partnerHeight',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              hint: "e.g. 5'2\" - 5'8\" or Doesn't matter",
              validator: (val) => null,
            ),

            // Education Preference
            RegisterComponents.buildTextField(
              label: 'Education Preference (Optional)',
              fieldKey: 'partnerEducation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              hint: "e.g. Any Degree / Master's / Doesn't matter",
              validator: (val) => null,
            ),

            // Occupation Preference
            RegisterComponents.buildTextField(
              label: 'Occupation Preference (Optional)',
              fieldKey: 'partnerOccupation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              hint: "e.g. IT, Govt Job, Business or Doesn't matter",
              validator: (val) => null,
            ),

            // Country Preference Dropdown
            RegisterComponents.buildDropdownField(
              label: 'Country / Location Preference',
              fieldKey: 'partnerCountry',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              dividerAfterItems: const ['India'],
              items: const [
                'Anywhere',
                'Doesn\'t matter',
                'India',
                'USA',
                'UK',
                'Canada',
                'Australia',
                'UAE',
                'Singapore',
                'Malaysia',
                'Other',
              ],
              validator: (val) => null,
            ),



            // Horoscope Match Required Choice Selector
            RegisterComponents.buildChoiceSelector(
              label: 'Horoscope Match Required',
              fieldKey: 'partnerHoroscopeMatch',
              formData: formData,
              onChanged: onChanged,
              choices: const ['No', 'Yes', 'Doesn\'t matter'],
              validator: (val) => null,
            ),

            // Conditional Horoscope Match Types: Sevvai, Ragu / Kethu, Suthaa
            if (isHoroscopeYes) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Acceptable Horoscope Match Types:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                      title: Text(
                        'Sevvai',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                      value: isSevvaiMatch,
                      onChanged: (val) {
                        onChanged('partnerSevvaiMatch', val == true ? 'Yes' : 'No');
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                      title: Text(
                        'Ragu / Kethu',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                      value: isRaguKethuMatch,
                      onChanged: (val) {
                        onChanged('partnerRaguKethuMatch', val == true ? 'Yes' : 'No');
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                      title: Text(
                        'Suthaa (No Dosham)',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                      value: isSuthaaMatch,
                      onChanged: (val) {
                        onChanged('partnerSuthaaMatch', val == true ? 'Yes' : 'No');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),

        // --- SECTION 2: PARTNER EXPECTATIONS (SKIPPABLE) ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RegisterComponents.buildSectionHeader('Partner Expectations'),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                onChanged('expectation', 'Open to suitable matches');
                if (onSkipExpectation != null) {
                  onSkipExpectation!();
                }
              },
              icon: const Icon(Icons.fast_forward_rounded, size: 16, color: AppColors.primary),
              label: Text(
                'Skip Section',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Describe your partner expectations (Optional)',
              fieldKey: 'expectation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              maxLines: 5,
              hint: 'e.g. Looking for a well-educated partner with good family values...',
              validator: (val) => null,
            ),
          ],
        ),
      ],
    );
  }
}
