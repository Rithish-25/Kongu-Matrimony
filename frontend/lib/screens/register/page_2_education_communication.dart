import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_components.dart';

class Page2EducationCommunication extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page2EducationCommunication({
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
        // --- SECTION 1: EDUCATION & OCCUPATION PROFILE ---
        RegisterComponents.buildSectionHeader('Education & Occupation Details'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Education Level',
              fieldKey: 'educationLevel',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Education Degree',
              fieldKey: 'education',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Education Detail',
              fieldKey: 'educationDetail',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Occupation',
              fieldKey: 'occupation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Job Details',
              fieldKey: 'jobDetails',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Current Working Company',
              fieldKey: 'currentWorkingCompany',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Annual Income',
              fieldKey: 'annualIncome',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Work Location / City',
              fieldKey: 'currentCity',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // --- SECTION 2: COMMUNICATION & ADDRESS DETAILS ---
        RegisterComponents.buildSectionHeader('Communication & Address Details'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Address',
              fieldKey: 'address',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              maxLines: 3,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'City',
              fieldKey: 'city',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'State',
              fieldKey: 'state',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Country',
              fieldKey: 'country',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Postal Code (6 Digits)',
              fieldKey: 'postalCode',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Alternate Mobile Number (10 Digits)',
              fieldKey: 'alternateMobile',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (val) => null,
            ),
          ],
        ),
      ],
    );
  }
}
