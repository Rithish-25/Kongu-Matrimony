import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/mock_data.dart';
import '../../core/navigation/app_page_route.dart';
import '../profile_details/profile_details_screen.dart';

class InterestsScreen extends StatelessWidget {
  const InterestsScreen({super.key});

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

        // Calculate counts dynamically
        final totalReceivedCount =
            receivedProfiles.length +
            acceptedProfiles.length +
            _mockRequests.length;
        final totalSentCount =
            sentProfiles.length + 3; // adding some mock sent requests

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                color: Colors.white,
                child: TabBar(
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  tabs: [
                    Tab(text: 'Received ($totalReceivedCount)'),
                    Tab(text: 'Sent ($totalSentCount)'),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                // Received Tab containing Sub-tabs
                _buildReceivedTab(context, receivedProfiles, acceptedProfiles),

                // Sent Tab
                _buildSentTab(context, sentProfiles),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceivedTab(
    BuildContext context,
    List<Profile> receivedProfiles,
    List<Profile> acceptedProfiles,
  ) {
    final receivedItems = [
      ...acceptedProfiles.map(
        (p) => InboxItem(
          name: p.name,
          id: 'ID:KM-${p.id.toUpperCase()}',
          message: 'Hi, I accepted your connection. Let\'s converse.',
          status: 'Accepted',
          avatarUrl: p.profileImageUrl,
          profile: p,
        ),
      ),
      InboxItem(
        name: 'Malavika V',
        id: 'ID:KM-992211',
        message: 'hi i would like to connect with you...',
        status: 'Accepted',
        avatarUrl:
            'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=500&auto=format&fit=crop&q=80',
      ),
      InboxItem(
        name: 'Neha P',
        id: 'ID:KM-123456',
        message: 'hi i would like to connect with you...',
        status: 'Accepted',
        avatarUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
      ),
      ...receivedProfiles.map(
        (p) => InboxItem(
          name: p.name,
          id: 'ID:KM-${p.id.toUpperCase()}',
          message: 'Hello! I am matching your Koottam. Let\'s view horoscopes.',
          status: 'New',
          avatarUrl: p.profileImageUrl,
          profile: p,
        ),
      ),
      InboxItem(
        name: 'Priya k',
        id: 'ID:KM-882211',
        message: 'hi i would like to connect with you...',
        status: 'New',
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&auto=format&fit=crop&q=80',
      ),
      ..._mockRequests,
    ];

    return Container(
      color: AppColors.background,
      child: _buildInboxListView(receivedItems),
    );
  }

  Widget _buildSentTab(BuildContext context, List<Profile> sentProfiles) {
    final sentItems = [
      ...sentProfiles.map(
        (p) => InboxItem(
          name: p.name,
          id: 'ID:KM-${p.id.toUpperCase()}',
          message: 'I expressed interest in your profile.',
          status: 'Pending',
          avatarUrl: p.profileImageUrl,
          profile: p,
        ),
      ),
      InboxItem(
        name: 'Divya Nachimuthu',
        id: 'ID:KM-P6',
        message: 'Interest sent. Awaiting horoscope response.',
        status: 'Delivered',
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&auto=format&fit=crop&q=80',
      ),
    ];

    return Container(
      color: AppColors.background,
      child: _buildInboxListView(sentItems),
    );
  }

  Widget _buildInboxListView(List<InboxItem> items) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.spacingS),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InboxListCard(item: item);
      },
    );
  }

  // Mock Request items matching user screenshot exactly
  static final List<InboxItem> _mockRequests = [
    InboxItem(
      name: 'Malavika V, me 2',
      id: 'ID:CM123456',
      message: 'hi i would like to connect with you...',
      status: 'Accepted',
      avatarUrl:
          'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=500&auto=format&fit=crop&q=80',
    ),
    InboxItem(
      name: 'Neha P, me 4',
      id: 'ID:CM123456',
      message: 'hi i would like to connect with you...',
      status: 'Accepted',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
    ),
    InboxItem(
      name: 'Shilpa B',
      id: 'ID:CM123456',
      message: 'hi i would like to connect with you...',
      status: 'Decline',
      avatarUrl:
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&auto=format&fit=crop&q=80',
    ),
    InboxItem(
      name: 'Priya k',
      id: 'ID:CM123456',
      message: 'hi i would like to connect with you...',
      status: 'New',
      avatarUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&auto=format&fit=crop&q=80',
    ),
    InboxItem(
      name: 'Mithra T',
      id: 'ID:CM123456',
      message: 'hi i would like to connect with you...',
      status: 'Decline',
      avatarUrl:
          'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=500&auto=format&fit=crop&q=80',
    ),
    InboxItem(
      name: 'Ramya A',
      id: 'ID:CM123456',
      message: 'hi i would like to connect with you...',
      status: 'Decline',
      avatarUrl:
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&auto=format&fit=crop&q=80',
    ),
  ];
}

class InboxItem {
  final String name;
  final String id;
  final String message;
  final String status;
  final String avatarUrl;
  final Profile? profile;

  InboxItem({
    required this.name,
    required this.id,
    required this.message,
    required this.status,
    required this.avatarUrl,
    this.profile,
  });
}

class InboxListCard extends StatelessWidget {
  final InboxItem item;

  const InboxListCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Custom Badge configuration
    Color badgeColor;
    Color textColor;
    if (item.status == 'Accepted') {
      badgeColor = const Color(0xFFC8E6C9); // Green
      textColor = const Color(0xFF2E7D32);
    } else if (item.status == 'Decline' || item.status == 'Declined') {
      badgeColor = const Color(0xFFFFCDD2); // Red/Pink
      textColor = const Color(0xFFC62828);
    } else if (item.status == 'New') {
      badgeColor = const Color(0xFFBBDEFB); // Blue
      textColor = const Color(0xFF1565C0);
    } else {
      badgeColor = AppColors.border; // Default Grey
      textColor = AppColors.textSecondary;
    }

    return GestureDetector(
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
          coverImageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&auto=format&fit=crop&q=80',
          horoscopeStar: 'Anusham',
          horoscopeRasi: 'Viruchigam',
          horoscopePaatham: '4',
          subsect: 'Kongu Vellalar Gounder',
          isPremium: false,
          isFavourite: false,
          interestStatus: item.status.toLowerCase() == 'accepted' ? 'accepted' : 'received',
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
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left circular avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.border,
                image: DecorationImage(
                  image: NetworkImage(item.avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingM),

            // Middle Column details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Right Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.status,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
