import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/navigation/app_page_route.dart';
import '../../screens/about/about_kongu_kootamaipu_screen.dart';
import '../../screens/contact/contact_us_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
              left: 20,
              right: 16,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/app-logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.diversity_3_rounded,
                          color: AppColors.primary,
                          size: 26,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ValueListenableBuilder<AppLanguage>(
                  valueListenable: AppLanguageController.notifier,
                  builder: (context, currentLang, __) {
                    final isTamil = currentLang == AppLanguage.tamil;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLanguageController.text('app_title'),
                          style: GoogleFonts.roboto(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: isTamil ? 0 : 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isTamil
                              ? 'கொங்கு சமுதாய அறக்கட்டளை திருமண சேவை'
                              : 'Community Trust Matrimony',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Drawer Body Options with Divider lines & Spacing
          Expanded(
            child: ValueListenableBuilder<AppLanguage>(
              valueListenable: AppLanguageController.notifier,
              builder: (context, currentLang, __) {
                final isTamil = currentLang == AppLanguage.tamil;

                return ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildDrawerTile(
                      context: context,
                      icon: Icons.info_outline_rounded,
                      title: isTamil ? 'கொங்கு கூட்டமைப்பு பற்றி' : 'About Kongu Kootamaipu',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          appPageRoute(const AboutKonguKootamaipuScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0), thickness: 1),
                    _buildDrawerTile(
                      context: context,
                      icon: Icons.shield_outlined,
                      title: isTamil ? 'தனியுரிமைக் கொள்கை' : 'Privacy Policy',
                      onTap: () {
                        Navigator.of(context).pop();
                        _showPolicyDialog(context, isTamil ? 'தனியுரிமைக் கொள்கை' : 'Privacy Policy');
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0), thickness: 1),
                    _buildDrawerTile(
                      context: context,
                      icon: Icons.description_outlined,
                      title: isTamil ? 'விதிமுறைகள் & நிபந்தனைகள்' : 'Terms & Conditions',
                      onTap: () {
                        Navigator.of(context).pop();
                        _showPolicyDialog(context, isTamil ? 'விதிமுறைகள் & நிபந்தனைகள்' : 'Terms & Conditions');
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0), thickness: 1),
                    _buildDrawerTile(
                      context: context,
                      icon: Icons.receipt_long_outlined,
                      title: isTamil ? 'திரும்பப்பெறும் கொள்கை' : 'Refund Policy',
                      onTap: () {
                        Navigator.of(context).pop();
                        _showPolicyDialog(context, isTamil ? 'திரும்பப்பெறும் கொள்கை' : 'Refund Policy');
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0), thickness: 1),
                    _buildDrawerTile(
                      context: context,
                      icon: Icons.headset_mic_outlined,
                      title: isTamil ? 'உதவி & ஆதரவு' : 'Help & Support',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          appPageRoute(const ContactUsScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8F0), thickness: 1),
                  ],
                );
              },
            ),
          ),

          // Drawer Footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Kongu Matrimony v1.0.0 • Community Trust',
              style: GoogleFonts.roboto(
                fontSize: 11,
                color: AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: const Color(0xFF334155),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPolicyDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Text(
            'Official $title for Kongu Kootamaipu™. We are committed to transparency, security, and member satisfaction.',
            style: GoogleFonts.roboto(fontSize: 13.5, color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
