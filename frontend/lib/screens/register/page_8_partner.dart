import 'package:flutter/material.dart';
import 'register_components.dart';

class Page8Partner extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page8Partner({
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
        RegisterComponents.buildSectionHeader('Partner Preference Details'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: "Partner's Age (e.g. 20-25)",
              fieldKey: 'partnerAge',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter age preference';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Height Preference',
              fieldKey: 'partnerHeight',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter height preference';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Weight Preference',
              fieldKey: 'partnerWeight',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter weight preference';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Education Preference',
              fieldKey: 'partnerEducation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter education preference';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Country Preference',
              fieldKey: 'partnerCountry',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter country preference';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Occupation Preference',
              fieldKey: 'partnerOccupation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter occupation preference';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Partner Income Value',
              fieldKey: 'partnerIncome',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter partner income';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Kootam Preference',
              fieldKey: 'partnerKootam',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter kootam preference';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Kulam Preference',
              fieldKey: 'partnerKulam',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter kulam preference';
                return null;
              },
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Horoscope Match Required',
              fieldKey: 'partnerHoroscopeMatch',
              formData: formData,
              onChanged: onChanged,
              choices: const ['No', 'Yes', 'Doesn\'t matter'],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select an option';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Star Preference',
              fieldKey: 'partnerStar',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter star preference';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Rasi Preference',
              fieldKey: 'partnerRasi',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter rasi preference';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Marital Status Preference',
              fieldKey: 'partnerMaritalStatus',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter marital status preference';
                return null;
              },
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Dosham Preference',
              fieldKey: 'partnerDosham',
              formData: formData,
              onChanged: onChanged,
              choices: const ['No', 'Yes'],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select an option';
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
