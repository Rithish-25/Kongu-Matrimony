import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/localization/app_language.dart';
import '../../core/navigation/app_page_route.dart';
import '../../core/assets/mock_data.dart';
import '../register/register_flow.dart';

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

                  // --- WELCOME TO KONGU KOOTAMAIPU BANNER (IMAGE 3) ---
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDFBF7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF3EFE6)),
                    ),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: GoogleFonts.roboto(
                          fontSize: 13.5,
                          height: 1.6,
                          color: const Color(0xFF4A4A4A),
                        ),
                        children: [
                          TextSpan(text: AppLanguageController.text('Welcome to ')),
                          TextSpan(
                            text: 'Kongu Kootamaipu™',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextSpan(
                            text: AppLanguageController.text(
                              ' — your trusted partner in finding lifelong companionship and happiness. We believe every individual deserves a loving, compatible life partner. Our mission is to make your journey to marriage ',
                            ),
                          ),
                          TextSpan(
                            text: AppLanguageController.text('simple, safe, and successful'),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextSpan(
                            text: AppLanguageController.text(
                              ' by combining timeless traditional values with modern, intuitive technology.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- PLATFORM AT A GLANCE (IMAGE 3) ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLanguageController.text('PLATFORM AT A GLANCE'),
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF888888),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ValueListenableBuilder<List<Profile>>(
                    valueListenable: ProfileDatabase.notifier,
                    builder: (context, profiles, _) {
                      final int menCount = profiles.where((p) => p.gender.trim().toLowerCase() == 'male').length;
                      final int womenCount = profiles.where((p) => p.gender.trim().toLowerCase() == 'female').length;

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                count: '$menCount',
                                label: AppLanguageController.text('MEN HOROSCOPE\nPROFILES'),
                                onTap: () => onNavigateToTab(1),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildStatCard(
                                count: '$womenCount',
                                label: AppLanguageController.text('WOMEN HOROSCOPE\nPROFILES'),
                                onTap: () => onNavigateToTab(1),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildStatCard(
                                count: '365',
                                label: AppLanguageController.text('DAYS OF\nSUPPORT'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
                                  const RegisterFlow(
                                    initialStep: 0,
                                    initialData: {},
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                            label: Text(
                              AppLanguageController.text('Create Free Profile'),
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
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

  Widget _buildStatCard({required String count, required String label, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEBEBEB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF666666),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
