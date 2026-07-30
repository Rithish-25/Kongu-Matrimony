import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/assets/mock_data.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../widgets/membership_card/membership_card.dart';
import '../../widgets/appbar/custom_app_bar.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Premium Membership',
        isMainScreen: false,
      ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage your membership plan here.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingM),
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
                _PlanOption(
                  planCode: 'Free',
                  planTitle: 'Free Membership',
                  description: 'Basic searching, no horoscope downloads allowed.',
                  isSelected: userProfile.plan == 'Free',
                  gradient: LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey[400]!],
                  ),
                  textColor: AppColors.textPrimary,
                ),
                const SizedBox(height: 12),
                _PlanOption(
                  planCode: 'Gold',
                  planTitle: 'Gold Premium Plan',
                  description: 'Download up to 10 horoscope PDF charts.',
                  isSelected: userProfile.plan == 'Gold',
                  gradient: AppColors.goldGradient,
                  textColor: AppColors.textPrimary,
                ),
                const SizedBox(height: 12),
                _PlanOption(
                  planCode: 'Platinum',
                  planTitle: 'Platinum Premium Plan',
                  description: 'Download up to 20 horoscope PDF charts.',
                  isSelected: userProfile.plan == 'Platinum',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E2429), Color(0xFF4A525A)],
                  ),
                  textColor: Colors.white,
                ),
                const SizedBox(height: AppConstants.spacingL),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  final String planCode;
  final String planTitle;
  final String description;
  final bool isSelected;
  final Gradient gradient;
  final Color textColor;

  const _PlanOption({
    required this.planCode,
    required this.planTitle,
    required this.description,
    required this.isSelected,
    required this.gradient,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await ProfileDatabase.updateUserProfile(plan: planCode, downloadedCount: 0);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$planTitle activated successfully.'),
            duration: const Duration(milliseconds: 1200),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.secondaryDark : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          boxShadow: AppConstants.softShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planTitle,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: textColor.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: planCode == 'Platinum' ? Colors.white : AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
