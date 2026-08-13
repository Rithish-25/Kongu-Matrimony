import 'package:flutter/material.dart';
import 'register_components.dart';

class Page5Family extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page5Family({
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
        RegisterComponents.buildSectionHeader('Family Details'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Father Name',
              fieldKey: 'fatherName',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter father\'s name';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Mother Name',
              fieldKey: 'motherName',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter mother\'s name';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Father Occupation',
              fieldKey: 'fatherOccupation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter father\'s occupation';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Mother Occupation',
              fieldKey: 'motherOccupation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter mother\'s occupation';
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: RegisterComponents.buildTextField(
                    label: 'No. of Sisters',
                    fieldKey: 'noOfSisters',
                    formData: formData,
                    onChanged: onChanged,
                    currentStep: currentStep,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Please enter number';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RegisterComponents.buildTextField(
                    label: 'Sisters Married',
                    fieldKey: 'sistersMarried',
                    formData: formData,
                    onChanged: onChanged,
                    currentStep: currentStep,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Please enter number';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RegisterComponents.buildTextField(
                    label: 'No. of Brothers',
                    fieldKey: 'noOfBrothers',
                    formData: formData,
                    onChanged: onChanged,
                    currentStep: currentStep,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Please enter number';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RegisterComponents.buildTextField(
                    label: 'Brothers Married',
                    fieldKey: 'brothersMarried',
                    formData: formData,
                    onChanged: onChanged,
                    currentStep: currentStep,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Please enter number';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Family Status',
              fieldKey: 'familyStatus',
              formData: formData,
              onChanged: onChanged,
              choices: const ['Affluent', 'Rich', 'Upper middle', 'Middle'],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select family status';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Family Annual Income',
              fieldKey: 'familyAnnualIncome',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter annual income';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Family Property',
              fieldKey: 'familyProperty',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter property details';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Family Monthly Income',
              fieldKey: 'familyMonthlyIncome',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter monthly income';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Farming Land Details',
              fieldKey: 'farmingLandDetails',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter farming land details';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Native Place',
              fieldKey: 'native',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter native place';
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
