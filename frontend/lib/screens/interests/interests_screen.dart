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
  int _newPageIndex = 0;
  late PageController _newPageController;

  @override
  void initState() {
    super.initState();
    _newPageController = PageController(viewportFraction: 0.84);
  }

  @override
  void dispose() {
    _newPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: AppLanguageController.notifier,
      builder: (context, currentLang, _) {
        return ValueListenableBuilder<UserProfileState>(
          valueListenable: ProfileDatabase.userProfileNotifier,
          builder: (context, userState, _) {
            return ValueListenableBuilder<List<Profile>>(
              valueListenable: ProfileDatabase.notifier,
              builder: (context, profiles, _) {
                final bool isLoggedIn = ProfileDatabase.isLoggedIn;
                final String rawGender = userState.userGender.trim().toLowerCase();
                final String effectiveUserGender = (isLoggedIn && rawGender.isEmpty) ? 'male' : rawGender;
                final String targetGender = (effectiveUserGender == 'female' || effectiveUserGender.contains('female')) ? 'male' : 'female';

                // Filter profiles by gender when logged in
                final filteredProfiles = profiles.where((p) {
                  if (ProfileDatabase.isBlocked(p.id)) return false;
                  if (isLoggedIn) {
                    final pGender = p.gender.trim().toLowerCase();
                    if (targetGender == 'female') {
                      if (pGender != 'female') return false;
                    } else {
                      if (pGender != 'male') return false;
                    }
                  }
                  return true;
                }).toList();

                // New tab profiles (interestStatus == 'none')
                final newProfiles = filteredProfiles.where((p) => p.interestStatus == 'none').toList();

                // Received tab items
                final receivedProfiles = filteredProfiles.where((p) => p.interestStatus == 'received').toList();
                final acceptedProfiles = filteredProfiles.where((p) => p.interestStatus == 'accepted').toList();
                final receivedItems = _getReceivedItems(receivedProfiles, acceptedProfiles, targetGender);

                // Sent tab items
                final sentProfiles = filteredProfiles.where((p) => p.interestStatus == 'sent').toList();
                final sentItems = _getSentItems(sentProfiles, targetGender);

                return DefaultTabController(
                  length: 3,
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
                            fontSize: 13,
                          ),
                          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          tabs: [
                            // New Tab Header
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLanguageController.text('New')),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${newProfiles.length}',
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
                            // Received Tab Header
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLanguageController.text('Received')),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                            // Sent Tab Header
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLanguageController.text('Sent')),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                        // New Tab (Swipeable Large Card UI - Image 2)
                        _buildNewTabSwipeableCardView(newProfiles),

                        // Received Tab (List View UI - Image 3)
                        _buildReceivedTabListView(receivedItems),

                        // Sent Tab (List View UI - Image 3)
                        _buildSentTabListView(sentItems),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // New Tab Swipeable Card View (Image 2 Design)
  Widget _buildNewTabSwipeableCardView(List<Profile> profiles) {
    if (profiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search_outlined,
              size: 64,
              color: AppColors.textLight.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              AppLanguageController.text('No new profiles available'),
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

        // Swipeable Cards Container with Left & Right Arrow Navigation (Image 2 Design)
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: _newPageController,
                physics: const BouncingScrollPhysics(),
                itemCount: profiles.length,
                onPageChanged: (idx) => setState(() => _newPageIndex = idx),
                itemBuilder: (context, index) {
                  final p = profiles[index];
                  return AnimatedBuilder(
                    animation: _newPageController,
                    builder: (context, child) {
                      double pageOffset = 0.0;
                      if (_newPageController.position.haveDimensions) {
                        pageOffset = (_newPageController.page ?? _newPageIndex.toDouble()) - index;
                      } else {
                        pageOffset = (_newPageIndex - index).toDouble();
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
                      child: _buildNewSingleCard(p),
                    ),
                  );
                },
              ),

              // Floating Left Arrow Button
              if (_newPageIndex > 0)
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
                          _newPageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
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

              // Floating Right Arrow Button
              if (_newPageIndex < profiles.length - 1)
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
                          _newPageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
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

        // Bottom Page Indicator / Counter with Arrow Controls (Image 2 Design: < 1/N ••• >)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: _newPageIndex > 0
                    ? () {
                        _newPageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                icon: Icon(
                  Icons.chevron_left_rounded,
                  size: 24,
                  color: _newPageIndex > 0 ? AppColors.textPrimary : AppColors.border,
                ),
              ),

              const SizedBox(width: 4),

              Text(
                '${_newPageIndex + 1}/${profiles.length}',
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
                  profiles.length > 8 ? 8 : profiles.length,
                  (idx) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: idx == _newPageIndex ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: idx == _newPageIndex
                          ? AppColors.primary
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 4),

              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: _newPageIndex < profiles.length - 1
                    ? () {
                        _newPageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                icon: Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                  color: _newPageIndex < profiles.length - 1 ? AppColors.textPrimary : AppColors.border,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewSingleCard(Profile p) {
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
            Navigator.of(context).push(
              appPageRoute(
                ProfileDetailsScreen(
                  profile: p,
                  heroTag: 'profile-image-${p.id}-new-card',
                ),
              ),
            );
          },
          child: Column(
            children: [
              // Photo Container (Image 2 Design)
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: AppProfileImage(
                        imageUrl: p.profileImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                    Positioned.fill(
                      child: AppProfileImage(
                        imageUrl: p.profileImageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Info & Action Buttons Container (Image 2 Design)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      p.name,
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

                    const SizedBox(height: 3),

                    Text(
                      '${p.age} Yrs, ${p.heightText} • ${p.koottam} Koottam',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Tamil, Gounder • ${p.location}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    // Action Buttons: View & Express Interest
                    Row(
                      children: [
                        // View Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                appPageRoute(
                                  ProfileDetailsScreen(
                                    profile: p,
                                    heroTag: 'profile-new-${p.id}',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE07A38),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            icon: const Icon(Icons.remove_red_eye_rounded, size: 17, color: Colors.white),
                            label: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                AppLanguageController.text('View'),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Express Interest Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ProfileDatabase.updateInterest(p.id, 'sent');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Interest Sent to ${p.name}!'),
                                    backgroundColor: AppColors.primary,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD35400),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            icon: const Icon(Icons.favorite_rounded, size: 17, color: Colors.white),
                            label: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                AppLanguageController.text('Express Interest'),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Received Tab List View (Image 3 Design)
  Widget _buildReceivedTabListView(List<InboxItem> items) {
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isAccepted = item.status.toLowerCase() == 'accepted';
        final isDeclined = item.status.toLowerCase() == 'declined' || item.status.toLowerCase() == 'decline';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: AppProfileImage(
                        imageUrl: item.avatarUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Last active at 07:15 am',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.meta} | ${item.subMeta}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: const Color(0xFF64748B),
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),

              if (isAccepted)
                // Full Width Accepted Button (Decline button is hidden)
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_rounded, size: 18, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          'accepted',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (isDeclined)
                // Full Width Declined Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.close_rounded, size: 18, color: Color(0xFFEF4444)),
                        const SizedBox(width: 6),
                        Text(
                          AppLanguageController.text('declined'),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Pending Request: Show side-by-side Decline and Accept buttons
                Row(
                  children: [
                    // Decline Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
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
                                content: Text('${item.name} request declined'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        icon: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
                        label: Text(
                          AppLanguageController.text('decline'),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Accept Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
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
                                content: Text('Accepted ${item.name}!'),
                                backgroundColor: const Color(0xFF10B981),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        icon: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
                        label: Text(
                          AppLanguageController.text('accept'),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  // Sent Tab List View (Image 3 Design)
  Widget _buildSentTabListView(List<InboxItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.send_outlined,
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: AppProfileImage(
                        imageUrl: item.avatarUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Last active at 07:15 am',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.meta} | ${item.subMeta}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: const Color(0xFF64748B),
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),

              Row(
                children: [
                  // View Profile Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final profile = item.profile ?? Profile(
                          id: item.id.replaceAll('ID:KM-', '').toLowerCase(),
                          name: item.name,
                          age: 24,
                          gender: 'female',
                          heightText: "5'4\"",
                          koottam: 'Sathandhai',
                          subsect: 'Kongu Vellalar Gounder',
                          horoscopeStar: 'Anusham',
                          horoscopeRasi: 'Viruchigam',
                          horoscopePaatham: '4',
                          location: 'Coimbatore, Tamil Nadu',
                          education: 'B.E.',
                          occupation: 'Software Engineer',
                          bio: 'Hello!',
                          profileImageUrl: item.avatarUrl,
                          coverImageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&auto=format&fit=crop&q=80',
                        );
                        Navigator.of(context).push(
                          appPageRoute(
                            ProfileDetailsScreen(
                              profile: profile,
                              heroTag: 'profile-sent-${item.id}',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE07A38),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      icon: const Icon(Icons.remove_red_eye_rounded, size: 18, color: Colors.white),
                      label: Text(
                        AppLanguageController.text('View'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Status Indicator Pill
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFFDBA74), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time_filled_rounded, size: 16, color: Color(0xFFC2410C)),
                          const SizedBox(width: 6),
                          Text(
                            AppLanguageController.text(item.status),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFC2410C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<InboxItem> _getReceivedItems(
    List<Profile> receivedProfiles,
    List<Profile> acceptedProfiles,
    String targetGender,
  ) {
    final koottamText = AppLanguageController.text('Koottam');
    final List<InboxItem> allCandidates = [];

    // Accepted profiles matching target gender
    for (final p in acceptedProfiles) {
      if (p.gender.trim().toLowerCase() == targetGender) {
        allCandidates.add(
          InboxItem(
            name: p.name,
            id: p.id,
            meta: '${p.age} Yrs, ${p.heightText} • ${p.koottam} $koottamText',
            subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text(p.location)}',
            message: 'Accepted connection request. Let\'s converse.',
            status: _customStatuses[p.id] ?? 'Accepted',
            avatarUrl: p.profileImageUrl,
            timeAgo: 'few mins ago',
            profile: p,
          ),
        );
      }
    }

    // Received profiles matching target gender
    for (final p in receivedProfiles) {
      if (p.gender.trim().toLowerCase() == targetGender) {
        allCandidates.add(
          InboxItem(
            name: p.name,
            id: p.id,
            meta: '${p.age} Yrs, ${p.heightText} • ${p.koottam} $koottamText',
            subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text(p.location)}',
            message: 'Hello! I am matching your Koottam. Let\'s view horoscopes.',
            status: _customStatuses[p.id] ?? 'New',
            avatarUrl: p.profileImageUrl,
            timeAgo: '2 hrs ago',
            profile: p,
          ),
        );
      }
    }

    // Default mock candidates if target is male
    if (targetGender == 'male') {
      allCandidates.addAll([
        InboxItem(
          name: 'R Mani K',
          id: 'km-manik',
          meta: '29 Yrs, 5\' 6" • Sathandhai Koottam',
          subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Salem, Tamil Nadu')}',
          message: 'R Mani K has sent you an interest request.',
          status: _customStatuses['km-manik'] ?? 'New',
          avatarUrl: 'assets/photos/men1.jpg',
          timeAgo: 'few mins ago',
          isPremium: true,
        ),
      ]);
    } else {
      // Default mock candidates if target is female
      allCandidates.addAll([
        InboxItem(
          name: 'Malavika V',
          id: 'km-malavika',
          meta: '24 Yrs, 5\' 4" • Sathandhai Koottam',
          subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Coimbatore, Tamil Nadu')}',
          message: 'Hi, I would like to connect with your profile.',
          status: _customStatuses['km-malavika'] ?? 'Accepted',
          avatarUrl: 'assets/photos/women1.jpg',
          timeAgo: '10 mins ago',
        ),
        InboxItem(
          name: 'Neha P',
          id: 'km-neha',
          meta: '25 Yrs, 5\' 3" • Sengunthar Koottam',
          subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Erode, Tamil Nadu')}',
          message: 'Hi, I would like to connect with your profile.',
          status: _customStatuses['km-neha'] ?? 'Accepted',
          avatarUrl: 'assets/photos/women2.jpg',
          timeAgo: '1 hr ago',
        ),
        InboxItem(
          name: 'Priya K',
          id: 'km-priya',
          meta: '23 Yrs, 5\' 2" • Kannandhai Koottam',
          subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Salem, Tamil Nadu')}',
          message: 'Expressed interest in your profile.',
          status: _customStatuses['km-priya'] ?? 'New',
          avatarUrl: 'assets/photos/women3.jpg',
          timeAgo: '3 hrs ago',
        ),
        InboxItem(
          name: 'Shilpa B',
          id: 'km-shilpa',
          meta: '26 Yrs, 5\' 5" • Pavalam Koottam',
          subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Tiruppur, Tamil Nadu')}',
          message: 'Viewed your profile and would love to exchange horoscopes.',
          status: _customStatuses['km-shilpa'] ?? 'New',
          avatarUrl: 'assets/photos/women4.jpg',
          timeAgo: '5 hrs ago',
        ),
      ]);
    }

    return allCandidates
        .where((item) =>
            !ProfileDatabase.isBlocked(item.id) &&
            !ProfileDatabase.isBlocked(item.id.toLowerCase()) &&
            item.status.toLowerCase() != 'declined' &&
            item.status.toLowerCase() != 'decline')
        .toList();
  }

  List<InboxItem> _getSentItems(List<Profile> sentProfiles, String targetGender) {
    final koottamText = AppLanguageController.text('Koottam');
    final List<InboxItem> allCandidates = [];

    // Sent profiles matching target gender
    for (final p in sentProfiles) {
      if (p.gender.trim().toLowerCase() == targetGender) {
        allCandidates.add(
          InboxItem(
            name: p.name,
            id: p.id,
            meta: '${p.age} Yrs, ${p.heightText} • ${p.koottam} $koottamText',
            subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text(p.location)}',
            message: 'You expressed interest in this profile.',
            status: _customStatuses[p.id] ?? 'Pending',
            avatarUrl: p.profileImageUrl,
            timeAgo: 'Today',
            profile: p,
          ),
        );
      }
    }

    if (allCandidates.isEmpty) {
      if (targetGender == 'female') {
        allCandidates.add(
          InboxItem(
            name: 'Divya Nachimuthu',
            id: 'p6',
            meta: '24 Yrs, 5\' 4" • Sathandhai Koottam',
            subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Coimbatore, Tamil Nadu')}',
            message: 'Interest sent. Awaiting horoscope response.',
            status: _customStatuses['p6'] ?? 'Pending',
            avatarUrl: 'assets/photos/women4.jpg',
            timeAgo: 'Yesterday',
          ),
        );
      } else {
        allCandidates.add(
          InboxItem(
            name: 'Karthik Subramanian',
            id: 'p1',
            meta: '28 Yrs, 5\' 11" • Sathandhai Koottam',
            subMeta: '${AppLanguageController.text('Tamil')}, ${AppLanguageController.text('Gounder')} • ${AppLanguageController.text('Coimbatore, Tamil Nadu')}',
            message: 'Interest sent. Awaiting response.',
            status: _customStatuses['p1'] ?? 'Pending',
            avatarUrl: 'assets/photos/men1.jpg',
            timeAgo: 'Yesterday',
          ),
        );
      }
    }

    return allCandidates
        .where((item) =>
            !ProfileDatabase.isBlocked(item.id) &&
            !ProfileDatabase.isBlocked(item.id.toLowerCase()) &&
            item.status.toLowerCase() != 'declined' &&
            item.status.toLowerCase() != 'decline')
        .toList();
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
