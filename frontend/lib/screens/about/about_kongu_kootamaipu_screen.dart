import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/localization/app_language.dart';
import '../../widgets/appbar/custom_app_bar.dart';

class AboutKonguKootamaipuScreen extends StatelessWidget {
  const AboutKonguKootamaipuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTamil = AppLanguageController.isTamil;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: isTamil ? 'கொங்கு கூட்டமைப்பு பற்றி' : 'About Kongu Kootamaipu',
        isMainScreen: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.diversity_3_rounded,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isTamil ? 'கொங்கு கூட்டமைப்பு' : 'Kongu Kootamaipu',
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isTamil
                        ? 'கொங்கு வேளாள கவுண்டர் சமுதாயத் திருமண சேவை அமைப்பு'
                        : 'Official Matrimonial Trust for Kongu Community',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Mission Card
            _buildInfoCard(
              icon: Icons.flag_rounded,
              title: isTamil ? 'எங்கள் நோக்கம்' : 'Our Mission',
              content: isTamil
                  ? 'கொங்கு வேளாள கவுண்டர் சமூகத்தின் பண்பாடு, கலாச்சாரம் மற்றும் பாரம்பரிய மதிப்புகளைப் பாதுகாத்து, உலகம் முழுவதிலும் உள்ள கொங்கு குடும்பங்களை ஒன்றாக இணைப்பதே எங்களின் முதன்மை நோக்கமாகும்.'
                  : 'To unite Kongu families worldwide by offering a reliable, traditional, and 100% Kootam-verified matrimonial platform preserving our community heritage.',
            ),
            const SizedBox(height: 14),

            // Key Highlights Card
            _buildInfoCard(
              icon: Icons.verified_user_rounded,
              title: isTamil ? 'முக்கிய சிறப்பம்சங்கள்' : 'Key Highlights',
              child: Column(
                children: [
                  _buildHighlightRow(
                    icon: Icons.check_circle_rounded,
                    title: isTamil ? '100% கூட்டப் பொருத்தம் சரிபார்ப்பு' : '100% Kootam Verification',
                    subtitle: isTamil ? 'அனைத்து குலதெய்வம் மற்றும் கூட்டம் சரிபார்க்கப்பட்டது' : 'Detailed Kootam & Kuladeivam mapping',
                  ),
                  const Divider(height: 18),
                  _buildHighlightRow(
                    icon: Icons.auto_awesome_rounded,
                    title: isTamil ? 'துல்லியமான ஜாதகப் பொருத்தம்' : 'Accurate Horoscope Porutham',
                    subtitle: isTamil ? '10 பொருத்தம் மற்றும் திருக்கணித கணிப்பு' : '10 Porutham calculations & Navamsha charts',
                  ),
                  const Divider(height: 18),
                  _buildHighlightRow(
                    icon: Icons.security_rounded,
                    title: isTamil ? 'பாதுகாப்பான குடும்ப தொடர்புகள்' : 'Family Privacy & Security',
                    subtitle: isTamil ? 'நேரடி குடும்ப தொடர்பு மற்றும் சரிபார்க்கப்பட்ட எண்கள்' : 'Direct contact details with family consent',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Contact & Help Card
            _buildInfoCard(
              icon: Icons.headset_mic_rounded,
              title: isTamil ? 'எங்களை தொடர்பு கொள்ள' : 'Contact & Support',
              content: isTamil
                  ? 'ஈரோடு, கோயம்புத்தூர், திருப்பூர், சேலம், நாமக்கல் மற்றும் கரூர் மாவட்ட தலைமை அலுவலகங்கள் மூலம் சேவை வழங்கப்படுகிறது.\n\nHelpline: +91 98765 43210\nEmail: support@kongukootamaipu.org'
                  : 'Serving families across Erode, Coimbatore, Tiruppur, Salem, Namakkal & Karur.\n\nHelpline: +91 98765 43210\nEmail: support@kongukootamaipu.org',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    String? content,
    Widget? child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (content != null)
            Text(
              content,
              style: GoogleFonts.roboto(
                fontSize: 13.5,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildHighlightRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.roboto(
                  fontSize: 11.5,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
