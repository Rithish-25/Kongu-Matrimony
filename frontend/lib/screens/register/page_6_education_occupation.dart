import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_components.dart';

class Page6EducationOccupation extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page6EducationOccupation({
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
        RegisterComponents.buildSectionHeader('Education & Occupation Profile'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Education Level',
              fieldKey: 'educationLevel',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter education level';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Education',
              fieldKey: 'education',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter education';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Occupation',
              fieldKey: 'occupation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter occupation';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Country',
              fieldKey: 'country',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter country';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'State',
              fieldKey: 'state',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter state';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Family Name',
              fieldKey: 'familyName',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter family name';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Education Detail',
              fieldKey: 'educationDetail',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter education details';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Job Details',
              fieldKey: 'jobDetails',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter job details';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Current Working Company',
              fieldKey: 'currentWorkingCompany',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter working company';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Current City or Near by City',
              fieldKey: 'currentCity',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter city';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Annual Income',
              fieldKey: 'annualIncome',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter annual income';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Monthly Income',
              fieldKey: 'monthlyIncome',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter monthly income';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Alternate Mobile',
              fieldKey: 'alternateMobile',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter alternate mobile';
                if (val.trim().length != 10) return 'Mobile must be 10 digits';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Email Address',
              fieldKey: 'email2',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Refer Name',
              fieldKey: 'referName',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter refer name';
                return null;
              },
            ),
            RegisterComponents.buildTextField(
              label: 'Refer Mobile',
              fieldKey: 'referMobile',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter refer mobile';
                if (val.trim().length != 10) return 'Mobile must be 10 digits';
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
