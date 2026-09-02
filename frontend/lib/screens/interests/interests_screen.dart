import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/assets/mock_data.dart';
import '../../core/navigation/app_page_route.dart';
import '../profile_details/profile_details_screen.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final Map<String, String> _customStatuses = {};

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: Colors.white,
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
                          const Text('Received'),
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
                          const Text('Sent'),
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
                // Received Tab
                _buildInboxListView(receivedItems, isReceived: true),

                // Sent Tab
                _buildInboxListView(sentItems, isReceived: false),
              ],
            ),
          ),
        );
      },
    );
  }

  List<InboxItem> _getReceivedItems(
    List<Profile> receivedProfiles,
    List<Profile> acceptedProfiles,
  ) {
    final List<InboxItem> allCandidates = [
      ...acceptedProfiles.map(
        (p) => InboxItem(
          name: p.name,
          id: p.id,
          meta: '${p.age} yrs • ${p.koottam} Koottam',
          message: 'Accepted connection request. Let\'s converse.',
          status: _customStatuses[p.id] ?? 'Accepted',
          avatarUrl: p.profileImageUrl,
          profile: p,
        ),
      ),
      InboxItem(
        name: 'Malavika V',
        id: 'km-malavika',
        meta: '24 yrs • Sathandhai Koottam • Coimbatore',
        message: 'Hi, I would like to connect with your profile.',
        status: _customStatuses['km-malavika'] ?? 'Accepted',
        avatarUrl:
            'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=500&auto=format&fit=crop&q=80',
      ),
      InboxItem(
        name: 'Neha P',
        id: 'km-neha',
        meta: '25 yrs • Sengunthar • Erode',
        message: 'Hi, I would like to connect with your profile.',
        status: _customStatuses['km-neha'] ?? 'Accepted',
        avatarUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
      ),
      ...receivedProfiles.map(
        (p) => InboxItem(
          name: p.name,
          id: p.id,
          meta: '${p.age} yrs • ${p.koottam} Koottam',
          message: 'Hello! I am matching your Koottam. Let\'s view horoscopes.',
          status: _customStatuses[p.id] ?? 'New',
          avatarUrl: p.profileImageUrl,
          profile: p,
        ),
      ),
      InboxItem(
        name: 'Priya K',
        id: 'km-priya',
        meta: '23 yrs • Kannandhai Koottam • Salem',
        message: 'Expressed interest in your profile. Looking forward to connect.',
        status: _customStatuses['km-priya'] ?? 'New',
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&auto=format&fit=crop&q=80',
      ),
      InboxItem(
        name: 'Shilpa B',
        id: 'km-shilpa',
        meta: '26 yrs • Pavalam Koottam • Tiruppur',
        message: 'Viewed your profile and would love to exchange horoscopes.',
        status: _customStatuses['km-shilpa'] ?? 'New',
        avatarUrl:
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&auto=format&fit=crop&q=80',
      ),
      InboxItem(
        name: 'Mithra T',
        id: 'km-mithra',
        meta: '24 yrs • Sembuthan Koottam • Namakkal',
        message: 'Hi, I would like to connect with your profile.',
        status: _customStatuses['km-mithra'] ?? 'New',
        avatarUrl:
            'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=500&auto=format&fit=crop&q=80',
      ),
      InboxItem(
        name: 'Ramya A',
        id: 'km-ramya',
        meta: '25 yrs • Kadai Koottam • Karur',
        message: 'Hi, I would like to connect with your profile.',
        status: _customStatuses['km-ramya'] ?? 'New',
        avatarUrl:
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&auto=format&fit=crop&q=80',
      ),
    ];

    return allCandidates
        .where((item) =>
            !ProfileDatabase.isBlocked(item.id) &&
            !ProfileDatabase.isBlocked(item.id.toLowerCase()))
        .toList();
  }

  List<InboxItem> _getSentItems(List<Profile> sentProfiles) {
    final List<InboxItem> allCandidates = [
      ...sentProfiles.map(
        (p) => InboxItem(
          name: p.name,
          id: p.id,
          meta: '${p.age} yrs • ${p.koottam} Koottam',
          message: 'You expressed interest in this profile.',
          status: _customStatuses[p.id] ?? 'Pending',
          avatarUrl: p.profileImageUrl,
          profile: p,
        ),
      ),
      InboxItem(
        name: 'Divya Nachimuthu',
        id: 'p6',
        meta: '24 yrs • Sathandhai Koottam • Coimbatore',
        message: 'Interest sent. Awaiting horoscope response.',
        status: _customStatuses['p6'] ?? 'Delivered',
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&auto=format&fit=crop&q=80',
      ),
    ];

    return allCandidates
        .where((item) =>
            !ProfileDatabase.isBlocked(item.id) &&
            !ProfileDatabase.isBlocked(item.id.toLowerCase()))
        .toList();
  }

  Widget _buildInboxListView(List<InboxItem> items, {required bool isReceived}) {
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
              'No requests found',
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

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InboxListCard(item: item);
      },
    );
  }
}

class InboxItem {
  final String name;
  final String id;
  final String meta;
  final String message;
  final String status;
  final String avatarUrl;
  final Profile? profile;

  InboxItem({
    required this.name,
    required this.id,
    required this.meta,
    required this.message,
    required this.status,
    required this.avatarUrl,
    this.profile,
  });
}

class InboxListCard extends StatelessWidget {
  final InboxItem item;

  const InboxListCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    // Custom Badge configuration
    Color badgeBg;
    Color badgeBorder;
    Color textColor;
    IconData badgeIcon;

    if (item.status == 'Accepted') {
      badgeBg = const Color(0xFFE8F5E9);
      badgeBorder = const Color(0xFFA5D6A7);
      textColor = const Color(0xFF2E7D32);
      badgeIcon = Icons.check_circle_rounded;
    } else if (item.status == 'Decline' || item.status == 'Declined') {
      badgeBg = const Color(0xFFFFEBEE);
      badgeBorder = const Color(0xFFFFCDD2);
      textColor = const Color(0xFFC62828);
      badgeIcon = Icons.cancel_outlined;
    } else if (item.status == 'New') {
      badgeBg = const Color(0xFFE3F2FD);
      badgeBorder = const Color(0xFF90CAF9);
      textColor = const Color(0xFF1565C0);
      badgeIcon = Icons.auto_awesome_rounded;
    } else if (item.status == 'Pending') {
      badgeBg = const Color(0xFFFFF8E1);
      badgeBorder = const Color(0xFFFFE082);
      textColor = const Color(0xFFF57F17);
      badgeIcon = Icons.schedule_rounded;
    } else {
      badgeBg = const Color(0xFFEDE7F6);
      badgeBorder = const Color(0xFFD1C4E9);
      textColor = const Color(0xFF512DA8);
      badgeIcon = Icons.done_all_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            final profile = item.profile ?? Profile(
              id: item.id.replaceAll('ID:KM-', '').toLowerCase(),
              name: item.name,
              age: 24,
              gender: 'female',
              heightText: "5'5\"",
              koottam: 'Sathandhai',
              location: 'Coimbatore',
              education: 'M.B.A. Graduate',
              occupation: 'Private Sector Professional',
              bio: 'Hello! I am a friendly and family-oriented person looking for a partner with similar values.',
              profileImageUrl: item.avatarUrl,
              coverImageUrl:
                  'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&auto=format&fit=crop&q=80',
              horoscopeStar: 'Anusham',
              horoscopeRasi: 'Viruchigam',
              horoscopePaatham: '4',
              subsect: 'Kongu Vellalar Gounder',
              isPremium: false,
              isFavourite: false,
              interestStatus:
                  item.status.toLowerCase() == 'accepted' ? 'accepted' : 'received',
            );

            Navigator.of(context).push(
              appPageRoute(
                ProfileDetailsScreen(
                  profile: profile,
                  heroTag: 'profile-image-${profile.id}-inbox',
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Premium Avatar with gold gradient border
                Container(
                  width: 52,
                  height: 52,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF64748B),
                        Color(0xFF475569),
                        Color(0xFF1E293B),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      item.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.backgroundAlt,
                        child: const Icon(
                          Icons.person,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Profile Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Status Pill Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: badgeBorder, width: 0.8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(badgeIcon, size: 11, color: textColor),
                                const SizedBox(width: 3.5),
                                Text(
                                  item.status,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 3),

                      // Meta Clan / Age Tag
                      Text(
                        item.meta,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 3),

                      // Interest message
                      Text(
                        item.message,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
