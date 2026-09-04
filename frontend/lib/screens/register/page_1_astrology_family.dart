import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import 'register_components.dart';

class Page1AstrologyFamily extends StatelessWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;

  const Page1AstrologyFamily({
    super.key,
    required this.formData,
    required this.onChanged,
    required this.currentStep,
  });

  static const List<String> kootamOptions = [
    'Sempoothan',
    'Kannandhai',
    'Pavalan',
    'Pullan',
    'Porulanthai',
    'Othalan',
    'Aadai',
    'Aavanai',
    'Aandhai',
    'Adhira',
    'Aayiravan',
    'Eesan',
    'Ennai',
    'Kadai',
    'Kari',
    'Kilai',
    'Kollan',
    'Korai',
    'Kovan',
    'Moolan',
    'Mutthan',
    'Neelan',
    'Pannai',
    'Paandian',
    'Periandi',
    'Pillan',
    'Poosan',
    'Sengaani',
    'Sengunthar',
    'Servai',
    'Thazhan',
    'Thoratan',
    'Vandikan',
    'Velli',
    'Vilayan',
    'Other',
  ];

  static const List<String> starOptions = [
    'Ashwini',
    'Bharani',
    'Krittika',
    'Rohini',
    'Mrigashirsha',
    'Ardra',
    'Punarvasu',
    'Pushya',
    'Ashlesha',
    'Magha',
    'Purva Phalguni',
    'Uttara Phalguni',
    'Hasta',
    'Chitra',
    'Swati',
    'Vishakha',
    'Anuradha',
    'Jyeshtha',
    'Moola',
    'Purva Ashadha',
    'Uttara Ashadha',
    'Shravana',
    'Dhanishta',
    'Shatabhisha',
    'Purva Bhadrapada',
    'Uttara Bhadrapada',
    'Revati',
  ];

  static const List<String> rasiOptions = [
    'Mesham (Aries)',
    'Rishabam (Taurus)',
    'Mithunam (Gemini)',
    'Kadagam (Cancer)',
    'Simmam (Leo)',
    'Kanni (Virgo)',
    'Thulaam (Libra)',
    'Vrichigam (Scorpio)',
    'Dhanusu (Sagittarius)',
    'Magaram (Capricorn)',
    'Kumbam (Aquarius)',
    'Meenam (Pisces)',
  ];

  static const List<String> lakunaOptions = [
    'Mesham',
    'Rishabam',
    'Mithunam',
    'Kadagam',
    'Simmam',
    'Kanni',
    'Thulaam',
    'Vrichigam',
    'Dhanusu',
    'Magaram',
    'Kumbam',
    'Meenam',
  ];

  static const List<String> thisaiOptions = [
    'Suryan',
    'Chandran',
    'Sevvai',
    'Ragu',
    'Guru',
    'Sani',
    'Budhan',
    'Kethu',
    'Sukkiran',
  ];

  @override
  Widget build(BuildContext context) {
    final isDoshamYes = formData['dhosam'] == 'Yes';
    final isRaguKethuSelected = formData['raguKethuDosham'] == 'Yes';
    final isSevvaiSelected = formData['sevvaiDosham'] == 'Yes';
    final List<String> sevvaiPositions = (formData['sevvaiPositions'] ?? '').split(',').where((e) => e.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- SECTION 1: ASTROLOGY PROFILE ---
        RegisterComponents.buildSectionHeader('Astrological Profile'),
        RegisterComponents.buildFormCard(
          children: [
            // Kootam
            RegisterComponents.buildDropdownField(
              label: 'Kootam',
              fieldKey: 'kootam',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: kootamOptions,
              validator: (val) => null,
            ),

            // Kula Theiva Temple
            RegisterComponents.buildTextField(
              label: 'Kula Theiva Temple',
              fieldKey: 'kulaTheivaTemple',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),

            // DOB
            RegisterComponents.buildTextField(
              label: 'DOB',
              fieldKey: 'dob',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              hint: 'mm/dd/yyyy',
              validator: (val) => null,
            ),

            // Time of Birth
            RegisterComponents.buildTextField(
              label: 'Time of Birth',
              fieldKey: 'timeOfBirth',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              hint: 'e.g. 10:30 AM',
              validator: (val) => null,
            ),

            // Place of Birth
            RegisterComponents.buildTextField(
              label: 'Place of Birth',
              fieldKey: 'placeOfBirth',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),

            // Star
            RegisterComponents.buildDropdownField(
              label: 'Star',
              fieldKey: 'star',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: starOptions,
              validator: (val) => null,
            ),

            // Padham
            RegisterComponents.buildChoiceSelector(
              label: 'Padham',
              fieldKey: 'padham',
              formData: formData,
              onChanged: onChanged,
              choices: const ['1', '2', '3', '4'],
              validator: (val) => null,
            ),

            // Rasi
            RegisterComponents.buildDropdownField(
              label: 'Rasi',
              fieldKey: 'rasi',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: rasiOptions,
              validator: (val) => null,
            ),

            // Lakuna (Lakkanam)
            RegisterComponents.buildDropdownField(
              label: 'Lakuna (Lakkanam)',
              fieldKey: 'lakuna',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: lakunaOptions,
              validator: (val) => null,
            ),

            // Dosham
            RegisterComponents.buildChoiceSelector(
              label: 'Dosham',
              fieldKey: 'dhosam',
              formData: formData,
              onChanged: onChanged,
              choices: const ['No', 'Yes'],
              validator: (val) => null,
            ),

            // Conditional Dosham Details
            if (isDoshamYes) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Dosham Type:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                      title: Text(
                        'Ragu / Kethu',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                      value: isRaguKethuSelected,
                      onChanged: (val) {
                        onChanged('raguKethuDosham', val == true ? 'Yes' : 'No');
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                      title: Text(
                        'Sevvai / Pariharam',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                      value: isSevvaiSelected,
                      onChanged: (val) {
                        onChanged('sevvaiDosham', val == true ? 'Yes' : 'No');
                      },
                    ),
                    if (isSevvaiSelected) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Sevvai Position / House:',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ['2', '4', '7', '8', '12'].map((pos) {
                          final isPosSelected = sevvaiPositions.contains(pos);
                          return FilterChip(
                            label: Text(pos),
                            selected: isPosSelected,
                            selectedColor: AppColors.primary,
                            labelStyle: GoogleFonts.plusJakartaSans(
                              color: isPosSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            onSelected: (selected) {
                              List<String> current = List.from(sevvaiPositions);
                              if (selected) {
                                if (!current.contains(pos)) current.add(pos);
                              } else {
                                current.remove(pos);
                              }
                              onChanged('sevvaiPositions', current.join(','));
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Janana Kala Thisai Dropdown (Full Width)
            RegisterComponents.buildDropdownField(
              label: 'Janana Kala Thisai Erupu',
              fieldKey: 'thisaiLord',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              items: thisaiOptions,
              validator: (val) => null,
            ),

            // Thisai Erupu Duration (YYYY, MM, DD in 1 Row)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: RegisterComponents.buildTextField(
                      label: 'YYYY',
                      fieldKey: 'thisaiYears',
                      formData: formData,
                      onChanged: onChanged,
                      currentStep: currentStep,
                      keyboardType: TextInputType.number,
                      hint: 'YYYY',
                      validator: (val) => null,
                      marginBottom: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RegisterComponents.buildTextField(
                      label: 'MM',
                      fieldKey: 'thisaiMonths',
                      formData: formData,
                      onChanged: onChanged,
                      currentStep: currentStep,
                      keyboardType: TextInputType.number,
                      hint: 'MM',
                      validator: (val) => null,
                      marginBottom: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RegisterComponents.buildTextField(
                      label: 'DD',
                      fieldKey: 'thisaiDays',
                      formData: formData,
                      onChanged: onChanged,
                      currentStep: currentStep,
                      keyboardType: TextInputType.number,
                      hint: 'DD',
                      validator: (val) => null,
                      marginBottom: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // --- SECTION 2: FAMILY DETAILS ---
        RegisterComponents.buildSectionHeader('Family Details'),
        RegisterComponents.buildFormCard(
          children: [
            RegisterComponents.buildTextField(
              label: 'Father Name',
              fieldKey: 'fatherName',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Mother Name',
              fieldKey: 'motherName',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Father Occupation',
              fieldKey: 'fatherOccupation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Mother Occupation',
              fieldKey: 'motherOccupation',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'No. of Sisters',
              fieldKey: 'noOfSisters',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.number,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Married Sisters',
              fieldKey: 'sistersMarried',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.number,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'No. of Brothers',
              fieldKey: 'noOfBrothers',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.number,
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Married Bros',
              fieldKey: 'brothersMarried',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              keyboardType: TextInputType.number,
              validator: (val) => null,
            ),
            RegisterComponents.buildChoiceSelector(
              label: 'Family Status',
              fieldKey: 'familyStatus',
              formData: formData,
              onChanged: onChanged,
              choices: const ['Affluent', 'Rich', 'Upper middle', 'Middle'],
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Family Property Details',
              fieldKey: 'familyProperty',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              maxLines: 3,
              hint: 'Describe house, land, or family property details...',
              validator: (val) => null,
            ),
            RegisterComponents.buildTextField(
              label: 'Native Place',
              fieldKey: 'native',
              formData: formData,
              onChanged: onChanged,
              currentStep: currentStep,
              validator: (val) => null,
            ),
          ],
        ),
      ],
    );
  }
}
