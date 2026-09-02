import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/mock_data.dart';
import '../../core/localization/app_language.dart';
import '../../widgets/appbar/custom_app_bar.dart';

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
        title: _profiles[_lastActivePage].name,
        isMainScreen: false,
        showNotification: true,
      ),
      body: ValueListenableBuilder<AppLanguage>(
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
                                        _GridItem(AppLanguageController.text('dob'), profile.dob),
                                        _GridItem(AppLanguageController.text('age'), '${profile.age} ${AppLanguageController.text('yrs')}'),
                                        _GridItem(AppLanguageController.text('mobile'), profile.mobile),
                                        _GridItem(AppLanguageController.text('email'), profile.email),
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
                                        _GridItem(AppLanguageController.text('complexion'), profile.complexion),
                                        _GridItem(AppLanguageController.text('body_type'), profile.bodyType),
                                        _GridItem(AppLanguageController.text('disability'), profile.disability),
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
                                        _GridItem(AppLanguageController.text('smoking_habits'), profile.smokingHabits),
                                        _GridItem(AppLanguageController.text('drinking_habits'), profile.drinkingHabits),
                                        _GridItem(AppLanguageController.text('hobbies'), profile.hobbies),
                                      ],
                                    ),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildSectionCard(
                                      title: AppLanguageController.text('family_details'),
                                      icon: Icons.family_restroom_rounded,
                                      items: [
                                        _GridItem(AppLanguageController.text('koottam'), profile.koottam),
                                        _GridItem(AppLanguageController.text('subsect'), profile.subsect),
                                        _GridItem(AppLanguageController.text('father_occupation'), profile.fatherOccupation),
                                        _GridItem(AppLanguageController.text('mother_occupation'), profile.motherOccupation),
                                        _GridItem(AppLanguageController.text('brothers'), profile.brothersCount),
                                        _GridItem(AppLanguageController.text('sisters'), profile.sistersCount),
                                        _GridItem(AppLanguageController.text('ancestral_origin'), profile.ancestralOrigin),
                                      ],
                                    ),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildSectionCard(
                                      title: AppLanguageController.text('education_professional'),
                                      icon: Icons.school_outlined,
                                      items: [
                                        _GridItem(AppLanguageController.text('education'), profile.education),
                                        _GridItem(AppLanguageController.text('education_detail'), profile.educationDetail),
                                        _GridItem(AppLanguageController.text('occupation'), profile.occupation),
                                        _GridItem(AppLanguageController.text('employed_in'), profile.employedIn),
                                        _GridItem(AppLanguageController.text('annual_income'), profile.annualIncome),
                                        _GridItem(AppLanguageController.text('work_location'), profile.workLocation),
                                      ],
                                    ),
                                    const SizedBox(height: AppConstants.spacingL),
                                    _buildSectionCard(
                                      title: AppLanguageController.text('location_contact'),
                                      icon: Icons.location_on_outlined,
                                      items: [
                                        _GridItem(AppLanguageController.text('native_place'), profile.nativePlace),
                                        _GridItem(AppLanguageController.text('city'), profile.city),
                                        _GridItem(AppLanguageController.text('district'), profile.district),
                                        _GridItem(AppLanguageController.text('state'), profile.state),
                                        _GridItem(AppLanguageController.text('country'), profile.country),
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
                image: NetworkImage(images[_currentImageIndex]),
                fit: BoxFit.cover,
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



        // Favourite button (Top Right) - Placed in the image header Stack
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: () {
              final wasFav = isFav;
              ProfileDatabase.toggleFavorite(profile.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    wasFav ? 'Removed from favourites' : 'Added to favourites',
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.primary,
                  duration: const Duration(milliseconds: 1200),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                shape: BoxShape.circle,
                boxShadow: AppConstants.softShadow,
              ),
              child: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: AppColors.primary,
                size: 20,
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
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppConstants.spacingM),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const Divider(color: AppColors.divider, height: 18),
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      item.value,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.right,
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
          const Divider(color: AppColors.border, height: 1),
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
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.border),
                  Expanded(
                    child: _buildHoroscopeSpec(
                      AppLanguageController.text('paatham'),
                      profile.horoscopePaatham,
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.border),
                  Expanded(
                    child: _buildHoroscopeSpec(
                      AppLanguageController.text('rasi'),
                      profile.horoscopeRasi,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingM),
              const Divider(color: AppColors.border, height: 1),
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHoroscopeSpec(String label, String value) {
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
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Future<void> _handleHoroscopeDownload(BuildContext context, Profile profile) async {
    final userState = ProfileDatabase.userProfileNotifier.value;
    final plan = userState.plan.toLowerCase();

    if (plan.contains('free')) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Upgrade Plan',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Free members cannot view horoscope charts. Please upgrade to Gold or Platinum in your Profile tab.',
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

    final limit = plan.contains('gold') ? 10 : 20;
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
        backgroundColor: Colors.green,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
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
                      color: Colors.green.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people_alt_rounded, color: Colors.green, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Connected',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Not Interested Button
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
                                'Not Interested?',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                'Are you sure you want to remove ${currentProfile.name} from your list? This profile will not be shown to you again.',
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
                                        content: Text('Removed ${currentProfile.name} from your list.'),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: AppColors.primary,
                                        duration: const Duration(milliseconds: 1200),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                    ProfileDatabase.blockProfile(currentProfile.id);
                                  },
                                  child: Text(
                                    'Yes, Remove',
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
                            'Not Interested',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
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
                            'Express Interest',
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
  _GridItem(this.label, this.value);
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
