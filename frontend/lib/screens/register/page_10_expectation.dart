import 'package:flutter/material.dart';
import 'register_components.dart';

class Page10Expectation extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page10Expectation({
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
        RegisterComponents.buildSectionHeader('Partner Expectation'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Describe your expectations',
              fieldKey: 'expectation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              maxLines: 8,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please describe your expectations';
                }
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
