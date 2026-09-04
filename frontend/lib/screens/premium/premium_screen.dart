import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/assets/mock_data.dart';
import '../../core/colors/colors.dart';
import '../../core/localization/app_language.dart';
import '../../widgets/appbar/custom_app_bar.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _selectedPlanIndex = 0; // 0: Free, 1: Gold, 2: Diamond, 3: Platinum
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.80, initialPage: 0);
    _pageController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<String> _planTabNames = ['Free', 'Gold', 'Platinum', 'Diamond'];

  List<_PlanModel> _getPlans() {
    return [
      _PlanModel(
        name: 'Free Plan',
        planCode: 'Free',
        finalPrice: '₹ 0',
        monthlyPillText: '₹ 0 / free forever',
        isPopular: false,
        badgeText: 'BASIC MEMBER',
        downloads: 0,
        features: [
          'Cannot view Mobile & Email (Locked)',
          'Cannot view Horoscope charts (Locked)',
          'Cannot view Family & Income (Locked)',
          'Basic profile browsing & express interest',
        ],
      ),
      _PlanModel(
        name: 'Gold',
        planCode: 'Gold',
        finalPrice: '₹ 2,699',
        monthlyPillText: '₹ 900 per month',
        isPopular: false,
        badgeText: 'RECOMMENDED',
        downloads: 40,
        features: [
          'Valid for 3 months',
          'Access 40 verified Phone & Email',
          'Send unlimited messages & chat',
          'Unlimited horoscope views & downloads',
          'View verified profiles with photos',
        ],
      ),
      _PlanModel(
        name: 'Platinum',
        planCode: 'Platinum',
        finalPrice: '₹ 4,799',
        monthlyPillText: '₹ 800 per month',
        isPopular: false,
        badgeText: 'BEST VALUE',
        downloads: 100,
        features: [
          'Valid for 6 months',
          'Access 100 verified Phone & Email',
          'Send unlimited messages & chat',
          'Unlimited horoscope views & downloads',
          'FREE Profile Highlighter & Top Rank',
        ],
      ),
      _PlanModel(
        name: 'Diamond',
        planCode: 'Diamond',
        finalPrice: '₹ 4,000',
        monthlyPillText: '₹ 1,333 per month',
        isPopular: true,
        badgeText: 'MOST POPULAR',
        downloads: 60,
        features: [
          'Valid for 3 months',
          'View unlimited Phone Nos*',
          'Send unlimited messages',
          'Unlimited horoscope views',
          'View verified profiles with photos',
        ],
      ),
    ];
  }

  void _onPayNow(_PlanModel plan) {
    if (plan.planCode.toLowerCase().contains('free')) {
      ProfileDatabase.updateUserProfile(plan: 'Free');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Switched to Free Plan.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.stars_rounded, color: AppColors.secondary, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${plan.name} Plan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Confirm activation of ${plan.name} Plan for ${plan.finalPrice}?\n\nYou will get ${plan.downloads} horoscope downloads and full premium benefits.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await ProfileDatabase.updateUserProfile(
                  plan: plan.planCode,
                  downloadedCount: 0,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Congratulations! ${plan.name} Plan activated successfully.'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.primary,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Confirm Payment',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plans = _getPlans();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Membership Plans',
        isMainScreen: false,
      ),
      body: ValueListenableBuilder<UserProfileState>(
        valueListenable: ProfileDatabase.userProfileNotifier,
        builder: (context, userProfile, _) {
          final selectedTabName = _planTabNames[_selectedPlanIndex].toLowerCase();
          final userActivePlanName = userProfile.plan.toLowerCase();
          final isSelectedTabActivePlan = userActivePlanName.contains(selectedTabName) ||
              (userActivePlanName == 'free' && selectedTabName == 'free');

          return Column(
            children: [
              const SizedBox(height: 10),

              // 4 Plan Boxes Bar (Free, Gold, Platinum, Diamond)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tabWidth = constraints.maxWidth / _planTabNames.length;

                    return Stack(
                      children: [
                        // Smooth sliding active plan indicator
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                          left: _selectedPlanIndex * tabWidth,
                          top: 0,
                          bottom: 0,
                          width: tabWidth,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              gradient: isSelectedTabActivePlan
                                  ? const LinearGradient(
                                      colors: [Color(0xFF026135), Color(0xFF16A34A)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    )
                                  : AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelectedTabActivePlan
                                      ? const Color(0x40026135)
                                      : AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Content Row with 4 Boxes
                        Row(
                          children: List.generate(_planTabNames.length, (index) {
                            final isSelected = _selectedPlanIndex == index;

                            return Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setState(() {
                                    _selectedPlanIndex = index;
                                  });
                                  _pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOutCubic,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 250),
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          color: isSelected ? Colors.white : AppColors.textPrimary,
                                        ),
                                        child: Text(
                                          AppLanguageController.text(_planTabNames[index]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Compact Swipeable Cards Container
              SizedBox(
                height: 425,
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: plans.length,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedPlanIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final userPlanLower = userProfile.plan.toLowerCase();
                    final planCodeLower = plan.planCode.toLowerCase();
                    final planNameLower = plan.name.toLowerCase();
                    final isCurrentActive = userPlanLower == planCodeLower ||
                        userPlanLower.contains(planCodeLower) ||
                        (userPlanLower.contains('free') && (planCodeLower.contains('free') || planNameLower.contains('free')));

                    // Dynamic 3D depth and scale transformation during swiping
                    double pageOffset = 0.0;
                    if (_pageController.position.haveDimensions) {
                      pageOffset =
                          (_pageController.page ??
                              _selectedPlanIndex.toDouble()) -
                          index;
                    } else {
                      pageOffset = (_selectedPlanIndex - index).toDouble();
                    }

                    final double scale =
                        (1.0 - (pageOffset.abs() * 0.08)).clamp(0.88, 1.0);
                    final double opacity =
                        (1.0 - (pageOffset.abs() * 0.25)).clamp(0.65, 1.0);
                    final double translateY = pageOffset.abs() * 6.0;

                    return Transform.translate(
                      offset: Offset(0, translateY),
                      child: Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: _buildPlanCard(plan, isCurrentActive),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Page indicator dots
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(plans.length, (index) {
                    final isSelected = _selectedPlanIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isSelected ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isSelectedTabActivePlan
                                ? const Color(0xFF026135)
                                : const Color(0xFFE65100))
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),

              // Trust badge footer
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '🔒 100% Safe & Secure Checkout • Instant Activation',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlanCard(_PlanModel plan, bool isCurrentActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isCurrentActive ? const Color(0xFF026135) : const Color(0xFFE65100),
          width: isCurrentActive ? 2.5 : 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrentActive
                ? const Color(0xFF026135).withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Top 2 Corners Accent Bar (GREEN for user's current plan, Orange for balance plans)
            Container(
              width: double.infinity,
              height: 6,
              decoration: BoxDecoration(
                gradient: isCurrentActive
                    ? const LinearGradient(
                        colors: [Color(0xFF026135), Color(0xFF16A34A)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFE65100), Color(0xFFF57C00)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
              ),
            ),

            // Main Card Content filling available vertical height
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Plan Name Title
                    Text(
                      AppLanguageController.text(plan.name),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isCurrentActive ? const Color(0xFF026135) : const Color(0xFFE65100),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // 2. Price Row (Big Final Price)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          plan.finalPrice,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // 3. Monthly Price Pill Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF0F2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF5C2C7), width: 0.8),
                      ),
                      child: Text(
                        AppLanguageController.text(plan.monthlyPillText),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4A4A4A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 4. Feature Checklist
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: plan.features.map((feature) {
                            final isNegative = feature.startsWith('Cannot');

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 9),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    isNegative ? Icons.close_rounded : Icons.check_rounded,
                                    size: 18,
                                    color: isNegative ? Colors.red.shade400 : const Color(0xFF2E7D32),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      AppLanguageController.text(feature),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF333333),
                                        height: 1.25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 5. Action Button
                    Container(
                      width: double.infinity,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: isCurrentActive
                            ? null
                            : AppColors.primaryGradient,
                        color: isCurrentActive ? Colors.teal.shade800 : null,
                        boxShadow: [
                          BoxShadow(
                            color: isCurrentActive
                                ? Colors.teal.withValues(alpha: 0.3)
                                : AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: isCurrentActive ? null : () => _onPayNow(plan),
                          borderRadius: BorderRadius.circular(25),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isCurrentActive) ...[
                                  const Icon(Icons.check_circle_rounded, size: 16, color: Colors.white),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  isCurrentActive
                                      ? AppLanguageController.text('CURRENT PLAN')
                                      : (plan.planCode.toLowerCase().contains('free')
                                          ? AppLanguageController.text('SELECT FREE PLAN')
                                          : AppLanguageController.text('Pay Now')),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanModel {
  final String name;
  final String planCode;
  final String finalPrice;
  final String monthlyPillText;
  final bool isPopular;
  final String badgeText;
  final int downloads;
  final List<String> features;

  _PlanModel({
    required this.name,
    required this.planCode,
    required this.finalPrice,
    required this.monthlyPillText,
    required this.isPopular,
    required this.badgeText,
    required this.downloads,
    required this.features,
  });
}
