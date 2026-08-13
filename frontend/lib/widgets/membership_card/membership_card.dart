import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';

class MembershipCard extends StatelessWidget {
  final String userName;
  final String membershipId;
  final String planName;
  final String validUntil;
  final bool isPremium;

  const MembershipCard({
    super.key,
    required this.userName,
    required this.membershipId,
    required this.planName,
    required this.validUntil,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    final String plan = planName.toLowerCase();
    Gradient cardGradient;
    List<BoxShadow> cardShadow;
    IconData cardIcon;
    Color iconColor;
    Color textPrimaryColor;
    Color textSecondaryColor;

    if (plan.contains('gold')) {
      cardGradient = AppColors.goldGradient;
      cardShadow = AppConstants.goldShadow;
      cardIcon = Icons.workspace_premium;
      iconColor = AppColors.primary;
      textPrimaryColor = AppColors.textPrimary;
      textSecondaryColor = AppColors.textPrimary.withValues(alpha: 0.7);
    } else if (plan.contains('platinum')) {
      cardGradient = const LinearGradient(
        colors: [Color(0xFF1E2429), Color(0xFF4A525A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      cardShadow = [
        BoxShadow(
          color: Colors.blueGrey.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];
      cardIcon = Icons.military_tech_rounded;
      iconColor = const Color(0xFFE2E8F0); // Platinum silver
      textPrimaryColor = Colors.white;
      textSecondaryColor = Colors.white70;
    } else {
      // Free Member
      cardGradient = LinearGradient(
        colors: [Colors.grey[300]!, Colors.grey[500]!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      cardShadow = AppConstants.softShadow;
      cardIcon = Icons.stars_rounded;
      iconColor = AppColors.primary;
      textPrimaryColor = AppColors.textPrimary;
      textSecondaryColor = AppColors.textSecondary;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 340;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: cardGradient,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            boxShadow: cardShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Background Rings design
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 2,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: -60,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KONGU MEMBERSHIP',
                                style: GoogleFonts.poppins(
                                  color: textSecondaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                planName,
                                maxLines: isCompact ? 2 : 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: textPrimaryColor,
                                  fontSize: isCompact ? 18 : 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          cardIcon,
                          color: iconColor,
                          size: isCompact ? 28 : 32,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingXL),
                    Text(
                      userName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: textPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isCompact) ...[
                      Text(
                        'ID: $membershipId',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: textSecondaryColor,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Valid Till: $validUntil',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: textSecondaryColor,
                          fontSize: 11,
                        ),
                      ),
                    ] else
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'ID: $membershipId',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: textSecondaryColor,
                                fontSize: 11,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              'Valid Till: $validUntil',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: GoogleFonts.poppins(
                                color: textSecondaryColor,
                                fontSize: 11,
                              ),
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
      },
    );
  }
}
