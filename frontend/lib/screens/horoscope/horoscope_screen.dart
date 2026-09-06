import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/mock_data.dart';
import '../../core/navigation/app_page_route.dart';
import '../../core/localization/app_language.dart';

import '../../widgets/cards/empty_state_widget.dart';
import '../../widgets/app_profile_image.dart';
import '../profile_details/profile_details_screen.dart';
import '../../widgets/auth_required_dialog.dart';

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => HoroscopeScreenState();
}

class HoroscopeScreenState extends State<HoroscopeScreen> {
  List<Profile> _searchResults = [];

  // Form State Values
  String _selectedGender = 'All';
  String _selectedMinAge = '18';
  String _selectedMaxAge = '40';
  String _selectedMinHeight = 'Any';
  String _selectedMaxHeight = 'Any';
  String _selectedMaritalStatus = 'Any';
  String _selectedReligion = 'Hindu';
  String _selectedCaste = 'Any';
  String _selectedKoottam = 'Any';
  String _selectedEducation = 'Any';
  String _selectedOccupation = 'Any';
  String _selectedLocation = 'Any';
  String _selectedCountry = 'Any';
  String _selectedHoroscopeType = "பொருட்படுத்தவில்லை";
  String _searchQuery = '';

  static const List<String> horoscopeTypeOptions = [
    "பொருட்படுத்தவில்லை",
    'ராகு / கேது',
    'செவ்வாய்',
    'Sevvai / Pariharam (2)',
    'Sevvai / Pariharam (4)',
    'Sevvai / Pariharam (7)',
    'Sevvai / Pariharam (8)',
    'Sevvai / Pariharam (12)',
    'சுத்த ஜாதகம்',
    'ராகு / கேது / செவ்வாய்',
  ];

  static const List<String> kootamOptions = [
    'Any',
    'செம்பூத்தன்',
    'கண்ணந்தை',
    'பவளன்',
    'புல்லன்',
    'பொருளந்தை',
    'ஓதளன்',
    'ஆடை',
    'ஆவனை',
    'ஆந்தை',
    'ஆதிரை',
    'ஆயிரவன்',
    'ஈசன்',
    'எண்ணை',
    'கடை',
    'காரி',
    'கிளை',
    'கொல்லன்',
    'கோரை',
    'கோவன்',
    'மூலன்',
    'முத்தன்',
    'நீலன்',
    'பண்ணை',
    'பாண்டியன்',
    'பெரியாண்டி',
    'பிள்ளன்',
    'பூசன்',
    'செங்காணி',
    'செங்குந்தர்',
    'சேர்வை',
    'தாழன்',
    'தோரட்டான்',
    'வண்டிக்காரன்',
    'வெள்ளி',
    'விளையன்',
    'இதர',
  ];

  @override
  void initState() {
    super.initState();
    // Perform initial search synchronously to prevent screen flickering
    _initializeDefaultSearch();
    ProfileDatabase.notifier.addListener(_onDatabaseChanged);
    ProfileDatabase.userProfileNotifier.addListener(_onDatabaseChanged);
    ProfileDatabase.authNotifier.addListener(_onDatabaseChanged);
  }

  @override
  void dispose() {
    ProfileDatabase.notifier.removeListener(_onDatabaseChanged);
    ProfileDatabase.userProfileNotifier.removeListener(_onDatabaseChanged);
    ProfileDatabase.authNotifier.removeListener(_onDatabaseChanged);
    super.dispose();
  }

  void _onDatabaseChanged() {
    if (mounted) {
      _performAdvancedSearch(ProfileDatabase.currentProfiles);
    }
  }

  void _initializeDefaultSearch() {
    _performAdvancedSearch(ProfileDatabase.currentProfiles);
  }

  int? _parseHeightToInches(String height) {
    if (height == 'Any') return null;
    final exp = RegExp(r"(\d+)'(\d+)");
    final match = exp.firstMatch(height);
    if (match == null) return null;

    final feet = int.tryParse(match.group(1) ?? '');
    final inches = int.tryParse(match.group(2) ?? '');
    if (feet == null || inches == null) return null;

    return (feet * 12) + inches;
  }

  bool _matchesEducation(Profile profile) {
    if (_selectedEducation == 'Any') return true;

    final education = profile.education.toLowerCase();
    switch (_selectedEducation) {
      case 'Engineering':
        return education.contains('b.e.') || education.contains('b.tech') || education.contains('engineer');
      case 'Medicine':
        return education.contains('m.d.') || education.contains('medical') || education.contains('mbbs');
      case 'Management':
        return education.contains('mba') || education.contains('management');
      case 'Science/Arts':
        return education.contains('b.sc') || education.contains('b.a') || education.contains('arts') || education.contains('science');
      case 'Chartered Accountant':
        return education.contains('ca') || education.contains('chartered');
      default:
        return education.contains(_selectedEducation.toLowerCase());
    }
  }

  bool _matchesOccupation(Profile profile) {
    if (_selectedOccupation == 'Any') return true;

    final occupation = profile.occupation.toLowerCase();
    switch (_selectedOccupation) {
      case 'Software Professional':
        return occupation.contains('software') || occupation.contains('tech') || occupation.contains('engineer');
      case 'Data Analytics':
        return occupation.contains('data') || occupation.contains('analytics');
      case 'Business Owner':
        return occupation.contains('business') || occupation.contains('export') || occupation.contains('manager');
      case 'Medical Professional':
        return occupation.contains('doctor') || occupation.contains('medical') || occupation.contains('pediatrician') || occupation.contains('consultant');
      case 'Interior Designer':
        return occupation.contains('interior') || occupation.contains('designer') || occupation.contains('architect');
      case 'Pediatrician':
        return occupation.contains('pediatrician');
      default:
        return occupation.contains(_selectedOccupation.toLowerCase());
    }
  }

  bool _matchesHoroscopeType(Profile profile) {
    if (_selectedHoroscopeType == "பொருட்படுத்தவில்லை" ||
        _selectedHoroscopeType == "doesn't matter" ||
        _selectedHoroscopeType == 'Any') {
      return true;
    }

    final dosham = profile.dosham.toLowerCase();
    final horoType = _selectedHoroscopeType.toLowerCase();

    if (horoType.contains('சுத்த') || horoType.contains('sutha')) {
      return dosham.contains('no dosham') ||
          dosham.contains('sutha') ||
          dosham.contains('none') ||
          dosham.contains('illai');
    }
    if (horoType == 'ராகு / கேது' || horoType == 'raagu / kethu') {
      return dosham.contains('ragu') || dosham.contains('raagu') || dosham.contains('kethu');
    }
    if (horoType == 'செவ்வாய்' || horoType == 'sevvai') {
      return (dosham.contains('sevvai') || dosham.contains('chevvai')) &&
          !dosham.contains('illai') &&
          !dosham.contains('no ');
    }
    if (horoType.contains('ராகு / கேது / செவ்வாய்') || horoType.contains('raagu / kethu / sevvai')) {
      final isRaguKethu = dosham.contains('ragu') || dosham.contains('raagu') || dosham.contains('kethu');
      final isSevvai = (dosham.contains('sevvai') || dosham.contains('chevvai')) &&
          !dosham.contains('illai') &&
          !dosham.contains('no ');
      return isRaguKethu || isSevvai;
    }

    return true;
  }

  // Trigger Advanced Filter Search
  void _performAdvancedSearch(List<Profile> allProfiles) {
    final minAge = int.tryParse(_selectedMinAge) ?? 18;
    final maxAge = int.tryParse(_selectedMaxAge) ?? 40;

    int? minHeight = _parseHeightToInches(_selectedMinHeight);
    int? maxHeight = _parseHeightToInches(_selectedMaxHeight);
    if (minHeight != null && maxHeight != null && minHeight > maxHeight) {
      final temp = minHeight;
      minHeight = maxHeight;
      maxHeight = temp;
    }

    final bool isLoggedIn = ProfileDatabase.isLoggedIn;
    final String rawGender = ProfileDatabase.userProfileNotifier.value.userGender.trim().toLowerCase();
    final String effectiveUserGender = (isLoggedIn && rawGender.isEmpty) ? 'male' : rawGender;

    final results = allProfiles.where((profile) {
      final pGender = profile.gender.trim().toLowerCase();

      // ABSOLUTE RULE: When logged in, NEVER show same-gender profiles!
      if (isLoggedIn) {
        if (effectiveUserGender == 'female' || effectiveUserGender.contains('female')) {
          if (pGender != 'male') return false;
        } else {
          if (pGender != 'female') return false;
        }

        if (_selectedGender == 'Female' && pGender != 'female') return false;
        if (_selectedGender == 'Male' && pGender != 'male') return false;
      } else {
        if (_selectedGender == 'Female' && pGender != 'female') return false;
        if (_selectedGender == 'Male' && pGender != 'male') return false;
      }

      // Quick Search Query
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.trim().toLowerCase();
        final nameMatch = profile.name.toLowerCase().contains(q);
        final rasiMatch = profile.horoscopeRasi.toLowerCase().contains(q);
        final starMatch = profile.horoscopeStar.toLowerCase().contains(q);
        final kootamMatch = profile.koottam.toLowerCase().contains(q);
        final locMatch = profile.location.toLowerCase().contains(q);
        final eduMatch = profile.education.toLowerCase().contains(q);
        final occMatch = profile.occupation.toLowerCase().contains(q);
        if (!nameMatch && !rasiMatch && !starMatch && !kootamMatch && !locMatch && !eduMatch && !occMatch) {
          return false;
        }
      }

      final age = profile.age;
      if (age < minAge || age > maxAge) return false;

      final profileHeight = _parseHeightToInches(profile.heightText);
      if (profileHeight != null) {
        if (minHeight != null && profileHeight < minHeight) return false;
        if (maxHeight != null && profileHeight > maxHeight) return false;
      }

      if (_selectedMaritalStatus != 'Any' && _selectedMaritalStatus != 'Never Married') return false;
      if (_selectedReligion != 'Any' && _selectedReligion != 'Hindu') return false;
      if (_selectedCaste != 'Any' && !profile.subsect.toLowerCase().contains(_selectedCaste.toLowerCase())) return false;

      // Avoid to Kootam Rule: If a Kootam is selected, exclude profiles matching that Kootam
      if (_selectedKoottam != 'Any' && profile.koottam.toLowerCase() == _selectedKoottam.toLowerCase()) return false;

      if (_selectedLocation != 'Any' && !profile.location.toLowerCase().contains(_selectedLocation.toLowerCase())) return false;
      if (_selectedCountry != 'Any' && !profile.location.toLowerCase().contains(_selectedCountry.toLowerCase())) return false;
      if (!_matchesEducation(profile)) return false;
      if (!_matchesOccupation(profile)) return false;
      if (!_matchesHoroscopeType(profile)) return false;

      return true;
    }).toList()
      ..sort((a, b) {
        if (a.isPremium != b.isPremium) {
          return a.isPremium ? -1 : 1;
        }
        return a.age.compareTo(b.age);
      });

    if (mounted) {
      setState(() {
        _searchResults = results;
      });
    } else {
      _searchResults = results;
    }
  }

  // --- Searchable Dropdown Modal ---
  void _showSearchableDropdownModal({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredOptions = options.where((opt) {
              return opt.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Select $title',
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: TextField(
                        onChanged: (val) {
                          setModalState(() {
                            searchQuery = val;
                          });
                        },
                        style: GoogleFonts.roboto(fontSize: 13.5, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search $title...',
                          hintStyle: GoogleFonts.roboto(fontSize: 13, color: const Color(0xFF94A3B8)),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  Expanded(
                    child: filteredOptions.isEmpty
                        ? Center(
                            child: Text(
                              'No matching options found',
                              style: GoogleFonts.roboto(fontSize: 13, color: AppColors.textSecondary),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filteredOptions.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            itemBuilder: (context, index) {
                              final item = filteredOptions[index];
                              final isSelected = item == currentValue;
                              return ListTile(
                                dense: true,
                                title: Text(
                                  item,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
                                    : null,
                                onTap: () {
                                  onSelected(item);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownField({
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF9F6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.roboto(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  // --- Filter Modal Sheet ---
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setFilterState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.88,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFFAF8F5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Right Cross (Close) Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded, color: AppColors.primary, size: 20),
                            padding: EdgeInsets.zero,
                            tooltip: 'Close',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Filter Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: AppConstants.cardShadow,
                        ),
                        child: Column(
                          children: [
                            // 1. Age Row
                            Row(
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: Text('Age', style: GoogleFonts.roboto(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                ),
                                Expanded(
                                  child: _buildDropdownField(
                                    value: _selectedMinAge,
                                    onTap: () {
                                      _showSearchableDropdownModal(
                                        title: 'Min Age',
                                        options: List.generate(43, (i) => '${18 + i}'),
                                        currentValue: _selectedMinAge,
                                        onSelected: (val) {
                                          setFilterState(() => _selectedMinAge = val);
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('To', style: GoogleFonts.roboto(fontSize: 12.5, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  child: _buildDropdownField(
                                    value: _selectedMaxAge,
                                    onTap: () {
                                      _showSearchableDropdownModal(
                                        title: 'Max Age',
                                        options: List.generate(43, (i) => '${18 + i}'),
                                        currentValue: _selectedMaxAge,
                                        onSelected: (val) {
                                          setFilterState(() => _selectedMaxAge = val);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 22, color: Color(0xFFF1F5F9)),

                            // 2. Height Row
                            Row(
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: Text('Height', style: GoogleFonts.roboto(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                ),
                                Expanded(
                                  child: _buildDropdownField(
                                    value: _selectedMinHeight,
                                    onTap: () {
                                      _showSearchableDropdownModal(
                                        title: 'Min Height',
                                        options: ['Any', "4'6\"", "4'7\"", "4'8\"", "4'9\"", "4'10\"", "4'11\"", "5'0\"", "5'1\"", "5'2\"", "5'3\"", "5'4\"", "5'5\"", "5'6\"", "5'7\"", "5'8\"", "5'9\"", "5'10\"", "5'11\"", "6'0\"", "6'1\"", "6'2\""],
                                        currentValue: _selectedMinHeight,
                                        onSelected: (val) {
                                          setFilterState(() => _selectedMinHeight = val);
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('To', style: GoogleFonts.roboto(fontSize: 12.5, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  child: _buildDropdownField(
                                    value: _selectedMaxHeight,
                                    onTap: () {
                                      _showSearchableDropdownModal(
                                        title: 'Max Height',
                                        options: ['Any', "4'6\"", "4'7\"", "4'8\"", "4'9\"", "4'10\"", "4'11\"", "5'0\"", "5'1\"", "5'2\"", "5'3\"", "5'4\"", "5'5\"", "5'6\"", "5'7\"", "5'8\"", "5'9\"", "5'10\"", "5'11\"", "6'0\"", "6'1\"", "6'2\""],
                                        currentValue: _selectedMaxHeight,
                                        onSelected: (val) {
                                          setFilterState(() => _selectedMaxHeight = val);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 22, color: Color(0xFFF1F5F9)),

                              // 3. Avoid to Kootam Row
                              Row(
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Kootam to avoid', style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  ),
                                  Expanded(
                                    child: _buildDropdownField(
                                      value: _selectedKoottam,
                                      onTap: () {
                                        _showSearchableDropdownModal(
                                          title: 'Kootam to avoid',
                                          options: kootamOptions,
                                          currentValue: _selectedKoottam,
                                          onSelected: (val) {
                                            setFilterState(() => _selectedKoottam = val);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 22, color: Color(0xFFF1F5F9)),

                              // Horoscope Type Row
                              Row(
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Text('Horoscope type', style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  ),
                                  Expanded(
                                    child: _buildDropdownField(
                                      value: _selectedHoroscopeType,
                                      onTap: () {
                                        _showSearchableDropdownModal(
                                          title: 'Horoscope type',
                                          options: horoscopeTypeOptions,
                                          currentValue: _selectedHoroscopeType,
                                          onSelected: (val) {
                                            setFilterState(() => _selectedHoroscopeType = val);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 22, color: Color(0xFFF1F5F9)),

                            // 4. Education Row
                            Row(
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: Text('Education', style: GoogleFonts.roboto(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                ),
                                Expanded(
                                  child: _buildDropdownField(
                                    value: _selectedEducation,
                                    onTap: () {
                                      _showSearchableDropdownModal(
                                        title: 'Education',
                                        options: ['Any', 'Engineering', 'Medicine', 'Management', 'Science/Arts', 'Chartered Accountant', 'Computer Science / IT', 'Law', 'Diploma', 'Other'],
                                        currentValue: _selectedEducation,
                                        onSelected: (val) {
                                          setFilterState(() => _selectedEducation = val);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 22, color: Color(0xFFF1F5F9)),

                            // 5. Occupation Row
                            Row(
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: Text('Occupation', style: GoogleFonts.roboto(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                ),
                                Expanded(
                                  child: _buildDropdownField(
                                    value: _selectedOccupation,
                                    onTap: () {
                                      _showSearchableDropdownModal(
                                        title: 'Occupation',
                                        options: ['Any', 'Software Professional', 'Data Analytics', 'Business Owner', 'Medical Professional', 'Interior Designer', 'Pediatrician', 'Civil Engineer', 'Banking & Finance', 'Other'],
                                        currentValue: _selectedOccupation,
                                        onSelected: (val) {
                                          setFilterState(() => _selectedOccupation = val);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 22, color: Color(0xFFF1F5F9)),

                             // 6. Location Row
                            Row(
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: Text('Location', style: GoogleFonts.roboto(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                ),
                                Expanded(
                                  child: _buildDropdownField(
                                    value: _selectedLocation,
                                    onTap: () {
                                      _showSearchableDropdownModal(
                                        title: 'Location',
                                        options: ['Any', 'Erode', 'Coimbatore', 'Salem', 'Tiruppur', 'Namakkal', 'Karur', 'Chennai', 'Madurai', 'Trichy', 'Bangalore', 'Other'],
                                        currentValue: _selectedLocation,
                                        onSelected: (val) {
                                          setFilterState(() => _selectedLocation = val);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 22, color: Color(0xFFF1F5F9)),

                            // 7. Country Row
                            Row(
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: Text('Country', style: GoogleFonts.roboto(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                ),
                                Expanded(
                                  child: _buildDropdownField(
                                    value: _selectedCountry,
                                    onTap: () {
                                      _showSearchableDropdownModal(
                                        title: 'Country',
                                        options: ['Any', 'India', 'United States', 'United Kingdom', 'Canada', 'Australia', 'United Arab Emirates', 'Singapore', 'Malaysia', 'Germany', 'Qatar', 'Kuwait', 'Saudi Arabia', 'Oman', 'Other'],
                                        currentValue: _selectedCountry,
                                        onSelected: (val) {
                                          setFilterState(() => _selectedCountry = val);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Search Now Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _performAdvancedSearch(ProfileDatabase.currentProfiles);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.search_rounded, size: 20),
                          label: Text(
                            'Search Now',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Bottom Action: Reset Filters
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton(
                          onPressed: () {
                            setFilterState(() {
                              _selectedMinAge = '18';
                              _selectedMaxAge = '40';
                              _selectedMinHeight = 'Any';
                              _selectedMaxHeight = 'Any';
                              _selectedKoottam = 'Any';
                              _selectedEducation = 'Any';
                              _selectedOccupation = 'Any';
                              _selectedLocation = 'Any';
                              _selectedCountry = 'Any';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Reset Filters',
                            style: GoogleFonts.roboto(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool handleBackPress() {
    return false; // propagate
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ValueListenableBuilder<List<Profile>>(
        valueListenable: ProfileDatabase.notifier,
        builder: (context, allProfiles, _) {
          return ValueListenableBuilder<UserProfileState>(
            valueListenable: ProfileDatabase.userProfileNotifier,
            builder: (context, userProfile, _) {
              return ValueListenableBuilder<AppLanguage>(
                valueListenable: AppLanguageController.notifier,
                builder: (context, lang, _) {
                  return _buildResultsView(context, theme, userProfile);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildResultsView(BuildContext context, ThemeData theme, UserProfileState userProfile) {
    final bool showGenderChips = !ProfileDatabase.isLoggedIn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results Info header title with Search & Filter Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(AppConstants.spacingM, 8.0, AppConstants.spacingM, 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_searchResults.length} ${AppLanguageController.text('horoscope_profiles')}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                onPressed: () => _showFilterBottomSheet(context),
                icon: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 22),
                tooltip: 'Filter',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        // Search Input UI
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM, vertical: 4.0),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
            ),
            child: TextField(
              onChanged: (val) {
                _searchQuery = val;
                _performAdvancedSearch(ProfileDatabase.currentProfiles);
              },
              style: GoogleFonts.poppins(fontSize: 12.5, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search by Name, Rasi, Star, Koottam...',
                hintStyle: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Gender Filter Pills Bar (All, Women, Men) - SHOWN ONLY FOR FREE NON-LOGGED-IN USERS
        if (showGenderChips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM, vertical: 4.0),
            child: Row(
              children: [
                _buildGenderFilterChip('All', AppLanguageController.text('all_profiles')),
                const SizedBox(width: 6),
                _buildGenderFilterChip('Male', AppLanguageController.text('men_profiles')),
                const SizedBox(width: 6),
                _buildGenderFilterChip('Female', AppLanguageController.text('women_profiles')),
              ],
            ),
          ),
        if (showGenderChips) const SizedBox(height: 4),

        // Profiles grid with smooth AnimatedSwitcher transition
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
            child: _searchResults.isEmpty
                ? EmptyStateWidget(
                    key: const ValueKey('empty_results'),
                    icon: Icons.search_off_rounded,
                    title: 'No Profiles Found',
                    description: 'No profiles match your selected filter.',
                  )
                : GridView.builder(
                    key: ValueKey('grid-$_selectedGender-${_searchResults.length}'),
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM, vertical: 4.0),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final profile = _searchResults[index];
                      return _buildGridProfileCard(context, profile);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderFilterChip(String value, String label) {
    final isSelected = _selectedGender == value;

    return GestureDetector(
      onTap: () {
        if (_selectedGender != value) {
          setState(() {
            _selectedGender = value;
            _performAdvancedSearch(ProfileDatabase.currentProfiles);
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.8),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
          child: Text(label),
        ),
      ),
    );
  }

  void _openProfile(BuildContext context, Profile profile) {
    if (!ProfileDatabase.isLoggedIn) {
      AuthRequiredDialog.show(context, featureName: 'Profile Details');
      return;
    }
    Navigator.of(context).push(
      appPageRoute(
        ProfileDetailsScreen(
          profile: profile,
          heroTag: 'profile-image-${profile.id}-searchresult',
        ),
      ),
    );
  }

  Widget _buildGridProfileCard(BuildContext context, Profile profile) {
    final translatedOccupation = AppLanguageController.text(profile.occupation.toLowerCase());
    final displayOccupation = (translatedOccupation == profile.occupation.toLowerCase())
        ? profile.occupation
        : translatedOccupation;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6), width: 0.8),
        boxShadow: AppConstants.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. Full Card Image Background
          Positioned.fill(
            child: Hero(
              tag: 'profile-image-${profile.id}-searchresult',
              child: AppProfileImage(
                imageUrl: profile.profileImageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Dark Gradient Overlay at the bottom
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.35, 0.65, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.45),
                    Colors.black.withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),
          ),

          // 4. InkWell overlay for card tap navigation
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _openProfile(context, profile),
              ),
            ),
          ),

          // 5. Bottom Overlay Info & Action Buttons
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Name Line
                Text(
                  AppLanguageController.text(profile.name),
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),

                // 2. Age Line (Second Line under Name)
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white70,
                      size: 11.5,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${profile.age} ${AppLanguageController.text('yrs')}',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                // 3. Profession Line (Third Line)
                Row(
                  children: [
                    const Icon(
                      Icons.work_outline_rounded,
                      color: Colors.white70,
                      size: 11.5,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        displayOccupation,
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Single Full Width Button: View Full Profile
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () => _openProfile(context, profile),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      AppLanguageController.text('view_full_profile'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
