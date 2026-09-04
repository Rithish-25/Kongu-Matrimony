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

import '../../core/localization/app_language.dart';
import '../about/about_kongu_kootamaipu_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTamil = AppLanguageController.isTamil;

    return Scaffold(
      body: ValueListenableBuilder<UserProfileState>(
        valueListenable: ProfileDatabase.userProfileNotifier,
        builder: (context, userProfile, _) {
          final validString = userProfile.plan.toLowerCase() == 'free'
              ? 'Upgrade to Download'
              : userProfile.plan.toLowerCase() == 'gold'
                  ? 'Downloads: ${userProfile.downloadedCount} / 10'
                  : 'Downloads: ${userProfile.downloadedCount} / 20';

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppConstants.spacingM),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 3),
                      boxShadow: AppConstants.softShadow,
                      image: DecorationImage(
                        image: NetworkImage(userProfile.profileImageUrl),
                        fit: BoxFit.cover,
                      ),
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
                Text(
                  'Erode • Kannandhai Koottam',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingL),
                MembershipCard(
                  userName: userProfile.displayName,
                  membershipId: 'KM-998811',
                  planName: userProfile.plan.toLowerCase() == 'free'
                      ? 'Free Member'
                      : '${userProfile.plan} Premium Member',
                  validUntil: validString,
                  isPremium: userProfile.plan.toLowerCase() != 'free',
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
                      icon: Icons.info_outline_rounded,
                      title: isTamil ? 'கொங்கு கூட்டமைப்பு பற்றி' : 'About Kongu Kootamaipu',
                      subtitle: isTamil ? 'எங்கள் வரலாறு மற்றும் சேவைகள்' : 'Learn about our community trust',
                      onTap: () {
                        Navigator.of(context).push(
                          appPageRoute(const AboutKonguKootamaipuScreen()),
                        );
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
                  child: OutlinedButton(
                    onPressed: () => _showLogoutDialog(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Logout Account',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXXL),
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
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            ),
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
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.04),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(option.icon, size: 20, color: AppColors.primary),
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
                // Clear persisted user data and navigate to LoginScreen
                await ProfileDatabase.clearUserProfile();
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                      return FadeTransition(opacity: fade, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 350),
                  ),
                  (route) => false,
                );
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
