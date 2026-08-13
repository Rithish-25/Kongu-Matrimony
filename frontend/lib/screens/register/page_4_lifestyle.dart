import 'package:flutter/material.dart';
import 'register_components.dart';

class Page4Lifestyle extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page4Lifestyle({
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
        RegisterComponents.buildSectionHeader('Lifestyle & Hobbies'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Hobbies',
              fieldKey: 'hobbies',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter your hobbies';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Interests',
              fieldKey: 'interests',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter your interests';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Favourite Music',
              fieldKey: 'favMusic',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter favourite music';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Preferred Musics',
              fieldKey: 'prefMusic',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter preferred musics';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Sport/Fitness Activities',
              fieldKey: 'sports',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter sport/fitness activities';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Favourite Cuisine',
              fieldKey: 'favCuisine',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter favourite cuisine';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Preferred Dress Styles',
              fieldKey: 'prefDress',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter preferred dress styles';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Spoken Language',
              fieldKey: 'spokenLang',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter spoken languages';
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
