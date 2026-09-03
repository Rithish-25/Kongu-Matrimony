import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/assets/mock_data.dart';
import '../../core/navigation/app_page_route.dart';
import '../../core/localization/app_language.dart';
import '../../widgets/app_profile_image.dart';
import '../profile_details/profile_details_screen.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final Map<String, String> _customStatuses = {};
  int _receivedPageIndex = 0;
  int _sentPageIndex = 0;
  late PageController _receivedPageController;
  late PageController _sentPageController;

  @override
  void initState() {
    super.initState();
    _receivedPageController = PageController(viewportFraction: 0.84);
    _sentPageController = PageController(viewportFraction: 0.84);
  }

  @override
  void dispose() {
    _receivedPageController.dispose();
    _sentPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: AppLanguageController.notifier,
      builder: (context, currentLang, _) {
        return ValueListenableBuilder<List<Profile>>(
          valueListenable: ProfileDatabase.notifier,
          builder: (context, profiles, _) {
            final receivedProfiles =
                profiles.where((p) => p.interestStatus == 'received').toList();
            final sentProfiles =
                profiles.where((p) => p.interestStatus == 'sent').toList();
            final acceptedProfiles =
                profiles.where((p) => p.interestStatus == 'accepted').toList();

            final receivedItems = _getReceivedItems(receivedProfiles, acceptedProfiles);
            final sentItems = _getSentItems(sentProfiles);

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: const Color(0xFFF8FAFC),
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(52),
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                      unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLanguageController.text('Received')),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${receivedItems.length}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLanguageController.text('Sent')),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.textSecondary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${sentItems.length}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    // Received Tab - Swipeable Cards with Nav Arrows
                    _buildSwipeableCardView(
                      receivedItems,
                      isReceived: true,
                      pageController: _receivedPageController,
                      currentIndex: _receivedPageIndex,
                      onPageChanged: (idx) => setState(() => _receivedPageIndex = idx),
                    ),

                    // Sent Tab - Swipeable Cards with Nav Arrows
                    _buildSwipeableCardView(
                      sentItems,
                      isReceived: false,
                      pageController: _sentPageController,
                      currentIndex: _sentPageIndex,
                      onPageChanged: (idx) => setState(() => _sentPageIndex = idx),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<InboxItem> _getReceivedItems(
    List<Profile> receivedProfiles,
    List<Profile> acceptedProfiles,
  ) {
    final yrsText = AppLanguageController.text('yrs');
    final koottamText = AppLanguageController.text('Koottam');

    final List<InboxItem> allCandidates = [
      ...acceptedProfiles.map(
        (p) => InboxItem(
          name: p.name,
          id: p.id,
          meta: '${p.age} $yrsText, ${p.heightText} • ${AppLanguageController.text(p.occupation)}',
          subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text(p.location)}',
          message: 'Accepted connection request. Let\'s converse.',
          status: _customStatuses[p.id] ?? 'Accepted',
          avatarUrl: p.profileImageUrl,
          timeAgo: 'few mins ago',
          profile: p,
        ),
      ),
      InboxItem(
        name: 'R Mani K',
        id: 'km-manik',
        meta: '29 $yrsText, 5\' 6" • ${AppLanguageController.text('Business Owner / Entrepreneur')}',
        subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Salem, Tamil Nadu')}',
        message: 'R Mani K has sent you an interest request.',
        status: _customStatuses['km-manik'] ?? 'New',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80',
        timeAgo: 'few mins ago',
        isPremium: true,
      ),
      InboxItem(
        name: 'Malavika V',
        id: 'km-malavika',
        meta: '24 $yrsText, 5\' 4" • Sathandhai $koottamText',
        subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Coimbatore, Tamil Nadu')}',
        message: 'Hi, I would like to connect with your profile.',
        status: _customStatuses['km-malavika'] ?? 'Accepted',
        avatarUrl:
            'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=500&auto=format&fit=crop&q=80',
        timeAgo: '10 mins ago',
      ),
      InboxItem(
        name: 'Neha P',
        id: 'km-neha',
        meta: '25 $yrsText, 5\' 3" • Sengunthar',
        subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Erode, Tamil Nadu')}',
        message: 'Hi, I would like to connect with your profile.',
        status: _customStatuses['km-neha'] ?? 'Accepted',
        avatarUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
        timeAgo: '1 hr ago',
      ),
      ...receivedProfiles.map(
        (p) => InboxItem(
          name: p.name,
          id: p.id,
          meta: '${p.age} $yrsText, ${p.heightText} • ${p.koottam} $koottamText',
          subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text(p.location)}',
          message: 'Hello! I am matching your Koottam. Let\'s view horoscopes.',
          status: _customStatuses[p.id] ?? 'New',
          avatarUrl: p.profileImageUrl,
          timeAgo: '2 hrs ago',
          profile: p,
        ),
      ),
      InboxItem(
        name: 'Priya K',
        id: 'km-priya',
        meta: '23 $yrsText, 5\' 2" • Kannandhai $koottamText',
        subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Salem, Tamil Nadu')}',
        message: 'Expressed interest in your profile.',
        status: _customStatuses['km-priya'] ?? 'New',
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&auto=format&fit=crop&q=80',
        timeAgo: '3 hrs ago',
      ),
      InboxItem(
        name: 'Shilpa B',
        id: 'km-shilpa',
        meta: '26 $yrsText, 5\' 5" • Pavalam $koottamText',
        subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Tiruppur, Tamil Nadu')}',
        message: 'Viewed your profile and would love to exchange horoscopes.',
        status: _customStatuses['km-shilpa'] ?? 'New',
        avatarUrl:
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&auto=format&fit=crop&q=80',
        timeAgo: '5 hrs ago',
      ),
    ];

    return allCandidates
        .where((item) =>
            !ProfileDatabase.isBlocked(item.id) &&
            !ProfileDatabase.isBlocked(item.id.toLowerCase()) &&
            item.status.toLowerCase() != 'declined' &&
            item.status.toLowerCase() != 'decline')
        .toList();
  }

  List<InboxItem> _getSentItems(List<Profile> sentProfiles) {
    final yrsText = AppLanguageController.text('yrs');
    final koottamText = AppLanguageController.text('Koottam');

    final List<InboxItem> allCandidates = [
      ...sentProfiles.map(
        (p) => InboxItem(
          name: p.name,
          id: p.id,
          meta: '${p.age} $yrsText, ${p.heightText} • ${p.koottam} $koottamText',
          subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text(p.location)}',
          message: 'You expressed interest in this profile.',
          status: _customStatuses[p.id] ?? 'Pending',
          avatarUrl: p.profileImageUrl,
          timeAgo: 'Today',
          profile: p,
        ),
      ),
      InboxItem(
        name: 'Divya Nachimuthu',
        id: 'p6',
        meta: '24 $yrsText, 5\' 4" • Sathandhai $koottamText',
        subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Coimbatore, Tamil Nadu')}',
        message: 'Interest sent. Awaiting horoscope response.',
        status: _customStatuses['p6'] ?? 'Delivered',
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&auto=format&fit=crop&q=80',
        timeAgo: 'Yesterday',
      ),
    ];

    return allCandidates
        .where((item) =>
            !ProfileDatabase.isBlocked(item.id) &&
            !ProfileDatabase.isBlocked(item.id.toLowerCase()) &&
            item.status.toLowerCase() != 'declined' &&
            item.status.toLowerCase() != 'decline')
        .toList();
  }

  Widget _buildSwipeableCardView(
    List<InboxItem> items, {
    required bool isReceived,
    required PageController pageController,
    required int currentIndex,
    required Function(int) onPageChanged,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textLight.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              AppLanguageController.text('no requests found'),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 8),

        // Swipeable Cards Container with Left & Right Arrow Navigation
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return AnimatedBuilder(
                    animation: pageController,
                    builder: (context, child) {
                      double pageOffset = 0.0;
                      if (pageController.position.haveDimensions) {
                        pageOffset = (pageController.page ?? currentIndex.toDouble()) - index;
                      } else {
                        pageOffset = (currentIndex - index).toDouble();
                      }

                      final double scale = (1.0 - (pageOffset.abs() * 0.07)).clamp(0.90, 1.0);
                      final double opacity = (1.0 - (pageOffset.abs() * 0.25)).clamp(0.70, 1.0);
                      final double translateY = pageOffset.abs() * 4.0;

                      return Transform.translate(
                        offset: Offset(0, translateY),
                        child: Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: opacity,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: _buildSingleInterestCard(item, isReceived: isReceived, pageController: pageController),
                    ),
                  );
                },
              ),

              // Floating Left Arrow Button for Previous Profile
              if (currentIndex > 0)
                Positioned(
                  left: 4,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Material(
                      color: Colors.white,
                      elevation: 5,
                      shape: const CircleBorder(),
                      shadowColor: Colors.black.withValues(alpha: 0.3),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Floating Right Arrow Button for Next Profile
              if (currentIndex < items.length - 1)
                Positioned(
                  right: 4,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Material(
                      color: Colors.white,
                      elevation: 5,
                      shape: const CircleBorder(),
                      shadowColor: Colors.black.withValues(alpha: 0.3),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Bottom Page Indicator / Counter with Arrow Controls
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left Arrow Icon Button
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: currentIndex > 0
                    ? () {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                icon: Icon(
                  Icons.chevron_left_rounded,
                  size: 24,
                  color: currentIndex > 0 ? AppColors.textPrimary : AppColors.border,
                ),
              ),

              const SizedBox(width: 4),

              Text(
                '${currentIndex + 1} / ${items.length}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(width: 8),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  items.length > 8 ? 8 : items.length,
                  (idx) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: idx == currentIndex ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: idx == currentIndex
                          ? AppColors.primary
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // Right Arrow Icon Button
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: currentIndex < items.length - 1
                    ? () {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                icon: Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                  color: currentIndex < items.length - 1 ? AppColors.textPrimary : AppColors.border,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleInterestCard(
    InboxItem item, {
    required bool isReceived,
    required PageController pageController,
  }) {
    final isAccepted = item.status.toLowerCase() == 'accepted';
    final isDeclined = item.status.toLowerCase() == 'declined' || item.status.toLowerCase() == 'decline';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: InkWell(
          onTap: () {
            final profile = item.profile ?? Profile(
              id: item.id.replaceAll('ID:KM-', '').toLowerCase(),
              name: item.name,
              age: 29,
              gender: 'male',
              heightText: "5'6\"",
              koottam: 'Sathandhai',
              location: 'Salem, Tamil Nadu',
              education: 'Business Owner',
              occupation: 'Business Owner / Entrepreneur',
              bio: 'Hello! I am looking for a partner with similar family values.',
              profileImageUrl: item.avatarUrl,
              coverImageUrl:
                  'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&auto=format&fit=crop&q=80',
              horoscopeStar: 'Anusham',
              horoscopeRasi: 'Viruchigam',
              horoscopePaatham: '4',
              subsect: 'Kongu Vellalar Gounder',
              isPremium: item.isPremium,
              isFavourite: false,
              interestStatus: isAccepted ? 'accepted' : (isReceived ? 'received' : 'sent'),
            );

            Navigator.of(context).push(
              appPageRoute(
                ProfileDetailsScreen(
                  profile: profile,
                  heroTag: 'profile-image-${profile.id}-swipe',
                ),
              ),
            );
          },
          child: Column(
            children: [
              // Full Uncropped Photo Container (BoxFit.contain with ambient soft background)
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ambient background
                    Positioned.fill(
                      child: AppProfileImage(
                        imageUrl: item.avatarUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Dark soft overlay on background
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                    // 100% UNCROPPED Foreground Photo
                    Positioned.fill(
                      child: AppProfileImage(
                        imageUrl: item.avatarUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Info & Action Buttons Container
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name Title
                    Text(
                      item.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 2),

                    // Subtitle Line 1
                    Text(
                      item.meta,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 2),

                    // Subtitle Line 2
                    Text(
                      item.subMeta,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6),

                    // Bottom Action Buttons (Red Decline & Green Accept Buttons)
                    if (isReceived)
                      Row(
                        children: [
                          // Red Decline Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isDeclined
                                  ? null
                                  : () {
                                      setState(() {
                                        _customStatuses[item.id] = 'Declined';
                                      });
                                      if (item.profile != null) {
                                        ProfileDatabase.updateInterest(
                                          item.profile!.id,
                                          'declined',
                                        );
                                      }
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${item.name} ${AppLanguageController.text('request declined')}'),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF4444),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              icon: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
                              label: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  isDeclined
                                      ? AppLanguageController.text('declined')
                                      : AppLanguageController.text('decline'),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Green Accept Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isAccepted
                                  ? null
                                  : () async {
                                      setState(() {
                                        _customStatuses[item.id] = 'Accepted';
                                      });
                                      if (item.profile != null) {
                                        ProfileDatabase.updateInterest(
                                          item.profile!.id,
                                          'accepted',
                                        );
                                      }
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${AppLanguageController.text('accepted')} ${item.name}!'),
                                            backgroundColor: const Color(0xFF10B981),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                      if (pageController.hasClients) {
                                        pageController.nextPage(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              icon: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
                              label: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  isAccepted
                                      ? AppLanguageController.text('accepted')
                                      : AppLanguageController.text('accept'),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      // Sent tab status bar with status-based colors
                      _buildStatusPill(item.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    final lowerStatus = status.toLowerCase();
    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData icon;

    if (lowerStatus.contains('accepted')) {
      bgColor = const Color(0xFFECFDF5);
      borderColor = const Color(0xFF6EE7B7);
      textColor = const Color(0xFF047857);
      icon = Icons.check_circle_rounded;
    } else if (lowerStatus.contains('declined') || lowerStatus.contains('decline')) {
      bgColor = const Color(0xFFFEF2F2);
      borderColor = const Color(0xFFFCA5A5);
      textColor = const Color(0xFFB91C1C);
      icon = Icons.cancel_rounded;
    } else if (lowerStatus.contains('delivered')) {
      bgColor = const Color(0xFFEFF6FF);
      borderColor = const Color(0xFF93C5FD);
      textColor = const Color(0xFF1D4ED8);
      icon = Icons.mark_email_read_rounded;
    } else {
      // Pending / New
      bgColor = const Color(0xFFFFF7ED);
      borderColor = const Color(0xFFFDBA74);
      textColor = const Color(0xFFC2410C);
      icon = Icons.access_time_filled_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17, color: textColor),
          const SizedBox(width: 8),
          Text(
            '${AppLanguageController.text('status')}: ${AppLanguageController.text(status)}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class InboxItem {
  final String name;
  final String id;
  final String meta;
  final String subMeta;
  final String message;
  final String status;
  final String avatarUrl;
  final String timeAgo;
  final bool isPremium;
  final Profile? profile;

  InboxItem({
    required this.name,
    required this.id,
    required this.meta,
    required this.subMeta,
    required this.message,
    required this.status,
    required this.avatarUrl,
    required this.timeAgo,
    this.isPremium = false,
    this.profile,
  });
}
