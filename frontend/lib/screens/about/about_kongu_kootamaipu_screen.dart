import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../widgets/appbar/custom_app_bar.dart';

class AboutKonguKootamaipuScreen extends StatelessWidget {
  const AboutKonguKootamaipuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar(
        title: 'About Kongu Kootamaipu',
        isMainScreen: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Logo & Title Card in Bright App Orange
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 130,
                      height: 130,
                      child: Image.asset(
                        'assets/home-logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/logo.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'கொங்கு வேளாளர் சங்கங்கள் கூட்டமைப்பு',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Key Association Details Card
            Container(
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
                children: [
                  _buildOrgDetailRow(
                    icon: Icons.verified_rounded,
                    title: 'தொடங்கிய காலம் & அரசு பதிவு எண்',
                    subtitle: '21.03.2004 | அரசு பதிவு எண் : 194 / 2004',
                  ),
                  const Divider(height: 20),
                  _buildOrgDetailRow(
                    icon: Icons.groups_rounded,
                    title: 'அமைப்புத் தன்மை',
                    subtitle: 'அரசியல் சார்பற்ற அமைப்பு',
                  ),
                  const Divider(height: 20),
                  _buildOrgDetailRow(
                    icon: Icons.hub_rounded,
                    title: 'உறுப்பினர் சங்கங்கள்',
                    subtitle: '37 கொங்கு சமுதாய சங்கங்கள்',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Service Projects Section Title
            Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'சேவை திட்டங்கள்',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Service Projects List Card
            Container(
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
                children: [
                  _buildServiceItem(
                    icon: Icons.celebration_rounded,
                    text: 'கொங்கு சமுதாய முன்னோடிகள் பிறந்த நாள் மற்றும் நினைவு நாள் விழா நடத்துதல்.',
                  ),
                  const Divider(height: 18),
                  _buildServiceItem(
                    icon: Icons.school_rounded,
                    text: 'கலிங்கராயன் கல்வி உதவித்திட்டம்.',
                  ),
                  const Divider(height: 18),
                  _buildServiceItem(
                    icon: Icons.card_membership_rounded,
                    text: 'கொங்குவேளாளர் பாலிடெக்னிக் கல்லூரியில் மாணவர்களுக்கு கொங்கு அறக்கட்டளை கல்லூரி கட்டணம் இன்றி பயில இட ஒதுக்கீடு செய்தல்.',
                  ),
                  const Divider(height: 18),
                  _buildServiceItem(
                    icon: Icons.savings_rounded,
                    text: 'பொருளாதாரத்தில் பின் தங்கிய மாணவர்களுக்கு வருடாந்திர கல்வி நிதியுதவி வழங்குதல்.',
                  ),
                  const Divider(height: 18),
                  _buildServiceItem(
                    icon: Icons.work_rounded,
                    text: 'இளைஞர்களுக்கு வேலைவாய்ப்பு சேவை.',
                  ),
                  const Divider(height: 18),
                  _buildServiceItem(
                    icon: Icons.campaign_rounded,
                    text: 'கொங்கு சமுதாய விழிப்புணர்வு சேவை.',
                  ),
                  const Divider(height: 18),
                  _buildServiceItem(
                    icon: Icons.favorite_rounded,
                    text: 'கொங்கு கூட்டமைப்பு திருமணத் தகவல் மையம் சேவை.',
                  ),
                  const Divider(height: 18),
                  _buildServiceItem(
                    icon: Icons.medical_services_rounded,
                    text: 'இலவச மருத்துவ சேவை.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Footer Summary Card in App Primary Orange accent
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.volunteer_activism_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'ஆகிய சேவைத்திட்டங்கள் கொங்கு சமுதாயத்திற்காக செயல்படுத்தி வருகின்றோம்.',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildOrgDetailRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
