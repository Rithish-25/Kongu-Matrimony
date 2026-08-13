import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/assets/mock_data.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../widgets/cards/premium_card.dart';
import '../premium/premium_screen.dart';
import '../../core/navigation/app_page_route.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;

  const HomeScreen({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<List<Profile>>(
      valueListenable: ProfileDatabase.notifier,
      builder: (context, profiles, _) {
        final receivedInterestCount =
            profiles
                .where((profile) => profile.interestStatus == 'received')
                .length;

        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spacingL),
                _buildWelcomeBanner(
                  totalProfiles: profiles.length,
                  receivedInterestCount: receivedInterestCount,
                ),
                const SizedBox(height: AppConstants.spacingL),
                _buildQuickActions(context),
                const SizedBox(height: AppConstants.spacingL),
                ValueListenableBuilder<UserProfileState>(
                  valueListenable: ProfileDatabase.userProfileNotifier,
                  builder: (context, userProfile, _) {
                    return PremiumCard(
                      onUpgradePressed:
                          () =>
                              _showUpgradePlansSheet(context, userProfile.plan),
                    );
                  },
                ),
                const SizedBox(height: AppConstants.spacingL),
                _buildAboutCard(theme),
                const SizedBox(height: AppConstants.spacingXL),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeBanner({
    required int totalProfiles,
    required int receivedInterestCount,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: AppConstants.softShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -20,
            child: Icon(
              Icons.spa,
              size: 140,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vanakkam',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find Your Perfect\nLife Partner',
                  style: GoogleFonts.cinzel(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingM),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.search_rounded,
        title: 'Horoscope',
        subtitle: 'Find matches by Rasi & Star',
        onTap: () => onNavigateToTab(1),
      ),
      _ActionItem(
        icon: Icons.favorite_border_rounded,
        title: 'Favourites',
        subtitle: 'View your saved profiles',
        onTap: () => onNavigateToTab(2),
      ),
      _ActionItem(
        icon: Icons.handshake_outlined,
        title: 'Interests',
        subtitle: 'Check your sent and received interests',
        onTap: () => onNavigateToTab(3),
      ),
      _ActionItem(
        icon: Icons.card_membership_rounded,
        title: 'Subscription',
        subtitle: 'Manage your premium plans',
        onTap: () {
          Navigator.of(context).push(
            appPageRoute(const PremiumScreen()),
          );
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppConstants.spacingS,
        mainAxisSpacing: AppConstants.spacingS,
        childAspectRatio: 1.35,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadiusMedium,
            ),
            border: Border.all(color: AppColors.border),
            boxShadow: AppConstants.softShadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: action.onTap,
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        action.icon,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action.title,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      action.subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  Widget _buildAboutCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border),
        boxShadow: AppConstants.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'About Kongu Matrimony',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'We are a premium matrimonial network dedicated exclusively to the Kongu community. Our platform blends sacred traditions such as Koottam, Star, and Rasi matching with modern privacy, polished user experience, and trusted profile discovery.',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _showUpgradePlansSheet(BuildContext context, String currentPlan) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final plans = ['Free', 'Gold', 'Platinum'];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Premium Plan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Switch plans to test the membership experience and horoscope download limits.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                ...plans.map(
                  (plan) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      plan == 'Platinum'
                          ? Icons.military_tech_rounded
                          : plan == 'Gold'
                          ? Icons.workspace_premium_rounded
                          : Icons.stars_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      '$plan Plan',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    trailing:
                        currentPlan.toLowerCase() == plan.toLowerCase()
                            ? const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                            )
                            : null,
                    onTap: () async {
                      await ProfileDatabase.updateUserProfile(
                        plan: plan,
                        downloadedCount: 0,
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$plan plan activated successfully.'),
                          duration: const Duration(milliseconds: 1200),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _ActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}


