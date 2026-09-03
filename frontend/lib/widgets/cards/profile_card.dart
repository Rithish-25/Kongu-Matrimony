import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/mock_data.dart';
import '../app_profile_image.dart';

enum ProfileCardType { standard, favourite, interestReceived, interestSent }

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final ProfileCardType cardType;
  final VoidCallback? onViewProfile;
  final VoidCallback? onFavoriteToggle;
  final Function(String action)? onInterestAction;
  final bool showLastActive;

  const ProfileCard({
    super.key,
    required this.profile,
    this.cardType = ProfileCardType.standard,
    this.onViewProfile,
    this.onFavoriteToggle,
    this.onInterestAction,
    this.showLastActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final isSent = profile.interestStatus == 'sent';
    final isAccepted = profile.interestStatus == 'accepted';

    return GestureDetector(
      onTap: onViewProfile,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: AppConstants.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Upper Part: Left side Image & Right side Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Square Image with overlays
                Hero(
                  tag: 'profile-image-${profile.id}-${cardType.name}',
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: AppColors.border.withValues(alpha: 0.3),
                      image: DecorationImage(
                        image: AppProfileImage.provider(profile.profileImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Right Side Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        profile.name,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // ID & Last Active
                      if (showLastActive) ...[
                        Text(
                          'Last active at 07:15 am',
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ] else ...[
                        const SizedBox(height: 6),
                      ],

                      // Wrapped Inline specs: age, height, job, koottam, location
                      Text(
                        '${profile.age} yrs | ${profile.heightText} | ${profile.occupation} | ${profile.koottam} | ${profile.location}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          height: 1.25,
                          color: AppColors.textSecondary.withValues(
                            alpha: 0.85,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 6),

            // Bottom Actions Section
            _buildActionButtonsRow(context, isSent, isAccepted),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtonsRow(
    BuildContext context,
    bool isSent,
    bool isAccepted,
  ) {
    switch (cardType) {
      case ProfileCardType.interestReceived:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => onInterestAction?.call('rejected'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 7.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Decline',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => onInterestAction?.call('accepted'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 7.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Accept',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );

      case ProfileCardType.interestSent:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => onInterestAction?.call('cancel'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 7.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Cancel Interest',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: onViewProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 7.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'View Profile',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );

      default:
        // standard & favourite card type actions
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onViewProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 7.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: const Icon(Icons.visibility_outlined, size: 15),
                label: const Text(
                  'View',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    (isSent || isAccepted)
                        ? null
                        : () {
                          ProfileDatabase.updateInterest(profile.id, 'sent');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Interest sent to ${profile.name}!',
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.primary,
                              duration: const Duration(milliseconds: 1200),
                            ),
                          );
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (isSent || isAccepted)
                          ? Colors.grey[300]
                          : AppColors.primary,
                  foregroundColor:
                      (isSent || isAccepted) ? Colors.grey[600] : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 7.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: Icon(
                  isAccepted
                      ? Icons.done_all
                      : (isSent ? Icons.check : Icons.favorite),
                  size: 15,
                ),
                label: Text(
                  isAccepted
                      ? 'Interest Accepted'
                      : (isSent ? 'Interest Sent' : 'Express Interest'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }
}
