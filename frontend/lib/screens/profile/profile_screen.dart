import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/assets/mock_data.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/navigation/app_page_route.dart';
import '../../widgets/membership_card/membership_card.dart';
import '../premium/premium_screen.dart';
import '../auth/login_screen.dart';
import '../../core/assets/registration_draft.dart';
import '../register/register_flow.dart';

import '../../widgets/app_profile_image.dart';
import '../../core/localization/app_language.dart';
import '../../core/utils/device_image_picker.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTamil = AppLanguageController.isTamil;

    return Scaffold(
      body: ValueListenableBuilder<UserProfileState>(
        valueListenable: ProfileDatabase.userProfileNotifier,
        builder: (context, userProfile, _) {
          final planLower = userProfile.plan.toLowerCase();
          final isFree = planLower.contains('free');

          String validString = '';
          String bookmarksString = '';

          if (planLower.contains('diamond') || planLower.contains('platinum')) {
            final isDiamond = planLower.contains('diamond');
            final totalDays = isDiamond ? 90 : 120;
            final maxBookmarks = isDiamond ? 30 : 60;
            final startDate = userProfile.planStartDate ?? DateTime.now();
            final daysPassed = DateTime.now().difference(startDate).inDays;
            final remainingDays = (totalDays - daysPassed).clamp(0, totalDays);

            validString = 'Validity: $remainingDays Days Left';
            bookmarksString = 'Bookmarks: ${userProfile.downloadedCount} / $maxBookmarks';
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppConstants.spacingM),
                Center(
                  child: SizedBox(
                    width: 120,
                    height: 150,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 120,
                          height: 150, // 4:5 portrait ratio (120 x 150)
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary, width: 3),
                            boxShadow: AppConstants.softShadow,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: AppProfileImage(
                              imageUrl: userProfile.profileImageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -6,
                          right: -6,
                          child: InkWell(
                            onTap: () => _showChangePhotoBottomSheet(context, userProfile.profileImageUrl),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingS),
                Text(
                  userProfile.displayName,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingL),
                MembershipCard(
                  userName: '',
                  membershipId: '',
                  planName: isFree
                      ? 'Free Member'
                      : '${userProfile.plan} Premium Member',
                  validUntil: validString,
                  bookmarksInfo: bookmarksString,
                  isPremium: !isFree,
                ),
                const SizedBox(height: AppConstants.spacingL),
                _buildOptionsGroup(
                  context: context,
                  title: isTamil ? 'கணக்கு அமைப்புகள்' : 'Account Settings',
                  options: [
                    _ProfileOption(
                      icon: Icons.edit_note_outlined,
                      title: isTamil ? 'சுயவிவரத்தைத் திருத்து' : 'Edit Profile',
                      subtitle: isTamil ? 'உங்கள் விவரங்களை புதுப்பிக்க' : 'Update your profile details',
                      onTap: () async {
                        final data = await RegistrationDraft.loadProfileDetails();
                        if (context.mounted) {
                          Navigator.of(context).push(
                            appPageRoute(
                              RegisterFlow(
                                initialStep: 0,
                                initialData: data,
                                isEditing: true,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    _ProfileOption(
                      icon: Icons.workspace_premium_outlined,
                      title: isTamil ? 'பிரீமியம் உறுப்பினர்' : 'Premium Membership',
                      subtitle: isTamil ? 'உறுப்பினர் திட்டங்களைப் பார்க்க' : 'View and change your membership plans',
                      onTap: () {
                        Navigator.of(context).push(
                          appPageRoute(const PremiumScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingL),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ProfileDatabase.isLoggedIn
                      ? OutlinedButton.icon(
                          onPressed: () => _showLogoutDialog(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error, width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                            ),
                          ),
                          icon: const Icon(Icons.logout_rounded, size: 18),
                          label: Text(
                            isTamil ? 'கணக்கிலிருந்து வெளியேறு' : 'Logout Account',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            ),
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              appPageRoute(const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                            ),
                          ),
                          icon: const Icon(Icons.login_rounded, size: 18),
                          label: Text(
                            isTamil ? 'உள்நுழைவு' : 'Login',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: AppConstants.spacingL),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionsGroup({
    required BuildContext context,
    required String title,
    required List<_ProfileOption> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            border: Border.all(color: AppColors.border),
            boxShadow: AppConstants.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge - 1),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              separatorBuilder: (_, __) => Divider(color: AppColors.border, height: 1),
              itemBuilder: (context, index) {
                final option = options[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(option.icon, size: 20, color: Colors.white),
                  ),
                  title: Text(
                    option.title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    option.subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: AppColors.textLight,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppColors.textLight,
                  ),
                  onTap: option.onTap,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          ),
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to log out of Kongu Matrimony?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Clear persisted user data and notify listeners of guest mode
                await ProfileDatabase.logout();
                await ProfileDatabase.clearUserProfile();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChangePhotoBottomSheet(BuildContext context, String currentUrl) {
    final isTamil = AppLanguageController.isTamil;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
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
                  const Icon(Icons.add_a_photo_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isTamil ? 'சுயவிவரப் புகைப்படத்தை பதிவேற்றவும்' : 'Upload Profile Photo',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                isTamil
                    ? 'உங்கள் சாதனத்திலிருந்து புகைப்படத்தைத் தேர்ந்தெடுக்கவும்'
                    : 'Choose an image file stored on your device or computer',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Device Gallery Upload Tile
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    DeviceImagePicker.pickImageFromDevice(
                      context: context,
                      onImagePicked: (imageUrl) async {
                        await ProfileDatabase.updateUserProfile(imageUrl: imageUrl);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile photo uploaded from device!'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.primary,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.photo_library_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isTamil ? 'சாதனத்திலிருந்து தேர்ந்தெடுக்கவும் (Device Gallery)' : 'Choose from Device / Gallery',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                isTamil ? 'போன் அல்லது கணிப்பொறியிலிருந்து போட்டோ தேர்வு செய்க' : 'Select any image file stored on your device',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Camera Option Tile
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    DeviceImagePicker.pickImageFromDevice(
                      context: context,
                      isCamera: true,
                      onImagePicked: (imageUrl) async {
                        await ProfileDatabase.updateUserProfile(imageUrl: imageUrl);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile photo captured!'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.primary,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt_rounded, color: AppColors.textPrimary, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isTamil ? 'கேமரா மூலம் படம் எடுக்கவும் (Camera)' : 'Take Photo with Camera',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                isTamil ? 'கேமராவை பயன்படுத்தி படம் எடுக்கவும்' : 'Capture a new picture using camera',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
