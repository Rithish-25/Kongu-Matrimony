import 'package:flutter/material.dart';
import 'register_components.dart';

class Page9About extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page9About({
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
        RegisterComponents.buildSectionHeader('About Myself'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Write about yourself',
              fieldKey: 'aboutMyself',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              maxLines: 8,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please write something about yourself';
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
