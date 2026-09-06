import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/constants.dart';

class MembershipCard extends StatelessWidget {
  final String userName;
  final String membershipId;
  final String planName;
  final String validUntil;
  final String bookmarksInfo;
  final bool isPremium;

  const MembershipCard({
    super.key,
    this.userName = '',
    this.membershipId = '',
    required this.planName,
    required this.validUntil,
    this.bookmarksInfo = '',
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

    if (plan.contains('diamond')) {
      // DIAMOND PLAN: Deep Cyan & Royal Blue Sparkle Gradient
      cardGradient = const LinearGradient(
        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF0072FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      cardShadow = [
        BoxShadow(
          color: const Color(0xFF0072FF).withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];
      cardIcon = Icons.diamond_rounded;
      iconColor = const Color(0xFF00E5FF); // Electric Cyan Diamond
      textPrimaryColor = Colors.white;
      textSecondaryColor = const Color(0xFFBAE6FD);
    } else if (plan.contains('platinum')) {
      // PLATINUM PLAN: Metallic Platinum Dark Sheen Gradient
      cardGradient = const LinearGradient(
        colors: [Color(0xFF141E30), Color(0xFF243B55), Color(0xFF3A4B68)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      cardShadow = [
        BoxShadow(
          color: const Color(0xFF243B55).withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];
      cardIcon = Icons.workspace_premium_rounded;
      iconColor = const Color(0xFFF8FAFC); // Platinum Silver
      textPrimaryColor = Colors.white;
      textSecondaryColor = const Color(0xFFE2E8F0);
    } else if (plan.contains('premium 1') || plan.contains('gold')) {
      // GOLD PLAN: Rich Amber Gold Gradient
      cardGradient = const LinearGradient(
        colors: [Color(0xFF78350F), Color(0xFFB45309), Color(0xFFD97706)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      cardShadow = [
        BoxShadow(
          color: const Color(0xFFD97706).withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];
      cardIcon = Icons.stars_rounded;
      iconColor = const Color(0xFFFDE047);
      textPrimaryColor = Colors.white;
      textSecondaryColor = const Color(0xFFFEF3C7);
    } else {
      // FREE PLAN: Warm Pastel Coral/Peach Gradient
      cardGradient = const LinearGradient(
        colors: [Color(0xFFFFF8F0), Color(0xFFFFE6D5), Color(0xFFFED7AA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      cardShadow = [
        BoxShadow(
          color: const Color(0xFFF97316).withValues(alpha: 0.15),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ];
      cardIcon = Icons.stars_rounded;
      iconColor = const Color(0xFFEA580C);
      textPrimaryColor = const Color(0xFF431407);
      textSecondaryColor = const Color(0xFF9A3412);
    }

    final String displayValid = validUntil.trim().isEmpty
        ? ''
        : (validUntil.contains(':') ||
                validUntil.toLowerCase().startsWith('upgrade') ||
                validUntil.toLowerCase().startsWith('valid'))
            ? validUntil
            : 'Valid Till: $validUntil';

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
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  planName,
                                  style: GoogleFonts.poppins(
                                    color: textPrimaryColor,
                                    fontSize: isCompact ? 18 : 20,
                                    fontWeight: FontWeight.w800,
                                  ),
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
                    if (userName.isNotEmpty || membershipId.isNotEmpty || displayValid.isNotEmpty || bookmarksInfo.isNotEmpty) ...[
                      const SizedBox(height: AppConstants.spacingXL),
                      if (userName.isNotEmpty) ...[
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
                      ],
                      if (membershipId.isNotEmpty) ...[
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
                      ],
                      if (displayValid.isNotEmpty && bookmarksInfo.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                displayValid,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: textSecondaryColor,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              bookmarksInfo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: textSecondaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ] else if (displayValid.isNotEmpty) ...[
                        Text(
                          displayValid,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: textSecondaryColor,
                            fontSize: 11,
                          ),
                        ),
                      ] else if (bookmarksInfo.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            bookmarksInfo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: textSecondaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
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
