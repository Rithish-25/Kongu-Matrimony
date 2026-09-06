import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../widgets/appbar/custom_app_bar.dart';

class AboutKonguKootamaipuScreen extends StatelessWidget {
  const AboutKonguKootamaipuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar(
        title: 'கூட்டமைப்பு பற்றி (About Us)',
        isMainScreen: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HERO HEADER CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFE65100)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                    padding: const EdgeInsets.all(10),
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
                      width: 110,
                      height: 110,
                      child: Image.asset(
                        'assets/home-logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/app-logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'கொங்கு வேளாளர் சங்கங்கள் கூட்டமைப்பு',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'கூட்டமைப்பு வரலாறும் செயல்பாடுகளும்',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // --- OFFICE & CONTACT DETAILS CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: AppConstants.cardShadow,
              ),
              child: Column(
                children: [
                  _buildContactRow(
                    icon: Icons.location_city_rounded,
                    title: 'பதிவு அலுவலகம்',
                    detail: 'J-1, 3-வது மெயின் ரோடு, அண்ணா நகர் மேற்கு, சென்னை - 600102',
                  ),
                  const Divider(height: 22, color: Color(0xFFF1F5F9)),
                  _buildContactRow(
                    icon: Icons.business_rounded,
                    title: 'தலைமை அலுவலகம்',
                    detail: '123/1, தந்தை பெரியார் நகர், நரசிம்மபுரம், ஈரோடு.',
                  ),
                  const Divider(height: 22, color: Color(0xFFF1F5F9)),
                  _buildContactRow(
                    icon: Icons.phone_android_rounded,
                    title: 'செல்பேசி எண்',
                    detail: '9443498799',
                    isPhone: true,
                  ),
                  const Divider(height: 22, color: Color(0xFFF1F5F9)),
                  _buildContactRow(
                    icon: Icons.verified_user_rounded,
                    title: 'பதிவு விவரம்',
                    detail: 'தோற்றம்: 21-03-2004 | அரசு பதிவு எண்: 194 / 2004 (37 உறுப்பு சங்கங்கள்)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- HISTORY & FOUNDATION CARD ---
            _buildSectionHeader('கூட்டமைப்பு வரலாறு & உருவாக்கம்', Icons.history_edu_rounded),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: AppConstants.cardShadow,
              ),
              child: Text(
                'கொங்கு வேளாளர் சமுதாய மக்களின் முன்னேற்றத்திற்காக, சமூகத்தில் இயங்கும் கொங்கு வேளாளர் சங்கங்களை ஒருங்கிணைத்து செயலாற்றவேண்டும் என கொங்கு வேளாளர் சங்கங்களின் கூட்டமைப்பு 21-03-2004 ஆம் ஆண்டு உருவாக்கப்பட்டு, தமிழக அரசு பதிவு எண்: 194 / 2004 மூலம் பதிவுபெற்று 37 கொங்கு வேளாளர் சங்கங்கள் கூட்டமைப்பில் உறுப்பினர்களாக தங்களை இணைத்துக்கொண்டு சிறப்பாக செயலாற்றி வருகிறது.',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- EDUCATION SCHOLARSHIP & STATS CARD ---
            _buildSectionHeader('கல்வி உதவித்தொகை & சாதனைகள்', Icons.school_rounded),
            const SizedBox(height: 10),
            Container(
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
                  Text(
                    'கொங்கு வேளாளர் சங்கங்களின் கூட்டமைப்பின் 2007 ஆம் ஆண்டு முதல் உயர்கல்வி பயிலும் மாணவ, மாணவிகள் கல்லூரி இடங்களுக்கு உதவி பெறுகின்ற தொகை, அரசு பெற்றோரற்ற மாணவ, மாணவிகளுக்கும், உயர்கல்வி பயிலும் இடஒதுக்கீடு பெறாத கொங்கு சமுதாய மாணவ, மாணவிகளுக்கும் மாத தொகையாக வழங்கப்பட்டு வருகிறது.',
                    style: GoogleFonts.roboto(
                      fontSize: 13.5,
                      height: 1.55,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // STATS GRID
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBadge(
                          number: '550',
                          label: 'இலவச உயர்கல்வி பயிலும் மாணவர்கள்',
                          color: const Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatBadge(
                          number: '₹13,20,000',
                          label: 'வருடாந்திர உதவித் தொகை (550 x ₹2,400)',
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBadge(
                          number: '600',
                          label: 'பட்டப்படிப்பு முடித்த மாணவர்கள்',
                          color: const Color(0xFFD97706),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatBadge(
                          number: '1,150',
                          label: 'பயனடைந்த மொத்த மாணவர்கள்',
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFEDD5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.family_restroom_rounded, color: AppColors.primary, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'ஒவ்வொரு மாணவனுக்கும் தாய், தந்தை, சகோதரன்/சகோதரி என 4 உறுப்பினர்கள் கொண்ட குடும்பம் என்ற வகையில் 4,600 பேர் (1,150 குடும்பங்கள்) வாழ்வாதார நிலையில் உயர்ந்திருக்க கூட்டமைப்பு வழி வகுத்துள்ளது. இது கூட்டமைப்பின் மகத்தான சேவையாகும்.',
                            style: GoogleFonts.roboto(
                              fontSize: 13,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFC2410C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- COMMUNITY LEADERS & PUBLICATIONS CARD ---
            _buildSectionHeader('கொங்கு சமுதாய முன்னோடிகள்', Icons.workspace_premium_rounded),
            const SizedBox(height: 10),
            Container(
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
                  Text(
                    'கொங்கு நாட்டின் மாண்புமிகுந்த தலைவர்கள் மற்றும் முன்னோடிகளின் வரலாற்றுச் செய்திகள் மற்றும் உருவப் படங்கள் கூட்டமைப்பின் சார்பில் சிறப்பு வெளியீடாக கொண்டுவரப்பட்டது:',
                    style: GoogleFonts.roboto(
                      fontSize: 13.5,
                      height: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final leaders = const [
                        'கல்வித் தந்தை காலிங்கராயன்',
                        'கொங்குவேள்',
                        'வேளுநாச்சியார்',
                        'தீரன் சின்னமலை',
                        'டாக்டர் சுப்பராயன்',
                        'பொள்ளாச்சி மகாலிங்கம்',
                        'தியாகி குமரன்',
                        'டாக்டர் நா.மகாலிங்கம்',
                        'நாமக்கல் கவிஞர்',
                        'கே.ஏ.செங்கோட்டையன்',
                        'கொங்குவேள் பழனிச்சாமி',
                        'சென்னிமலை சுப்ரமணியம்',
                      ];

                      final isWide = constraints.maxWidth > 520;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWide ? 2 : 1,
                          mainAxisExtent: 44,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: leaders.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.workspace_premium_rounded,
                                    color: AppColors.primary,
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      leaders[index],
                                      style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- MARRIAGE BUREAU CARD ---
            _buildSectionHeader('கொங்கு கூட்டமைப்பு திருமண தகவல் மையம்', Icons.favorite_rounded),
            const SizedBox(height: 10),
            Container(
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
                  Text(
                    'கொங்கு சமுதாய மக்களுக்கு சேவையாற்ற கொங்கு வேளாளர் சங்கங்கள் கூட்டமைப்பின் சார்பில் கொங்கு கூட்டமைப்பு திருமண தகவல் மையம் 25-11-2015 தேதி அன்று சிறப்பாக தொடங்கப்பட்டது.',
                    style: GoogleFonts.roboto(
                      fontSize: 13.5,
                      height: 1.55,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'கூட்டமைப்பு திருமண தகவல் மையத்தில், ஆயிரக்கணக்கான வரன்கள், பதிவேட்டிலும் இணையதளத்திலும் இலவசமாக திருமணத் தகவல் மையம் மூலம் பதிவு செய்யப்பட்டு வருகிறது. ஈரோடு தலைமை அலுவலகத்தில் சிறப்பாக செயல்பட்டு வரும் இச்சேவையில் கொங்கு சமுதாய மக்கள் இலவசப்பதிவு செய்து பயன்பெற வாழ்த்துகின்றோம்.',
                    style: GoogleFonts.roboto(
                      fontSize: 13.5,
                      height: 1.55,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- SERVICE PROJECTS LIST ---
            _buildSectionHeader('கூட்டமைப்பின் சேவை திட்டங்கள்', Icons.auto_awesome_rounded),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: AppConstants.cardShadow,
              ),
              child: Column(
                children: [
                  _buildServiceRow(1, 'இளைஞர்களுக்கு சுயமாகத் தொழில் தொடங்க மற்றும் வேலைவாய்ப்பு திட்டம்.'),
                  const Divider(height: 18, color: Color(0xFFF1F5F9)),
                  _buildServiceRow(2, 'கோவில் விசேஷங்களுக்கு உதவிகள் செய்தல்.'),
                  const Divider(height: 18, color: Color(0xFFF1F5F9)),
                  _buildServiceRow(3, 'மாணவர்களுக்கு கல்வி ஆலோசனை மையங்கள்.'),
                  const Divider(height: 18, color: Color(0xFFF1F5F9)),
                  _buildServiceRow(4, 'விவசாயிகளுக்கு இயற்கை வேளாண்மை கருத்தரங்குகள்.'),
                  const Divider(height: 18, color: Color(0xFFF1F5F9)),
                  _buildServiceRow(5, 'விவசாயிகளுக்கு இலவச விதைக் கருவிகள்.'),
                  const Divider(height: 18, color: Color(0xFFF1F5F9)),
                  _buildServiceRow(6, 'இலவச மருத்துவ முகாம்கள் நடத்துதல்.'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- FOOTER BANNER CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'கொங்கு சமுதாய மக்கள் முன்னேற்றத்திற்காக சேவை திட்டங்களை கொங்கு கூட்டமைப்பு என்றும் தொடர்ந்து செய்யும்!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'கொங்கு வெல்லட்டும் ! எங்கும் ஜெயிக்கட்டும்!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF9A3412),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String detail,
    bool isPhone = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: GoogleFonts.roboto(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isPhone ? AppColors.primary : AppColors.textPrimary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatBadge({
    required String number,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow(int index, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(top: 1),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$index',
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.roboto(
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
