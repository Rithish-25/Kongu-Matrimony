import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/assets/mock_data.dart';
import '../../core/colors/colors.dart';
import '../../widgets/appbar/custom_app_bar.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _selectedDurationIndex = 0; // 0: 3 Months, 1: 6 Months, 2: 12 Months
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.82, initialPage: 0);
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

  final List<String> _durations = ['3 Months', '6 Months', '12 Months'];
  final List<String?> _durationBadges = [null, 'SAVE 15%', 'SAVE 25%'];

  List<_PlanModel> _getPlansForDuration(int index) {
    if (index == 0) {
      // 3 Months
      return [
        _PlanModel(
          name: 'Gold',
          planCode: 'Gold',
          originalPrice: '₹ 2,999',
          discountText: 'Discount (10%)',
          discountAmount: '₹ 300',
          finalPrice: '₹ 2,699',
          isPopular: false,
          badgeText: 'RECOMMENDED',
          downloads: 10,
          features: [
            'Send unlimited messages, chat and make video calls',
            'Access 40 verified mobile numbers',
            'View unlimited horoscopes',
          ],
        ),
        _PlanModel(
          name: 'Diamond',
          planCode: 'Diamond',
          originalPrice: '₹ 4,499',
          discountText: 'Discount (15%)',
          discountAmount: '₹ 675',
          finalPrice: '₹ 3,824',
          isPopular: true,
          badgeText: 'MOST POPULAR',
          downloads: 15,
          features: [
            'Send unlimited messages, chat and make video calls',
            'Access 50 verified mobile numbers',
            'View unlimited horoscopes',
            'Priority profile listing in search results',
          ],
        ),
        _PlanModel(
          name: 'Platinum',
          planCode: 'Platinum',
          originalPrice: '₹ 5,999',
          discountText: 'Discount (20%)',
          discountAmount: '₹ 1,200',
          finalPrice: '₹ 4,799',
          isPopular: false,
          badgeText: 'BEST VALUE',
          downloads: 20,
          features: [
            'Send unlimited messages, chat and make video calls',
            'Access 80 verified mobile numbers',
            'View unlimited horoscopes',
            '3 months FREE Profile Highlighter & Top Rank',
          ],
        ),
        _PlanModel(
          name: 'Assisted Service',
          planCode: 'Assisted',
          originalPrice: '₹ 14,999',
          discountText: null,
          discountAmount: null,
          finalPrice: '₹ 14,999',
          isPopular: false,
          badgeText: 'VIP ASSISTED',
          downloads: 50,
          features: [
            'Dedicated Relationship Manager who shortlists, connects & schedules meetings',
            'Get matches from our Kongu community network',
            'Increase the chance of finding your life partner by 3 times',
          ],
        ),
      ];
    } else if (index == 1) {
      // 6 Months
      return [
        _PlanModel(
          name: 'Gold',
          planCode: 'Gold',
          originalPrice: '₹ 5,499',
          discountText: 'Discount (15%)',
          discountAmount: '₹ 825',
          finalPrice: '₹ 4,674',
          isPopular: false,
          badgeText: 'RECOMMENDED',
          downloads: 25,
          features: [
            'Send unlimited messages, chat and make video calls',
            'Access 80 verified mobile numbers',
            'View unlimited horoscopes',
          ],
        ),
        _PlanModel(
          name: 'Diamond',
          planCode: 'Diamond',
          originalPrice: '₹ 7,999',
          discountText: 'Discount (20%)',
          discountAmount: '₹ 1,600',
          finalPrice: '₹ 6,399',
          isPopular: true,
          badgeText: 'MOST POPULAR',
          downloads: 35,
          features: [
            'Send unlimited messages, chat and make video calls',
            'Access 100 verified mobile numbers',
            'View unlimited horoscopes',
            'Priority profile listing in search results',
          ],
        ),
        _PlanModel(
          name: 'Platinum',
          planCode: 'Platinum',
          originalPrice: '₹ 9,999',
          discountText: 'Discount (25%)',
          discountAmount: '₹ 2,500',
          finalPrice: '₹ 7,499',
          isPopular: false,
          badgeText: 'BEST VALUE',
          downloads: 50,
          features: [
            'Send unlimited messages, chat and make video calls',
            'Access 160 verified mobile numbers',
            'View unlimited horoscopes',
            '6 months FREE Profile Highlighter & Top Rank',
          ],
        ),
        _PlanModel(
          name: 'Assisted Service',
          planCode: 'Assisted',
          originalPrice: '₹ 24,999',
          discountText: 'Discount (10%)',
          discountAmount: '₹ 2,500',
          finalPrice: '₹ 22,499',
          isPopular: false,
          badgeText: 'VIP ASSISTED',
          downloads: 100,
          features: [
            'Dedicated Relationship Manager who shortlists, connects & schedules meetings',
            'Get matches from our Kongu community network',
            'Increase the chance of finding your life partner by 3 times',
          ],
        ),
      ];
    } else {
      // 12 Months
      return [
        _PlanModel(
          name: 'Gold',
          planCode: 'Gold',
          originalPrice: '₹ 8,999',
          discountText: 'Discount (25%)',
          discountAmount: '₹ 2,250',
          finalPrice: '₹ 6,749',
          isPopular: false,
          badgeText: 'ANNUAL SAVER',
          downloads: 60,
          features: [
            'Send unlimited messages, chat and make video calls',
            'Access 150 verified mobile numbers',
            'View unlimited horoscopes',
          ],
        ),
        _PlanModel(
          name: 'Diamond',
          planCode: 'Diamond',
          originalPrice: '₹ 12,999',
          discountText: 'Discount (30%)',
          discountAmount: '₹ 3,900',
          finalPrice: '₹ 9,099',
          isPopular: true,
          badgeText: 'MOST POPULAR',
          downloads: 80,
          features: [
            'Send unlimited messages, chat and make video calls',
            'Access 200 verified mobile numbers',
            'View unlimited horoscopes',
            '1 Year Priority profile listing in search results',
          ],
        ),
        _PlanModel(
          name: 'Platinum',
          planCode: 'Platinum',
          originalPrice: '₹ 15,999',
          discountText: 'Discount (35%)',
          discountAmount: '₹ 5,600',
          finalPrice: '₹ 10,399',
          isPopular: false,
          badgeText: 'MAX SAVINGS',
          downloads: 120,
          features: [
            'Send unlimited messages, chat and make video calls',
            'Access Unlimited verified mobile numbers',
            'View unlimited horoscopes',
            '12 months FREE Profile Highlighter & VIP Rank',
          ],
        ),
        _PlanModel(
          name: 'Assisted Service',
          planCode: 'Assisted',
          originalPrice: '₹ 39,999',
          discountText: 'Discount (15%)',
          discountAmount: '₹ 6,000',
          finalPrice: '₹ 33,999',
          isPopular: false,
          badgeText: 'VIP ASSISTED',
          downloads: 250,
          features: [
            'Dedicated Relationship Manager who shortlists, connects & schedules meetings',
            'Get matches from our Kongu community network',
            'Increase the chance of finding your life partner by 3 times',
          ],
        ),
      ];
    }
  }

  void _onPayNow(_PlanModel plan) {
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
          'Confirm activation of ${plan.name} Plan for ${plan.finalPrice} (${_durations[_selectedDurationIndex]})?\n\nYou will get ${plan.downloads} horoscope downloads and full premium benefits.',
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
    final plans = _getPlansForDuration(_selectedDurationIndex);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Premium Membership',
        isMainScreen: false,
      ),
      body: ValueListenableBuilder<UserProfileState>(
        valueListenable: ProfileDatabase.userProfileNotifier,
        builder: (context, userProfile, _) {
          return Column(
            children: [
              const SizedBox(height: 8),

              // Smooth Sliding Duration Selector
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
                    final tabWidth = constraints.maxWidth / _durations.length;

                    return Stack(
                      children: [
                        // Smooth sliding dark red indicator
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                          left: _selectedDurationIndex * tabWidth,
                          top: 0,
                          bottom: 0,
                          width: tabWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x407A102A),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Content Row
                        Row(
                          children: List.generate(_durations.length, (index) {
                            final isSelected = _selectedDurationIndex == index;
                            final badge = _durationBadges[index];

                            return Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setState(() {
                                    _selectedDurationIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 250),
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12.5,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                            color: isSelected ? Colors.white : AppColors.textPrimary,
                                          ),
                                          child: Text(_durations[index]),
                                        ),
                                        if (badge != null) ...[
                                          const SizedBox(width: 4),
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 250),
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.secondary.withValues(alpha: 0.3)
                                                  : AppColors.primarySoft,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: isSelected
                                                    ? AppColors.secondaryLight
                                                    : AppColors.primaryLight.withValues(alpha: 0.3),
                                              ),
                                            ),
                                            child: Text(
                                              badge,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected ? Colors.white : AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
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

              const SizedBox(height: 8),

              // Horizontal Swipeable Cards Container
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: plans.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      final isCurrentActive =
                          userProfile.plan.toLowerCase() ==
                          plan.planCode.toLowerCase();

                      // Dynamic 3D depth and scale transformation during swiping
                      double pageOffset = 0.0;
                      if (_pageController.position.haveDimensions) {
                        pageOffset =
                            (_pageController.page ??
                                _currentPage.toDouble()) -
                            index;
                      } else {
                        pageOffset = (_currentPage - index).toDouble();
                      }

                      final double scale =
                          (1.0 - (pageOffset.abs() * 0.08)).clamp(0.90, 1.0);
                      final double opacity =
                          (1.0 - (pageOffset.abs() * 0.25)).clamp(0.65, 1.0);
                      final double translateY = pageOffset.abs() * 6.0;

                      return Transform.translate(
                        offset: Offset(0, translateY),
                        child: Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: opacity,
                            child: _buildPlanCard(plan, isCurrentActive),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Page indicator dots
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(plans.length, (index) {
                    final isSelected = _currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isSelected ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),

              // Trust badge footer
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
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
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1F7A102A),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              // Top Gradient Banner Container for all plans
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4.5),
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                alignment: Alignment.center,
                child: Text(
                  plan.badgeText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // Card Body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Plan Title & Original Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            plan.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            plan.originalPrice,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      const Divider(height: 1, color: AppColors.divider),
                      const SizedBox(height: 10),

                      // Feature Checklist
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: plan.features.map((feature) {
                              IconData iconData = Icons.chat_bubble_outline_rounded;
                              if (feature.contains('mobile numbers')) {
                                iconData = Icons.phone_android_rounded;
                              } else if (feature.contains('horoscopes')) {
                                iconData = Icons.auto_awesome_outlined;
                              } else if (feature.contains('Highlighter') || feature.contains('Priority')) {
                                iconData = Icons.verified_user_outlined;
                              } else if (feature.contains('Relationship Manager')) {
                                iconData = Icons.support_agent_rounded;
                              } else if (feature.contains('Kongu community')) {
                                iconData = Icons.people_outline_rounded;
                              } else if (feature.contains('chance of finding')) {
                                iconData = Icons.volunteer_activism_outlined;
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      iconData,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: AppColors.textPrimary,
                                          height: 1.35,
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

                      const SizedBox(height: 8),

                      // Pricing breakdown Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundAlt,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  plan.originalPrice,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            if (plan.discountText != null && plan.discountAmount != null) ...[
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    plan.discountText!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.success,
                                    ),
                                  ),
                                  Text(
                                    plan.discountAmount!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 5),
                            const Divider(height: 1, color: AppColors.border),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'You pay',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  plan.finalPrice,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // PAY NOW > Action Button
                      Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x337A102A),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _onPayNow(plan),
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'PAY NOW',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Offer validity footer
                      Center(
                        child: Text(
                          'Offer valid for limited period',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: AppColors.textLight,
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
      ),
    );
  }
}

class _PlanModel {
  final String name;
  final String planCode;
  final String originalPrice;
  final String? discountText;
  final String? discountAmount;
  final String finalPrice;
  final bool isPopular;
  final String badgeText;
  final int downloads;
  final List<String> features;

  _PlanModel({
    required this.name,
    required this.planCode,
    required this.originalPrice,
    required this.discountText,
    required this.discountAmount,
    required this.finalPrice,
    required this.isPopular,
    required this.badgeText,
    required this.downloads,
    required this.features,
  });
}
