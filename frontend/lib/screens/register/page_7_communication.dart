import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_components.dart';

class Page7Communication extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page7Communication({
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
        RegisterComponents.buildSectionHeader('Communication Details'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Address',
              fieldKey: 'address',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              maxLines: 4,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter address';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Phone Number',
              fieldKey: 'phoneNumber',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter phone number';
                if (val.trim().length != 10) return 'Phone number must be exactly 10 digits';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Postal Code',
              fieldKey: 'postalCode',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter postal code';
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
