import 'package:flutter/material.dart';
import 'register_components.dart';

class Page2Physical extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page2Physical({
    super.key,
    required this.formData,
    required this.onChanged,
    required this.currentStep,
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
        RegisterComponents.buildSectionHeader('Physical Details'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildDropdownField(
              label: 'Height',
              fieldKey: 'height',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: heightOptions,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select height';
                return null;
              },
            ),
            RegisterComponents.buildDropdownField(
              label: 'Weight',
              fieldKey: 'weight',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: weightOptions,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select weight';
                return null;
              },
            ),
            RegisterComponents.buildDropdownField(
              label: 'Blood Group',
              fieldKey: 'bloodGroup',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: bloodGroupOptions,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select blood group';
                return null;
              },
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Body Type',
              fieldKey: 'bodyType',
              formData: formData,
              onChanged: onChanged,
              choices: const ['Athletic', 'Slim', 'Average', 'Heavy'],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select body type';
                return null;
              },
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Drink',
              fieldKey: 'drink',
              formData: formData,
              onChanged: onChanged,
              choices: const ['No', 'Yes', 'Occasionally'],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select an option';
                return null;
              },
            ),
            RegisterComponents.buildDropdownField(
              label: 'Marital Status',
              fieldKey: 'maritalStatus',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: const ['Never Married', 'Divorced', 'Widowed', 'Awaiting Divorce'],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select marital status';
                return null;
              },
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Skin Tone',
              fieldKey: 'skinTone',
              formData: formData,
              onChanged: onChanged,
              choices: const ['Brown', 'Medium', 'Very Fair', 'Fair', 'Wheatish'],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select skin tone';
                return null;
              },
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Diet',
              fieldKey: 'diet',
              formData: formData,
              onChanged: onChanged,
              choices: const ['Veg', 'Non-Veg', 'Vegan'],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select diet';
                return null;
              },
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Physically Challenged',
              fieldKey: 'physicallyChallenged',
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
