import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/localization/app_language.dart';
import '../../core/navigation/app_page_route.dart';
import '../auth/quick_register_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;

  const HomeScreen({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder<AppLanguage>(
        valueListenable: AppLanguageController.notifier,
        builder: (context, lang, _) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- TOP HERO LOGO (UNCUPPED PNG) ---
                  Center(
                    child: SizedBox(
                      width: 175,
                      height: 175,
                      child: Image.asset(
                        'assets/home-logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.favorite_rounded,
                              color: AppColors.primary,
                              size: 48,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- KONGU KOOTAMAIPU REGISTRATION DETAILS & SERVICE SCHEMES ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDFBF7),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFF3EFE6)),
                      boxShadow: AppConstants.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Key Registration Details
                        _buildInfoBullet(
                          icon: Icons.verified_rounded,
                          text: 'பதிவு வருடம்: 21.03.2004 | அரசு பதிவு எண்: 194 / 2004',
                        ),
                        const SizedBox(height: 10),
                        _buildInfoBullet(
                          icon: Icons.account_balance_rounded,
                          text: 'அரசியல் சார்பற்ற அமைப்பு',
                        ),
                        const SizedBox(height: 10),
                        _buildInfoBullet(
                          icon: Icons.groups_rounded,
                          text: 'உறுப்பினர் சங்கங்களின் எண்ணிக்கை: 37 கொங்கு சமுதாய சங்கங்கள்',
                        ),

                        const SizedBox(height: 18),
                        const Divider(height: 1, color: Color(0xFFECE6D8)),
                        const SizedBox(height: 18),

                        // Service Schemes Title
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'சேவை திட்டங்கள்',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Service Items List
                        _buildServiceBullet('கொங்கு சமுதாய முன்னோடிகள் பிறந்த நாள் மற்றும் நினைவு நாள் விழா நடத்துதல்.'),
                        _buildServiceBullet('கலிங்கராயன் கல்வி உதவித்திட்டங்கள்.'),
                        _buildServiceBullet('பொறியியல் கல்லூரியில் மாணவர்களுக்கு கொங்கு அறக்கட்டளை கல்லூரி கட்டணம் இன்றி பயில இட ஒதுக்கீடு செய்தல்.'),
                        _buildServiceBullet('பொருளாதாரத்தில் பின் தங்கிய மாணவர்களுக்கு வருடாந்திர கல்வி நிதியுதவி வழங்குதல்.'),
                        _buildServiceBullet('இளைஞர்களுக்கு வேலைவாய்ப்பு சேவை.'),
                        _buildServiceBullet('கொங்கு சமுதாய விழிப்புணர்வு சேவை.'),
                        _buildServiceBullet('கொங்கு கூட்டமைப்பு திருமண தகவல் மையம் சேவை.'),
                        _buildServiceBullet('இலவச மருத்துவ சேவை.'),

                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            'முதலிய சேவைத்திட்டங்கள் கொங்கு சமுதாயத்திற்காக செயல்படுத்தி வருகின்றோம்.',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              color: AppColors.primary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- READY TO FIND YOUR PARTNER CTA CARD (IMAGE 4) ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6ED),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFE5D0)),
                      boxShadow: AppConstants.cardShadow,
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLanguageController.text('Ready to Find Your Partner?'),
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLanguageController.text(
                            'Join thousands of happy members who found their life partner on Kongu Kootamaipu™.',
                          ),
                          style: GoogleFonts.roboto(
                            fontSize: 12.5,
                            color: const Color(0xFF666666),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                appPageRoute(
                                  const QuickRegisterScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                            label: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                AppLanguageController.text('Create Free Profile'),
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoBullet({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.star_rounded,
              color: AppColors.primary,
              size: 13,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
