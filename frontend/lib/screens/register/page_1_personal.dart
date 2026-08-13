import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_components.dart';

class Page1Personal extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page1Personal({
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
        RegisterComponents.buildSectionHeader('Personal Details'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Name',
              fieldKey: 'name',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter your name';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Email',
              fieldKey: 'email',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter your email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Gender',
              fieldKey: 'gender',
              formData: formData,
              onChanged: onChanged,
              choices: const ['Male', 'Female'],
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please select your gender';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Mobile No',
              fieldKey: 'mobile',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter mobile number';
                if (val.trim().length != 10) return 'Mobile number must be exactly 10 digits';
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
