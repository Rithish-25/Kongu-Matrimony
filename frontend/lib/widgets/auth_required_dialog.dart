import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/colors/colors.dart';
import '../core/localization/app_language.dart';
import '../screens/auth/login_screen.dart';

class AuthRequiredDialog extends StatelessWidget {
  final String? featureName;

  const AuthRequiredDialog({
    super.key,
    this.featureName,
  });

  static Future<void> show(BuildContext context, {String? featureName}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AuthRequiredDialog(featureName: featureName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTamil = AppLanguageController.isTamil;

    final String titleText = isTamil
        ? 'உள்நுழைவு தேவை'
        : 'Login Required';

    final String subtitleText = featureName != null
        ? (isTamil
            ? '$featureName அம்சத்தைப் பயன்படுத்த தயவுசெய்து உள்நுழையவும்.'
            : 'Please login to access $featureName.')
        : (isTamil
            ? 'ஜாதகம், விருப்பங்கள் மற்றும் பிடித்தவை அம்சங்களை அணுக தயவுசெய்து உள்நுழையவும்.'
            : 'Please login to access Horoscope, Interests, and Favourites features.');

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Lock / Member Icon Badge
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(height: 20),

          // Dialog Title
          Text(
            titleText,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),

          // Dialog Subtitle
          Text(
            subtitleText,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 28),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.login_rounded, size: 20),
              label: Text(
                isTamil ? 'உள்நுழைவு' : 'Login',
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Cancel / Dismiss Text Button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              isTamil ? 'ரத்து செய்ய' : 'Cancel',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
