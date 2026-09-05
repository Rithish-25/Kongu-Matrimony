import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/mock_data.dart';
import '../../core/localization/app_language.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/app_profile_image.dart';
import '../../widgets/auth_required_dialog.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final Profile profile;
  final String heroTag;

  const ProfileDetailsScreen({
    super.key,
    required this.profile,
    required this.heroTag,
  });

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  int _currentImageIndex = 0;
  late PageController _pageController;
  late List<Profile> _profiles;
  late int _initialIndex;
  double _currentPage = 0.0;
  int _lastActivePage = 0;
  final Map<String, double> _pageScrollOffsets = {};

  @override
  void initState() {
    super.initState();
    _profiles = ProfileDatabase.currentProfiles;
    _initialIndex = _profiles.indexWhere((p) => p.id == widget.profile.id);
    if (_initialIndex == -1) {
      _profiles = [widget.profile, ..._profiles];
      _initialIndex = 0;
    }
    _lastActivePage = _initialIndex;
    _currentPage = _initialIndex.toDouble();
    _pageController = PageController(initialPage: _initialIndex);
    _pageController.addListener(() {
      int activePage = _pageController.page?.round() ?? _initialIndex;
      if (activePage != _lastActivePage) {
        setState(() {
          _lastActivePage = activePage;
          _currentImageIndex = 0;
        });
      }
      setState(() {
        _currentPage = _pageController.page ?? _initialIndex.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppLanguageController.text(_profiles[_lastActivePage].name),
        isMainScreen: false,
        showNotification: true,
      ),
      body: ValueListenableBuilder<UserProfileState>(
        valueListenable: ProfileDatabase.userProfileNotifier,
        builder: (context, userState, _) {
          return ValueListenableBuilder<AppLanguage>(
            valueListenable: AppLanguageController.notifier,
            builder: (context, lang, _) {
              return PageView.builder(
                controller: _pageController,
                itemCount: _profiles.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final profile = _profiles[index];
              final currentProfileState = ProfileDatabase.currentProfiles.firstWhere(
                (p) => p.id == profile.id,
                orElse: () => profile,
              );
              final isFav = currentProfileState.isFavourite;
              final interest = currentProfileState.interestStatus;

              final profileImages = [
                currentProfileState.profileImageUrl,
              ];

              final scrollOffset = _pageScrollOffsets[profile.id] ?? 0.0;

              return Stack(
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification) {
                        setState(() {
                          _pageScrollOffsets[profile.id] = notification.metrics.pixels;
                        });
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Stack(
                        children: [
                          Transform.translate(
                            offset: Offset(0, scrollOffset),
                            child: _buildImageHeader(context, currentProfileState, profileImages, isFav),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 420),
                              _buildWaveBannerOverlay(currentProfileState),
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.spacingM,
                                  vertical: AppConstants.spacingM,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionCard(
                                      title: AppLanguageController.text('basic_information'),
                                      icon: Icons.person_outline_rounded,
                                      items: [
                                        _GridItem(AppLanguageController.text('name'), profile.name),
                                        _GridItem(
                                          AppLanguageController.text('gender'),
                                          profile.gender.toLowerCase() == 'female'
                                              ? AppLanguageController.text('female')
                                              : AppLanguageController.text('male'),
                                        ),
                                        _GridItem(
                                          AppLanguageController.text('marital_status'),
                                          profile.maritalStatus.contains('Never')
                                              ? AppLanguageController.text('single_never_married')
                                              : profile.maritalStatus,
                                        ),
                                        _GridItem(
                                          AppLanguageController.text('dob'),
                                          profile.dob,
                                        ),
                                        _GridItem(
                                          AppLanguageController.text('time_of_birth'),
                                          profile.timeOfBirth,
                                        ),
                                        _GridItem(AppLanguageController.text('age'), '${profile.age} ${AppLanguageController.text('yrs')}'),
                                        _GridItem(
                                          AppLanguageController.text('mobile'),
                                          userState.plan.toLowerCase().contains('free')
                                              ? (profile.mobile.length >= 8 ? '${profile.mobile.substring(0, 7)} *****' : '+91 98*** *****')
                                              : profile.mobile,
                                          isLocked: userState.plan.toLowerCase().contains('free'),
                                          onTapLocked: () => _showUpgradePlanModal(context),
                                        ),
                                        _GridItem(
                                          AppLanguageController.text('email'),
                                          userState.plan.toLowerCase().contains('free')
                                              ? (profile.email.contains('@') ? '${profile.email.split('@')[0].substring(0, profile.email.split('@')[0].length > 3 ? 3 : 1)}****@${profile.email.split('@')[1]}' : 'user****@gmail.com')
                                              : profile.email,
                                          isLocked: userState.plan.toLowerCase().contains('free'),
                                          onTapLocked: () => _showUpgradePlanModal(context),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildSectionCard(
                                      title: AppLanguageController.text('physical_attributes'),
                                      icon: Icons.accessibility_new_rounded,
                                      items: [
                                        _GridItem(AppLanguageController.text('height'), profile.heightText),
                                        _GridItem(AppLanguageController.text('weight'), profile.weightText),
                                        _GridItem(AppLanguageController.text('blood_group'), profile.bloodGroup),
                                        _GridItem(AppLanguageController.text('complexion'), AppLanguageController.text(profile.complexion)),
                                        _GridItem(AppLanguageController.text('body_type'), AppLanguageController.text(profile.bodyType)),
                                        _GridItem(AppLanguageController.text('disability'), AppLanguageController.text(profile.disability)),
                                      ],
                                    ),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildHoroscopeCard(theme, profile),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildSectionCard(
                                      title: AppLanguageController.text('habits_lifestyle'),
                                      icon: Icons.restaurant_rounded,
                                      items: [
                                        _GridItem(
                                          AppLanguageController.text('eating_habits'),
                                          profile.eatingHabits == 'Vegetarian'
                                              ? AppLanguageController.text('vegetarian')
                                              : AppLanguageController.text('non_vegetarian'),
                                        ),
                                        _GridItem(AppLanguageController.text('smoking_habits'), AppLanguageController.text(profile.smokingHabits)),
                                        _GridItem(AppLanguageController.text('drinking_habits'), AppLanguageController.text(profile.drinkingHabits)),
                                        _GridItem(AppLanguageController.text('hobbies'), AppLanguageController.text(profile.hobbies)),
                                      ],
                                    ),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildSectionCard(
                                      title: AppLanguageController.text('family_details'),
                                      icon: Icons.family_restroom_rounded,
                                      items: [
                                        _GridItem(AppLanguageController.text('koottam'), AppLanguageController.text(profile.koottam)),
                                        _GridItem(AppLanguageController.text('subsect'), AppLanguageController.text(profile.subsect)),
                                        _GridItem(
                                          AppLanguageController.text('father_occupation'),
                                          AppLanguageController.text(profile.fatherOccupation),
                                        ),
                                        _GridItem(
                                          AppLanguageController.text('mother_occupation'),
                                          AppLanguageController.text(profile.motherOccupation),
                                        ),
                                        _GridItem(AppLanguageController.text('brothers'), AppLanguageController.text(profile.brothersCount)),
                                        _GridItem(AppLanguageController.text('sisters'), AppLanguageController.text(profile.sistersCount)),
                                        _GridItem(
                                          AppLanguageController.text('ancestral_origin'),
                                          AppLanguageController.text(profile.ancestralOrigin),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildSectionCard(
                                      title: AppLanguageController.text('education_professional'),
                                      icon: Icons.school_outlined,
                                      items: [
                                        _GridItem(AppLanguageController.text('education'), AppLanguageController.text(profile.education)),
                                        _GridItem(
                                          AppLanguageController.text('education_detail'),
                                          AppLanguageController.text(profile.educationDetail),
                                        ),
                                        _GridItem(AppLanguageController.text('occupation'), AppLanguageController.text(profile.occupation)),
                                        _GridItem(AppLanguageController.text('employed_in'), AppLanguageController.text(profile.employedIn)),
                                        _GridItem(
                                          AppLanguageController.text('annual_income'),
                                          AppLanguageController.text(profile.annualIncome),
                                        ),
                                        _GridItem(AppLanguageController.text('work_location'), AppLanguageController.text(profile.workLocation)),
                                      ],
                                    ),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildSectionCard(
                                      title: AppLanguageController.text('location_contact'),
                                      icon: Icons.location_on_outlined,
                                      items: [
                                        _GridItem(AppLanguageController.text('native_place'), AppLanguageController.text(profile.nativePlace)),
                                        _GridItem(AppLanguageController.text('city'), AppLanguageController.text(profile.city)),
                                        _GridItem(AppLanguageController.text('district'), AppLanguageController.text(profile.district)),
                                        _GridItem(AppLanguageController.text('state'), AppLanguageController.text(profile.state)),
                                        _GridItem(AppLanguageController.text('country'), AppLanguageController.text(profile.country)),
                                      ],
                                    ),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildSectionCard(
                                      title: AppLanguageController.text('partner_expectations'),
                                      icon: Icons.tune_rounded,
                                      items: [
                                        _GridItem(AppLanguageController.text('pref_age'), profile.prefAgeRange),
                                        _GridItem(AppLanguageController.text('pref_height'), profile.prefHeightRange),
                                        _GridItem(AppLanguageController.text('pref_education'), profile.prefEducation),
                                        _GridItem(AppLanguageController.text('pref_occupation'), profile.prefOccupation),
                                        _GridItem(AppLanguageController.text('pref_location'), profile.prefLocation),
                                      ],
                                    ),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildTextCard(
                                      title: AppLanguageController.text('about_bio'),
                                      icon: Icons.person_pin_rounded,
                                      content: profile.bio,
                                    ),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildTextCard(
                                      title: AppLanguageController.text('partner_expectations'),
                                      icon: Icons.favorite_border_rounded,
                                      content: profile.partnerExpectations,
                                    ),
                                    const SizedBox(height: 120),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildBottomActionBar(
                      context,
                      currentProfileState,
                      interest,
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  ),
);
}

  Widget _buildWaveBannerOverlay(Profile profile) {
    return ClipPath(
      clipper: ProfileWaveClipper(),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${profile.age} Yrs, ${profile.heightText}, ${profile.occupation}, ${profile.location}',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header Image with slideshow buttons, wave overlay, back & action indicators
  Widget _buildImageHeader(
    BuildContext context,
    Profile profile,
    List<String> images,
    bool isFav,
  ) {
    return Stack(
      children: [
        // Main Image view with Hero transition
        Hero(
          tag: profile.id == widget.profile.id
              ? widget.heroTag
              : 'profile-image-${profile.id}-details',
          child: Container(
            height: 500,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              image: DecorationImage(
                image: AppProfileImage.provider(images[_currentImageIndex]),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),
        ),

        // Dark gradient overlay for bottom text readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),
        ),





        // Slideshow Arrow Left
        if (images.length > 1)
          Positioned(
            left: 12,
            top: 232,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentImageIndex =
                      (_currentImageIndex - 1 + images.length) % images.length;
                });
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

        // Slideshow Arrow Right
        if (images.length > 1)
          Positioned(
            right: 12,
            top: 232,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentImageIndex = (_currentImageIndex + 1) % images.length;
                });
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<_GridItem> items,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppConstants.spacingM),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                Divider(color: AppColors.divider, height: 18),
            itemBuilder: (context, index) {
              final item = items[index];
              if (item.isLocked) {
                return InkWell(
                  onTap: item.onTapLocked,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            item.label,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.amber.shade700, width: 1.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock_rounded, size: 12, color: Colors.amber.shade900),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    item.value,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade900,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      item.label,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: Text(
                      item.value,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            content.trim().isEmpty ? 'Not specified' : content,
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // Horoscope Details Card
  Widget _buildHoroscopeCard(ThemeData theme, Profile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.wb_sunny_outlined,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppLanguageController.text('religious_horoscope'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingS),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.spacingM),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: AppConstants.softShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildHoroscopeSpec(
                      AppLanguageController.text('star'),
                      profile.horoscopeStar,
                      isLocked: false,
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.border),
                  Expanded(
                    child: _buildHoroscopeSpec(
                      AppLanguageController.text('paatham'),
                      profile.horoscopePaatham,
                      isLocked: false,
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.border),
                  Expanded(
                    child: _buildHoroscopeSpec(
                      AppLanguageController.text('rasi'),
                      profile.horoscopeRasi,
                      isLocked: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingM),
              Divider(color: AppColors.border, height: 1),
              const SizedBox(height: AppConstants.spacingS),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _handleHoroscopeDownload(context, profile);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                  ),
                  label: Text(
                    AppLanguageController.text('view_horoscope'),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _handleHoroscopeDownload(context, profile);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(
                    Icons.download_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: Text(
                    AppLanguageController.text('download_horoscope'),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
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
    );
  }

  Widget _buildHoroscopeSpec(String label, String value, {bool isLocked = false}) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textLight),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isLocked ? 10.5 : 13,
            fontWeight: FontWeight.bold,
            color: isLocked ? Colors.amber.shade900 : AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showUpgradePlanModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.workspace_premium_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLanguageController.text('membership_plans'),
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Upgrade to Diamond or Platinum plan to unlock full phone number, email & horoscope download.',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Diamond Card
              _buildPlanTile(
                context: context,
                title: 'Diamond Plan',
                price: '₹ 1,500.00 / 90 Days',
                subtitle: '30 Verified Contacts + Unlimited Search + 3 Photos',
                badge: 'RECOMMENDED',
                color: Colors.amber.shade800,
                onTap: () async {
                  Navigator.pop(ctx);
                  await ProfileDatabase.updateUserProfile(plan: 'Diamond');
                  if (context.mounted) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLanguageController.text('plan_upgraded_success')),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              // Platinum Card
              _buildPlanTile(
                context: context,
                title: 'Platinum Plan',
                price: '₹ 2,500.00 / 120 Days',
                subtitle: '60 Verified Contacts + Unlimited Search + 4 Photos',
                badge: 'MOST POPULAR',
                color: AppColors.primary,
                onTap: () async {
                  Navigator.pop(ctx);
                  await ProfileDatabase.updateUserProfile(plan: 'Platinum');
                  if (context.mounted) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLanguageController.text('plan_upgraded_success')),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanTile({
    required BuildContext context,
    required String title,
    required String price,
    required String subtitle,
    required String badge,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge,
                        style: GoogleFonts.poppins(
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              AppLanguageController.text('upgrade_now'),
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleHoroscopeDownload(BuildContext context, Profile profile) async {
    if (!ProfileDatabase.isLoggedIn) {
      AuthRequiredDialog.show(context, featureName: 'Horoscope');
      return;
    }

    final userState = ProfileDatabase.userProfileNotifier.value;
    final plan = userState.plan.toLowerCase();

    if (plan.contains('free')) {
      _showUpgradePlanModal(context);
      return;
    }

    final limit = (plan.contains('premium 1') || plan.contains('gold')) ? 40 : 100;
    if (userState.downloadedCount >= limit) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'View Limit Reached',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'You have reached the view limit ($limit) for your ${userState.plan} plan. Upgrade your plan in your Profile tab to view more.',
                style: GoogleFonts.poppins(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    // Success download mock: Increment downloadedCount
    await ProfileDatabase.updateUserProfile(
      downloadedCount: userState.downloadedCount + 1,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opened Horoscope for ${profile.name}! (Views: ${userState.downloadedCount + 1} / $limit)',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  // Bottom Sticky Actions
  Widget _buildBottomActionBar(
    BuildContext context,
    Profile currentProfile,
    String interestStatus,
  ) {
    final isFav = ProfileDatabase.currentProfiles.firstWhere(
      (p) => p.id == currentProfile.id,
      orElse: () => currentProfile,
    ).isFavourite;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              if (interestStatus == 'received') ...[
                // Decline Button (Matching Image 1)
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text(
                                'Decline Interest?',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                'Are you sure you want to decline this interest from ${currentProfile.name}? This will remove it permanently.',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Declined and removed ${currentProfile.name}.'),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: AppColors.primary,
                                        duration: const Duration(milliseconds: 1200),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                    ProfileDatabase.blockProfile(currentProfile.id);
                                  },
                                  child: Text(
                                    'Decline & Remove',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Decline',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Accept Button with Checkmark (Matching Image 1)
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x337A102A),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          ProfileDatabase.updateInterest(
                            currentProfile.id,
                            'accepted',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Congratulations! You accepted the interest.',
                              ),
                              duration: Duration(milliseconds: 1200),
                            ),
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Accept',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ] else if (interestStatus == 'sent') ...[
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Interest Sent',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (interestStatus == 'accepted') ...[
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people_alt_rounded, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Connected',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Add to Favourites Button (Replaces Not Interested)
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isFav ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFav ? AppColors.primary : AppColors.border,
                        width: 1.2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (!ProfileDatabase.isLoggedIn) {
                            AuthRequiredDialog.show(context, featureName: 'Favourites');
                            return;
                          }
                          final wasFav = isFav;
                          ProfileDatabase.toggleFavorite(currentProfile.id);
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                wasFav
                                    ? (AppLanguageController.isTamil ? 'பிடித்தவைகளிலிருந்து நீக்கப்பட்டது' : 'Removed from favourites')
                                    : (AppLanguageController.isTamil ? 'பிடித்தவைகளில் சேர்க்கப்பட்டது' : 'Added to favourites'),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.primary,
                              duration: const Duration(milliseconds: 1200),
                            ),
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                size: 18,
                                color: isFav ? AppColors.primary : AppColors.textPrimary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isFav
                                    ? (AppLanguageController.isTamil ? 'பிடித்தவை' : 'Favourites')
                                    : (AppLanguageController.isTamil ? 'பிடித்தவை சேர்க்க' : 'Add to Favourites'),
                                style: GoogleFonts.roboto(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: isFav ? AppColors.primary : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Express Interest Button
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x337A102A),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (!ProfileDatabase.isLoggedIn) {
                            AuthRequiredDialog.show(context, featureName: 'Interests');
                            return;
                          }
                          ProfileDatabase.updateInterest(currentProfile.id, 'sent');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Expressed interest to ${currentProfile.name}!',
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.primary,
                              duration: const Duration(milliseconds: 1200),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            AppLanguageController.text('send_interest'),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Grid Item Helper class
class _GridItem {
  final String label;
  final String value;
  final bool isLocked;
  final VoidCallback? onTapLocked;
  _GridItem(this.label, this.value, {this.isLocked = false, this.onTapLocked});
}

// Wave clipper Bezier curve
class ProfileWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0.0, 4.0);
    var control = Offset(size.width * 0.5, 1.0);
    var end = Offset(size.width, 4.0);
    path.quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
