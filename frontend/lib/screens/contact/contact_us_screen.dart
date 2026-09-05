import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/localization/app_language.dart';
import '../../widgets/appbar/custom_app_bar.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  void _handleContactAction(BuildContext context, String title, String detail) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.contact_support_rounded, color: AppColors.primary, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  detail,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$title: $detail'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'OK',
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTamil = AppLanguageController.isTamil;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: isTamil ? 'உதவி & ஆதரவு' : 'Help & Support',
        isMainScreen: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // 1. Phone Number Card
            _buildContactCard(
              context: context,
              icon: Icons.phone_in_talk_rounded,
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF2563EB),
              title: isTamil ? 'தொலைபேசி எண்' : 'Phone Number',
              subtitle: '+91 98765 43210 / 0424 2255889',
              actionLabel: isTamil ? 'அழைக்கவும்' : 'Call Now',
              actionColor: const Color(0xFF2563EB),
              onAction: () => _handleContactAction(
                context,
                isTamil ? 'தொலைபேசி அழைப்பு' : 'Call Helpline',
                '+91 98765 43210',
              ),
            ),

            const SizedBox(height: 14),

            // 2. WhatsApp Support Card
            _buildContactCard(
              context: context,
              icon: Icons.chat_bubble_rounded,
              iconBgColor: const Color(0xFFE8F5E9),
              iconColor: const Color(0xFF25D366),
              title: isTamil ? 'வாட்ஸ்அப் உதவி' : 'WhatsApp Help',
              subtitle: '+91 98765 43210 (Instant Reply)',
              actionLabel: isTamil ? 'வாட்ஸ்அப்பில் அரட்டையடிக்க' : 'Chat on WhatsApp',
              actionColor: const Color(0xFF25D366),
              onAction: () => _handleContactAction(
                context,
                isTamil ? 'வாட்ஸ்அப் உதவி' : 'WhatsApp Support',
                '+91 98765 43210',
              ),
            ),

            const SizedBox(height: 14),

            // 3. Email Address Card
            _buildContactCard(
              context: context,
              icon: Icons.email_rounded,
              iconBgColor: const Color(0xFFFFF7ED),
              iconColor: const Color(0xFFEA580C),
              title: isTamil ? 'மின்னஞ்சல் முகவரி' : 'Email Address',
              subtitle: 'support@kongukootamaipu.org',
              actionLabel: isTamil ? 'மின்னஞ்சல் அனுப்ப' : 'Send Email',
              actionColor: const Color(0xFFEA580C),
              onAction: () => _handleContactAction(
                context,
                isTamil ? 'மின்னஞ்சல் முகவரி' : 'Email Support',
                'support@kongukootamaipu.org',
              ),
            ),

            const SizedBox(height: 14),

            // 4. Office Address Card
            _buildContactCard(
              context: context,
              icon: Icons.location_on_rounded,
              iconBgColor: const Color(0xFFF3E8FF),
              iconColor: const Color(0xFF9333EA),
              title: isTamil ? 'தலைமை அலுவலக முகவரி' : 'Main Office Address',
              subtitle: isTamil
                  ? '124, மேட்டூர் ரோடு, மத்திய பேருந்து நிலையம் எதிரில், ஈரோடு - 638011'
                  : '124, Mettur Road, Opp. Bus Stand, Erode - 638011',
              actionLabel: isTamil ? 'வரைபடம் பார்க்க' : 'View Location',
              actionColor: const Color(0xFF9333EA),
              onAction: () => _handleContactAction(
                context,
                isTamil ? 'தலைமை அலுவலகம்' : 'Office Location',
                '124, Mettur Road, Opp. Bus Stand, Erode - 638011',
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String actionLabel,
    required Color actionColor,
    required VoidCallback onAction,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.roboto(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: actionColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              actionLabel,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
