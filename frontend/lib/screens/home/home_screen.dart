import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/mock_data.dart';
import '../../core/localization/app_language.dart';
import '../../core/navigation/app_page_route.dart';
import '../profile_details/profile_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;

  const HomeScreen({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final profiles = ProfileDatabase.currentProfiles;

    // Filter Men and Women profiles
    final allMen = profiles.where((p) => p.gender.toLowerCase() == 'male').toList();
    final allWomen = profiles.where((p) => p.gender.toLowerCase() == 'female').toList();

    // Ensure 6 profiles for each list
    final List<Profile> displayMen = [];
    if (allMen.isNotEmpty) {
      while (displayMen.length < 6) {
        displayMen.addAll(allMen);
      }
    }
    final men6 = displayMen.take(6).toList();

    final List<Profile> displayWomen = [];
    if (allWomen.isNotEmpty) {
      while (displayWomen.length < 6) {
        displayWomen.addAll(allWomen);
      }
    }
    final women6 = displayWomen.take(6).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder<AppLanguage>(
        valueListenable: AppLanguageController.notifier,
        builder: (context, lang, _) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- TOP HERO LOGO BANNER ---
                  SizedBox(
                    width: double.infinity,
                    height: 165,
                    child: Image.asset(
                      'assets/logo.jpeg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.favorite_rounded,
                            color: AppColors.primary,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Verified Badge Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppLanguageController.text('kootam_verified'),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Welcome Title
                  Text(
                    AppLanguageController.text('welcome_title'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzel(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      AppLanguageController.text('home_subtitle'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- SECTION 1: MEN PROFILES (GROOMS) ---
                  _buildSectionHeader(
                    title: AppLanguageController.isTamil
                        ? AppLanguageController.text('men_profiles_section')
                        : 'Men Profiles (Grooms)',
                    icon: Icons.male_rounded,
                    color: AppColors.secondaryDark,
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 240,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: men6.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return _buildHorizontalProfileCard(context, men6[index], 'men-$index');
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // --- SECTION 2: WOMEN PROFILES (BRIDES) ---
                  _buildSectionHeader(
                    title: AppLanguageController.isTamil
                        ? AppLanguageController.text('women_profiles_section')
                        : 'Women Profiles (Brides)',
                    icon: Icons.female_rounded,
                    color: AppColors.primary,
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 240,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: women6.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return _buildHorizontalProfileCard(context, women6[index], 'women-$index');
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // --- VIEW ALL PROFILES BUTTON (Navigates to Horoscope Screen) ---
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary, width: 1.8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onNavigateToTab(1), // Navigates to Horoscope Screen
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.grid_view_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppLanguageController.isTamil
                                    ? AppLanguageController.text('view_all_profiles_button')
                                    : 'View All Profiles',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '6 ${AppLanguageController.text('profiles')}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildHorizontalProfileCard(BuildContext context, Profile profile, String tagPrefix) {
    return Container(
      width: 155,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. Full Image Background
          Positioned.fill(
            child: Hero(
              tag: 'profile-image-${profile.id}-$tagPrefix',
              child: Image.network(
                profile.profileImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 40, color: Colors.grey),
                ),
              ),
            ),
          ),

          // 2. Dark Gradient Overlay at bottom
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.3, 0.65, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.45),
                    Colors.black.withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),
          ),

          // 3. Tap Navigation Overlay
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    appPageRoute(
                      ProfileDetailsScreen(
                        profile: profile,
                        heroTag: 'profile-image-${profile.id}-$tagPrefix',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 4. Bottom Overlay Info Text (Name, Age, Occupation) - NO View Details Button
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.name,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 12,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        '${profile.age} ${AppLanguageController.text('yrs')}',
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.business_center_outlined,
                      size: 12,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        profile.occupation,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
