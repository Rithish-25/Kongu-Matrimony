import 'package:flutter/material.dart';
import 'register_components.dart';

class Page3Astrology extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page3Astrology({
    super.key,
    required this.formData,
    required this.onChanged,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegisterComponents.buildSectionHeader('Astrology Profile'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Kootam',
              fieldKey: 'kootam',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter Kootam';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Kula Theiva Temple',
              fieldKey: 'kulaTheivaTemple',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter Kula Theiva Temple';
                return null;
              },
            ),

            RegisterComponents.buildTextField(
              label: 'Time of Birth',
              fieldKey: 'timeOfBirth',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              hint: 'e.g. 10:30 AM',
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter time of birth';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Place of Birth',
              fieldKey: 'placeOfBirth',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter place of birth';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Star',
              fieldKey: 'star',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter star';
                return null;
              },
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Padham',
              fieldKey: 'padham',
              formData: formData,
              onChanged: onChanged,
              choices: const ['1', '2', '3', '4'],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select padham';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Rasi',
              fieldKey: 'rasi',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter rasi';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Lakuna',
              fieldKey: 'lakuna',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter lakuna';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Tamil Date of Birth',
              fieldKey: 'tamilDob',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter Tamil DOB';
                return null;
              },
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Dosham',
              fieldKey: 'dhosam',
              formData: formData,
              onChanged: onChanged,
              choices: const ['No', 'Yes'],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select an option';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Janana Kala Thisai Erupu',
              fieldKey: 'thisaiErupu',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter Janana Kala Thisai Erupu';
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
