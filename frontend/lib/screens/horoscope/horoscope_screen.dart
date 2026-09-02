import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/mock_data.dart';
import '../../core/navigation/app_page_route.dart';

import '../../widgets/cards/empty_state_widget.dart';
import '../../widgets/buttons/primary_button.dart';
import '../profile_details/profile_details_screen.dart';

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => HoroscopeScreenState();
}

class HoroscopeScreenState extends State<HoroscopeScreen> {
  // Results view trigger
  bool _showResults = false;
  List<Profile> _searchResults = [];


  // Form State Values
  String _selectedMinAge = '20';
  String _selectedMaxAge = '30';
  String _selectedMinHeight = 'Any';
  String _selectedMaxHeight = 'Any';
  String _selectedMaritalStatus = 'Any';
  String _selectedReligion = 'Hindu';
  String _selectedCaste = 'Any';
  String _selectedKoottam = 'Any';
  String _selectedEducation = 'Any';
  String _selectedOccupation = 'Any';
  String _selectedLocation = 'Any';



  // Dropdown Lists
  final List<String> _ageOptions = List.generate(43, (i) => (18 + i).toString());
  
  final List<String> _heightOptions = [
    'Any', "5'0\"", "5'1\"", "5'2\"", "5'3\"", "5'4\"", "5'5\"", "5'6\"", "5'7\"", "5'8\"", "5'9\"", "5'10\"", "5'11\"", "6'0\"", "6'1\"", "6'2\""
  ];
  

  final List<String> _educationOptions = ['Any', 'Engineering', 'Medicine', 'Management', 'Science/Arts', 'Chartered Accountant'];
  final List<String> _occupationOptions = ['Any', 'Software Professional', 'Data Analytics', 'Business Owner', 'Medical Professional', 'Interior Designer', 'Pediatrician'];



  @override
  void initState() {
    super.initState();
    // Perform initial search synchronously to prevent screen flickering
    _initializeDefaultSearch();
    ProfileDatabase.notifier.addListener(_onDatabaseChanged);
  }

  @override
  void dispose() {
    ProfileDatabase.notifier.removeListener(_onDatabaseChanged);
    super.dispose();
  }

  void _onDatabaseChanged() {
    if (mounted && _showResults) {
      _performAdvancedSearch(ProfileDatabase.currentProfiles);
    }
  }

  void _initializeDefaultSearch() {
    final allProfiles = ProfileDatabase.currentProfiles;
    int minAge = int.parse(_selectedMinAge);
    int maxAge = int.parse(_selectedMaxAge);
    if (minAge > maxAge) {
      final temp = minAge;
      minAge = maxAge;
      maxAge = temp;
    }

    int? minHeight = _parseHeightToInches(_selectedMinHeight);
    int? maxHeight = _parseHeightToInches(_selectedMaxHeight);
    if (minHeight != null && maxHeight != null && minHeight > maxHeight) {
      final temp = minHeight;
      minHeight = maxHeight;
      maxHeight = temp;
    }

    final results = allProfiles.where((profile) {
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

      if (_selectedKoottam != 'Any' && profile.koottam != _selectedKoottam) return false;
      if (_selectedLocation != 'Any' && profile.location != _selectedLocation) return false;
      if (!_matchesEducation(profile)) return false;
      if (!_matchesOccupation(profile)) return false;

      return true;
    }).toList()
      ..sort((a, b) {
        if (a.isPremium != b.isPremium) {
          return a.isPremium ? -1 : 1;
        }
        return a.age.compareTo(b.age);
      });

    _searchResults = results;
    _showResults = true;
    
    final activeFilters = <String>['Age: $minAge-$maxAge'];
    if (minHeight != null || maxHeight != null) {
      activeFilters.add('Height: ${_selectedMinHeight == 'Any' ? 'Any' : _selectedMinHeight} - ${_selectedMaxHeight == 'Any' ? 'Any' : _selectedMaxHeight}');
    }
    if (_selectedMaritalStatus != 'Any') activeFilters.add('Status: $_selectedMaritalStatus');
    if (_selectedKoottam != 'Any') activeFilters.add('Koottam: $_selectedKoottam');
    if (_selectedLocation != 'Any') activeFilters.add('Location: $_selectedLocation');
    if (_selectedReligion != 'Any') activeFilters.add('Religion: $_selectedReligion');
    if (_selectedCaste != 'Any') activeFilters.add('Caste: $_selectedCaste');
    if (_selectedEducation != 'Any') activeFilters.add('Education: $_selectedEducation');
    if (_selectedOccupation != 'Any') activeFilters.add('Job: $_selectedOccupation');
    

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
        return true;
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
        return true;
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedMinAge = '20';
      _selectedMaxAge = '30';
      _selectedMinHeight = 'Any';
      _selectedMaxHeight = 'Any';
      _selectedMaritalStatus = 'Any';
      _selectedReligion = 'Hindu';
      _selectedCaste = 'Any';
      _selectedKoottam = 'Any';
      _selectedEducation = 'Any';
      _selectedOccupation = 'Any';
      _selectedLocation = 'Any';
      _showResults = false;
      _searchResults = [];

    });
  }

  // Trigger Advanced Filter Search
  void _performAdvancedSearch(List<Profile> allProfiles) {
    int minAge = int.parse(_selectedMinAge);
    int maxAge = int.parse(_selectedMaxAge);
    if (minAge > maxAge) {
      final temp = minAge;
      minAge = maxAge;
      maxAge = temp;
    }

    int? minHeight = _parseHeightToInches(_selectedMinHeight);
    int? maxHeight = _parseHeightToInches(_selectedMaxHeight);
    if (minHeight != null && maxHeight != null && minHeight > maxHeight) {
      final temp = minHeight;
      minHeight = maxHeight;
      maxHeight = temp;
    }

    final results = allProfiles.where((profile) {
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

      if (_selectedKoottam != 'Any' && profile.koottam != _selectedKoottam) return false;
      if (_selectedLocation != 'Any' && profile.location != _selectedLocation) return false;
      if (!_matchesEducation(profile)) return false;
      if (!_matchesOccupation(profile)) return false;

      return true;
    }).toList()
      ..sort((a, b) {
        if (a.isPremium != b.isPremium) {
          return a.isPremium ? -1 : 1;
        }
        return a.age.compareTo(b.age);
      });

    setState(() {
      _searchResults = results;
      _showResults = true;
      
      final activeFilters = <String>['Age: $minAge-$maxAge'];
      if (minHeight != null || maxHeight != null) {
        activeFilters.add('Height: ${_selectedMinHeight == 'Any' ? 'Any' : _selectedMinHeight} - ${_selectedMaxHeight == 'Any' ? 'Any' : _selectedMaxHeight}');
      }
      if (_selectedMaritalStatus != 'Any') activeFilters.add('Status: $_selectedMaritalStatus');
      if (_selectedKoottam != 'Any') activeFilters.add('Koottam: $_selectedKoottam');
      if (_selectedLocation != 'Any') activeFilters.add('Location: $_selectedLocation');
      if (_selectedReligion != 'Any') activeFilters.add('Religion: $_selectedReligion');
      if (_selectedCaste != 'Any') activeFilters.add('Caste: $_selectedCaste');
      if (_selectedEducation != 'Any') activeFilters.add('Education: $_selectedEducation');
      if (_selectedOccupation != 'Any') activeFilters.add('Job: $_selectedOccupation');
      

    });
  }



  bool handleBackPress() {
    if (_showResults) {
      setState(() {
        _showResults = false;
      });
      return true; // handled
    }
    return false; // propagate
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ValueListenableBuilder<List<Profile>>(
        valueListenable: ProfileDatabase.notifier,
        builder: (context, allProfiles, _) {
          if (_showResults) {
            return _buildResultsView(context, theme);
          }

          return Container(
            color: AppColors.background,
            child: _buildAdvancedSearchForm(context, theme, allProfiles),
          );
        },
      ),
    );
  }

  Widget _buildAdvancedSearchForm(BuildContext context, ThemeData theme, List<Profile> allProfiles) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: AppConstants.spacingM, right: AppConstants.spacingM, top: 12.0, bottom: 24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
              border: Border.all(color: AppColors.border),
              boxShadow: AppConstants.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Age Select
                _buildRangeDropdownFields(
                  label: 'Age',
                  startValue: _selectedMinAge,
                  startItems: _ageOptions,
                  onStartChanged: (val) {
                    if (val != null) setState(() => _selectedMinAge = val);
                  },
                  endValue: _selectedMaxAge,
                  endItems: _ageOptions,
                  onEndChanged: (val) {
                    if (val != null) setState(() => _selectedMaxAge = val);
                  },
                ),
                const Divider(color: AppColors.border, height: 1),

                // Height Select
                _buildRangeDropdownFields(
                  label: 'Height',
                  startValue: _selectedMinHeight,
                  startItems: _heightOptions,
                  onStartChanged: (val) {
                    if (val != null) setState(() => _selectedMinHeight = val);
                  },
                  endValue: _selectedMaxHeight,
                  endItems: _heightOptions,
                  onEndChanged: (val) {
                    if (val != null) setState(() => _selectedMaxHeight = val);
                  },
                ),
                const Divider(color: AppColors.border, height: 1),

                // Kootam Select
                _buildKootamSearchField(context),
                const Divider(color: AppColors.border, height: 1),

                // Education Select
                _buildDropdownField(
                  label: 'Education',
                  value: _selectedEducation,
                  items: _educationOptions,
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedEducation = val);
                  },
                ),
                const Divider(color: AppColors.border, height: 1),

                // Occupation Select
                _buildDropdownField(
                  label: 'Occupation',
                  value: _selectedOccupation,
                  items: _occupationOptions,
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedOccupation = val);
                  },
                ),
                const Divider(color: AppColors.border, height: 1),

                // Location Select (Search Dialog)
                _buildLocationSearchField(context),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search button
          PrimaryButton(
            text: 'Search Now',
            height: 48,
            icon: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
            onPressed: () => _performAdvancedSearch(allProfiles),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Reset Filters'),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_searchResults.isEmpty) {
                          _initializeDefaultSearch();
                        } else {
                          _showResults = true;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.secondaryDark, size: 20),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKootamSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              'Kootam',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _showKootamSearchDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedKoottam,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.secondaryDark,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showKootamSearchDialog(BuildContext context) {
    final List<String> defaultKootams = ['Any', 'Sellan', 'Sathandhai', 'Morasan', 'Thennan'];
    final List<String> otherKootams = [
      'Kannandhai',
      'Thorathan',
      'Koolan',
      'Maniyan',
      'Kadaian',
      'Kavalan',
      'Padharai',
      'Kuzhalaian',
      'Adhiraian',
      'Vilayan',
      'Anthuvan',
      'Pannai',
      'Sempoothan',
      'Vaanan',
      'Oothalar',
      'Sengunthar',
      'Thodalar',
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final List<String> filteredDefaults = defaultKootams
                .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            final List<String> filteredOthers = otherKootams
                .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Select Kootam',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 350,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Kootam...',
                        hintStyle: GoogleFonts.poppins(fontSize: 13),
                        prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 13),
                      onChanged: (val) {
                        setStateDialog(() {
                          searchQuery = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          if (filteredDefaults.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 4.0),
                              child: Text(
                                searchQuery.isEmpty ? 'Default Kootams' : 'Matches in Defaults',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            ...filteredDefaults.map((item) => ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                  title: Text(
                                    item,
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                  dense: true,
                                  trailing: _selectedKoottam == item
                                      ? const Icon(Icons.check, color: AppColors.primary, size: 18)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _selectedKoottam = item;
                                    });
                                    Navigator.of(dialogContext).pop();
                                  },
                                )),
                          ],
                          if (filteredOthers.isNotEmpty) ...[
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 4.0),
                              child: Text(
                                searchQuery.isEmpty ? 'Other Kootams' : 'Matches in Others',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            ...filteredOthers.map((item) => ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                  title: Text(
                                    item,
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                  dense: true,
                                  trailing: _selectedKoottam == item
                                      ? const Icon(Icons.check, color: AppColors.primary, size: 18)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _selectedKoottam = item;
                                    });
                                    Navigator.of(dialogContext).pop();
                                  },
                                )),
                          ],
                          if (filteredDefaults.isEmpty && filteredOthers.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'No Kootam found',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRangeDropdownFields({
    required String label,
    required String startValue,
    required List<String> startItems,
    required ValueChanged<String?> onStartChanged,
    required String endValue,
    required List<String> endItems,
    required ValueChanged<String?> onEndChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: startValue,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.secondaryDark, size: 18),
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textPrimary),
                    items: startItems.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                    onChanged: onStartChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'To',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: endValue,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.secondaryDark, size: 18),
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textPrimary),
                    items: endItems.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                    onChanged: onEndChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results Info header


        // Profiles grid
        Expanded(
          child: _searchResults.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.search_off_rounded,
                  title: 'No Profiles Found',
                  description: 'No profiles match your active filters. Try loosening your criteria or using a different ID.',
                  buttonText: 'Modify Filters',
                  onButtonPressed: () {
                    setState(() {
                      _showResults = false;
                    });
                  },
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.50,
                  ),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final profile = _searchResults[index];
                    return _buildGridProfileCard(context, profile);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildGridProfileCard(BuildContext context, Profile profile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Content Area - Clickable
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  appPageRoute(
                    ProfileDetailsScreen(
                      profile: profile,
                      heroTag: 'profile-image-${profile.id}-searchresult',
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Area
                  Expanded(
                    child: Hero(
                      tag: 'profile-image-${profile.id}-searchresult',
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(profile.profileImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Info Area
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Koottam
                        Row(
                          children: [
                            const Icon(
                              Icons.star_outline_rounded,
                              color: AppColors.secondary,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Koottam: ${profile.koottam}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Specs
                        Row(
                          children: [
                            const Icon(
                              Icons.straighten_rounded,
                              color: AppColors.textLight,
                              size: 13,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              profile.heightText,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.textLight,
                              size: 13,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                profile.location,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Button
                        SizedBox(
                          width: double.infinity,
                          height: 34,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                appPageRoute(
                                  ProfileDetailsScreen(
                                    profile: profile,
                                    heroTag: 'profile-image-${profile.id}-searchresult',
                                  ),
                                ),
                              );
                            },
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
                              'View Full Profile',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              'Location',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _showLocationSearchDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedLocation,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.secondaryDark,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationSearchDialog(BuildContext context) {
    final List<String> defaultLocations = ['Any', 'Coimbatore', 'Erode', 'Tiruppur', 'Salem', 'Namakkal'];
    final List<String> otherLocations = [
      'Karur',
      'Dindigul',
      'Trichy',
      'Madurai',
      'Chennai',
      'Bangalore',
      'Dharmapuri',
      'Krishnagiri',
      'Pollachi',
      'Udumalaipettai',
      'Gobichettipalayam',
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final List<String> filteredDefaults = defaultLocations
                .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            final List<String> filteredOthers = otherLocations
                .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Select Location',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 350,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Location...',
                        hintStyle: GoogleFonts.poppins(fontSize: 13),
                        prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 13),
                      onChanged: (val) {
                        setStateDialog(() {
                          searchQuery = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          if (filteredDefaults.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 4.0),
                              child: Text(
                                searchQuery.isEmpty ? 'Default Locations' : 'Matches in Defaults',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            ...filteredDefaults.map((item) => ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                  title: Text(
                                    item,
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                  dense: true,
                                  trailing: _selectedLocation == item
                                      ? const Icon(Icons.check, color: AppColors.primary, size: 18)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _selectedLocation = item;
                                    });
                                    Navigator.of(dialogContext).pop();
                                  },
                                )),
                          ],
                          if (filteredOthers.isNotEmpty) ...[
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 4.0),
                              child: Text(
                                searchQuery.isEmpty ? 'Other Locations' : 'Matches in Others',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            ...filteredOthers.map((item) => ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                  title: Text(
                                    item,
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                  dense: true,
                                  trailing: _selectedLocation == item
                                      ? const Icon(Icons.check, color: AppColors.primary, size: 18)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _selectedLocation = item;
                                    });
                                    Navigator.of(dialogContext).pop();
                                  },
                                )),
                          ],
                          if (filteredDefaults.isEmpty && filteredOthers.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'No Location found',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
