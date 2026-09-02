import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';

class PremiumCard extends StatelessWidget {
  final VoidCallback? onUpgradePressed;

  const PremiumCard({
    super.key,
    this.onUpgradePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.softDarkGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: AppConstants.softShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Design Elements
          Positioned(
            right: -20,
            bottom: -30,
            child: Icon(
              Icons.star_purple500_sharp,
              size: 150,
              color: AppColors.secondary.withValues(alpha: 0.06),
            ),
          ),
          Positioned(
            right: 40,
            top: -10,
            child: Icon(
              Icons.favorite_rounded,
              size: 60,
              color: AppColors.primary.withValues(alpha: 0.04),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'KONGU PREMIUM',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: AppColors.secondaryLight,
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                Text(
                  'Unlock Blessed Connections',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• View full horoscope details directly\n• Get unlimited express interests\n• Unlock verified direct contact details\n• Be featured at the top of partner searches',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingL),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                    ),
                    child: ElevatedButton(
                      onPressed: onUpgradePressed ?? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Premium Plan simulation activated!'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.secondaryDark,
                            duration: const Duration(milliseconds: 1200),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        minimumSize: const Size.fromHeight(52),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Upgrade to Premium',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
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
