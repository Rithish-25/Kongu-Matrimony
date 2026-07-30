import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/mock_data.dart';
import '../../widgets/appbar/custom_app_bar.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileImages = [
      widget.profile.profileImageUrl,
      widget.profile.coverImageUrl,
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile Details', isMainScreen: false),
      body: ValueListenableBuilder<List<Profile>>(
        valueListenable: ProfileDatabase.notifier,
        builder: (context, profiles, _) {
          final currentProfileState = profiles.firstWhere(
            (p) => p.id == widget.profile.id,
            orElse: () => widget.profile,
          );
          final isFav = currentProfileState.isFavourite;
          final interest = currentProfileState.interestStatus;

          return Stack(
            children: [
              // Scrollable Details Body
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Image Slideshow Header
                    _buildImageHeader(context, profileImages, isFav),

                    // Content Details
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingM,
                        vertical: AppConstants.spacingM,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBasicDetailsCard(theme, currentProfileState),
                          const SizedBox(height: AppConstants.spacingL),
                          _buildPersonalDetailsCard(theme, currentProfileState),
                          const SizedBox(height: AppConstants.spacingL),
                          _buildHoroscopeCard(theme, currentProfileState),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
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
      ),
    );
  }

  // Header Image with slideshow buttons, wave overlay, back & action indicators
  Widget _buildImageHeader(
    BuildContext context,
    List<String> images,
    bool isFav,
  ) {
    return Stack(
      children: [
        // Main Image view with Hero transition
        Hero(
          tag: widget.heroTag,
          child: Container(
            height: 380,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.border,
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

        // Favourite button (Top Right)
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: () {
              final wasFav = isFav;
              ProfileDatabase.toggleFavorite(widget.profile.id);
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
        Positioned(
          left: 12,
          top: 170,
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
        Positioned(
          right: 12,
          top: 170,
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

        // Wave banner overlay with Name & specs details on bottom of photo
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: ProfileWaveClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.85),
                    AppColors.primary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.profile.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.profile.age} Yrs, ${widget.profile.heightText}, ${widget.profile.subsect}, ${widget.profile.occupation}, ${widget.profile.location}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Basic Details Premium Card
  Widget _buildBasicDetailsCard(ThemeData theme, Profile profile) {
    final detailItems = [
      _GridItem('Marital Status', 'Never Married'),
      _GridItem('Mother Tongue', 'Tamil'),
      _GridItem('Height', profile.heightText),
      _GridItem('Weight', '58 kg'),
      _GridItem('Physical Status', 'Normal'),
      _GridItem('Body Type', 'Average'),
      _GridItem('Eating Habits', 'Vegetarian'),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(
          0xFFFDFBF8,
        ), // Soft cream/champagne highlight background
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                profile.name.split(' ').first,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'ID: KM-${profile.id.toUpperCase()} 🪐',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Basic Details',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryDark,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppConstants.spacingM),

          // Render details grid list
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: detailItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final item = detailItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.value,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
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

  // Personal & Professional Details Card
  Widget _buildPersonalDetailsCard(ThemeData theme, Profile profile) {
    final details = [
      _DetailRowItem(Icons.school_outlined, 'Education', profile.education),
      _DetailRowItem(
        Icons.work_outline_rounded,
        'Profession',
        profile.occupation,
      ),
      _DetailRowItem(Icons.family_restroom, 'Sub-Sect', profile.subsect),
      _DetailRowItem(
        Icons.star_border,
        'Koottam (Clan)',
        '${profile.koottam} Koottam',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Personal & Professional Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingS),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: details.length,
            separatorBuilder:
                (context, index) =>
                    const Divider(color: AppColors.border, height: 1),
            itemBuilder: (context, index) {
              final d = details[index];
              return Padding(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(d.icon, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: AppConstants.spacingM),
                    Text(
                      d.label,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    Expanded(
                      child: Text(
                        d.value,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
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
            Text(
              'Horoscope Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
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
                      'Star (Natchathiram)',
                      profile.horoscopeStar,
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.border),
                  Expanded(
                    child: _buildHoroscopeSpec(
                      'Rasi (Moon Sign)',
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
                    'View Horoscope',
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
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
        child: Row(
          children: [
            if (interestStatus == 'received') ...[
              Expanded(
                child: SecondaryButton(
                  text: 'Decline',
                  borderColor: AppColors.textSecondary,
                  onPressed: () {
                    ProfileDatabase.updateInterest(
                      currentProfile.id,
                      'rejected',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Declined interest.'),
                        duration: Duration(milliseconds: 1200),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: PrimaryButton(
                  text: 'Accept Interest',
                  isGold: true,
                  onPressed: () {
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
                ),
              ),
            ] else if (interestStatus == 'sent') ...[
              Expanded(
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(
                      AppConstants.buttonRadius,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Interest Sent',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (interestStatus == 'accepted') ...[
              Expanded(
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(
                      AppConstants.buttonRadius,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_alt, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Connected',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: PrimaryButton(
                  text: 'Express Interest',
                  onPressed: () {
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
                ),
              ),
            ],
          ],
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

class _DetailRowItem {
  final IconData icon;
  final String label;
  final String value;

  _DetailRowItem(this.icon, this.label, this.value);
}
