import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
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
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  detail,
                  style: GoogleFonts.roboto(
                    fontSize: 14.5,
                    height: 1.45,
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
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
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
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: AppLanguageController.notifier,
      builder: (context, language, child) {
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
                const SizedBox(height: 4),

                // 1. Phone Numbers Card (Both Landline & Cell)
                _buildContactCard(
                  context: context,
                  icon: Icons.phone_in_talk_rounded,
                  iconBgColor: AppColors.primary,
                  title: isTamil ? 'தொலைபேசி எண்கள் (Phone Numbers)' : 'Phone Numbers',
                  subtitle: isTamil ? 'போன் : 0424 - 3553376' : 'Landline: 0424 - 3553376',
                  secondarySubtitle: isTamil ? 'செல் : +91 94434 - 98799' : 'Mobile: +91 94434 - 98799',
                  actionLabel: isTamil ? 'அழைக்கவும்' : 'Call Now',
                  actionColor: const Color(0xFF2563EB),
                  onAction: () => _handleContactAction(
                    context,
                    isTamil ? 'தொலைபேசி எண்கள்' : 'Call Helpline',
                    '0424 - 3553376 / +91 94434 - 98799',
                  ),
                ),

                const SizedBox(height: 16),

                // 2. WhatsApp Support Card
                _buildContactCard(
                  context: context,
                  icon: Icons.chat_bubble_rounded,
                  iconBgColor: const Color(0xFF25D366),
                  title: isTamil ? 'வாட்ஸ்அப் உதவி (WhatsApp Help)' : 'WhatsApp Help',
                  subtitle: '+91 94434 - 98799',
                  actionLabel: isTamil ? 'வாட்ஸ்அப்பில் தொடர்புகொள்ள' : 'Chat on WhatsApp',
                  actionColor: const Color(0xFF25D366),
                  onAction: () => _handleContactAction(
                    context,
                    isTamil ? 'வாட்ஸ்அப் உதவி' : 'WhatsApp Support',
                    '+91 94434 - 98799',
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Email Address Card
                _buildContactCard(
                  context: context,
                  icon: Icons.email_rounded,
                  iconBgColor: const Color(0xFFEA580C),
                  title: isTamil ? 'மின்னஞ்சல் முகவரி (Email Address)' : 'Email Address',
                  subtitle: 'supportkdsk@gmail.com',
                  actionLabel: isTamil ? 'மின்னஞ்சல் அனுப்ப' : 'Send Email',
                  actionColor: const Color(0xFFEA580C),
                  onAction: () => _handleContactAction(
                    context,
                    isTamil ? 'மின்னஞ்சல் முகவரி' : 'Email Support',
                    'supportkdsk@gmail.com',
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Main Office Address Card (No Action Button as requested)
                _buildContactCard(
                  context: context,
                  icon: Icons.location_on_rounded,
                  iconBgColor: const Color(0xFF9333EA),
                  title: isTamil ? 'தலைமை அலுவலக முகவரி (Office Address)' : 'Main Office Address',
                  subtitle: isTamil
                      ? 'பிரைட் காம்ப்ளக்ஸ், 123/1, சஞ்சய் நகர், நசியனூர் ரோடு, கலைமகள் திருமண மண்டபம் அருகில், ஈரோடு - 638 011.'
                      : 'Bright Complex, 123/1, Sanjay Nagar, Nasiyanur Road, Near Kalaimagal Thirumana Mandapam, Erode - 638 011.',
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    String? secondarySubtitle,
    String? actionLabel,
    Color? actionColor,
    VoidCallback? onAction,
  }) {
    final bool hasAction = actionLabel != null && actionLabel.isNotEmpty && onAction != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: AppConstants.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconBgColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          if (secondarySubtitle != null && secondarySubtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              secondarySubtitle,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ],
          if (hasAction) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: actionColor ?? AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  icon == Icons.phone_in_talk_rounded
                      ? Icons.call_rounded
                      : icon == Icons.chat_bubble_rounded
                          ? Icons.message_rounded
                          : icon == Icons.email_rounded
                              ? Icons.send_rounded
                              : Icons.near_me_rounded,
                  size: 18,
                ),
                label: Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      actionLabel,
                      style: GoogleFonts.roboto(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
