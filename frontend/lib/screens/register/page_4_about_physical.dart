import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import 'register_components.dart';

class Page4AboutPhysical extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;
  final VoidCallback? onSkipSection;

  const Page4AboutPhysical({
    super.key,
    required this.formData,
    required this.onChanged,
    required this.currentStep,
    this.onSkipSection,
  });

  @override
  Widget build(BuildContext context) {
    final heightOptions = List.generate(37, (i) {
      final inches = 48 + i;
      final ft = inches ~/ 12;
      final inch = inches % 12;
      return '$ft\'$inch"';
    });
    final weightOptions = List.generate(81, (i) => '${40 + i} kg');
    final bloodGroupOptions = const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- SECTION 1: PHYSICAL DETAILS (SKIPPABLE) ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegisterComponents.buildSectionHeader('Physical Details'),
            TextButton.icon(
              onPressed: () {
                onChanged('height', "5'6\"");
                onChanged('weight', '60 kg');
                onChanged('bloodGroup', 'O+');
                onChanged('bodyType', 'Average');
                onChanged('skinTone', 'Fair');
                onChanged('physicallyChallenged', 'No');
                if (onSkipSection != null) onSkipSection!();
              },
              icon: const Icon(Icons.fast_forward_rounded, size: 16, color: AppColors.primary),
              label: Text(
                'Skip',
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
            RegisterComponents.buildDropdownField(
              label: 'Height (Optional)',
              fieldKey: 'height',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: heightOptions,
              validator: (val) => null,
            ),
            RegisterComponents.buildDropdownField(
              label: 'Weight (Optional)',
              fieldKey: 'weight',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: weightOptions,
              validator: (val) => null,
            ),
            RegisterComponents.buildDropdownField(
              label: 'Blood Group (Optional)',
              fieldKey: 'bloodGroup',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: bloodGroupOptions,
              validator: (val) => null,
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Body Type',
              fieldKey: 'bodyType',
              formData: formData,
              onChanged: onChanged,
              choices: const ['Athletic', 'Slim', 'Average', 'Heavy'],
              validator: (val) => null,
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Skin Tone',
              fieldKey: 'skinTone',
              formData: formData,
              onChanged: onChanged,
              choices: const ['Brown', 'Medium', 'Very Fair', 'Fair', 'Wheatish'],
              validator: (val) => null,
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Physically Challenged',
              fieldKey: 'physicallyChallenged',
              formData: formData,
              onChanged: onChanged,
              choices: const ['No', 'Yes'],
              validator: (val) => null,
            ),
            if (formData['physicallyChallenged'] == 'Yes') ...[
              RegisterComponents.buildTextField(
                label: 'Disability Details / Notes',
                fieldKey: 'physicallyChallengedDetails',
                formData: formData,
                onChanged: onChanged,
                currentStep: currentStep,
                hint: 'Describe physical challenge / disability details',
                validator: (val) => null,
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),

        // --- SECTION 2: LIFESTYLE (SKIPPABLE) ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegisterComponents.buildSectionHeader('Lifestyle'),
            TextButton.icon(
              onPressed: () {
                onChanged('hobbies', 'Reading, Traveling');
                onChanged('interests', 'Music, Movies');
                onChanged('preferredDressStyles', 'Traditional & Casual');
                onChanged('spokenLanguages', 'Tamil, English');
                if (onSkipSection != null) onSkipSection!();
              },
              icon: const Icon(Icons.fast_forward_rounded, size: 16, color: AppColors.primary),
              label: Text(
                'Skip',
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
              label: 'Hobbies',
              fieldKey: 'hobbies',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              hint: 'e.g. Reading, Gardening, Traveling',
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Interests',
              fieldKey: 'interests',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              hint: 'e.g. Music, Movies, Photography',
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Preferred Dress Styles',
              fieldKey: 'preferredDressStyles',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              hint: 'e.g. Traditional, Casual, Formal',
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Spoken Languages',
              fieldKey: 'spokenLanguages',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              hint: 'e.g. Tamil, English',
              validator: (val) => null,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // --- SECTION 3: ABOUT MYSELF (SKIPPABLE) ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegisterComponents.buildSectionHeader('About Myself'),
            TextButton.icon(
              onPressed: () {
                onChanged('aboutMyself', 'A traditional and caring person.');
                if (onSkipSection != null) onSkipSection!();
              },
              icon: const Icon(Icons.fast_forward_rounded, size: 16, color: AppColors.primary),
              label: Text(
                'Skip',
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
              label: 'Write about yourself (Optional)',
              fieldKey: 'aboutMyself',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              maxLines: 4,
              hint: 'Write a few lines about your personality, family, or values...',
              validator: (val) => null,
            ),
          ],
        ),
      ],
    );
  }
}
