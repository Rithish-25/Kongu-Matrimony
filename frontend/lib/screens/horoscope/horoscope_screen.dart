import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/mock_data.dart';
import '../../core/navigation/app_page_route.dart';
import '../../core/localization/app_language.dart';

import '../../widgets/cards/empty_state_widget.dart';
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
  String _selectedGender = 'All';
  final String _selectedMinAge = '18';
  final String _selectedMaxAge = '40';
  final String _selectedMinHeight = 'Any';
  final String _selectedMaxHeight = 'Any';
  final String _selectedMaritalStatus = 'Any';
  final String _selectedReligion = 'Hindu';
  final String _selectedCaste = 'Any';
  final String _selectedKoottam = 'Any';
  final String _selectedEducation = 'Any';
  final String _selectedOccupation = 'Any';
  final String _selectedLocation = 'Any';

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
    if (mounted) {
      _performAdvancedSearch(ProfileDatabase.currentProfiles);
    }
  }

  void _initializeDefaultSearch() {
    final allProfiles = ProfileDatabase.currentProfiles;
    final minAge = int.tryParse(_selectedMinAge) ?? 18;
    final maxAge = int.tryParse(_selectedMaxAge) ?? 40;

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

      if (_selectedGender == 'Female' && profile.gender.toLowerCase() != 'female') return false;
      if (_selectedGender == 'Male' && profile.gender.toLowerCase() != 'male') return false;

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

    final results = allProfiles.where((profile) {
      final age = profile.age;
      if (age < minAge || age > maxAge) return false;

      final profileHeight = _parseHeightToInches(profile.heightText);
      if (profileHeight != null) {
        if (minHeight != null && profileHeight < minHeight) return false;
        if (maxHeight != null && profileHeight > maxHeight) return false;
      }

      if (_selectedGender == 'Female' && profile.gender.toLowerCase() != 'female') return false;
      if (_selectedGender == 'Male' && profile.gender.toLowerCase() != 'male') return false;

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
    });
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
          return ValueListenableBuilder<AppLanguage>(
            valueListenable: AppLanguageController.notifier,
            builder: (context, lang, _) {
              return _buildResultsView(context, theme);
            },
          );
        },
      ),
    );
  }

  Widget _buildResultsView(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results Info header title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM, vertical: 8.0),
          child: Text(
            '${_searchResults.length} ${AppLanguageController.text('horoscope_profiles')}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),

        // Gender Filter Pills Bar (All, Women, Men) - Scrollable to prevent right overflow
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
        const SizedBox(height: 4),

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. Full Card Image Background
          Positioned.fill(
            child: Hero(
              tag: 'profile-image-${profile.id}-searchresult',
              child: Image.network(
                profile.profileImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 50, color: Colors.grey),
                ),
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

          // 3. Top-Right "1/1" Pill Badge
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '1/1',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // 4. InkWell overlay for card tap navigation
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
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
