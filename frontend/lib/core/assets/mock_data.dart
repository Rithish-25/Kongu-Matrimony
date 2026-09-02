import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration_draft.dart';

class UserProfileState {
  final String displayName;
  final String profileImageUrl;
  final String plan; // 'Free', 'Gold', 'Platinum'
  final int downloadedCount;

  UserProfileState({
    required this.displayName,
    required this.profileImageUrl,
    required this.plan,
    required this.downloadedCount,
  });

  UserProfileState copyWith({
    String? displayName,
    String? profileImageUrl,
    String? plan,
    int? downloadedCount,
  }) {
    return UserProfileState(
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      plan: plan ?? this.plan,
      downloadedCount: downloadedCount ?? this.downloadedCount,
    );
  }
}

class Profile {
  final String id;
  final String name;
  final int age;
  final String gender; // 'male' or 'female'
  final String heightText;
  final String koottam; // Kongu Vellalar sub-sects
  final String location;
  final String education;
  final String occupation;
  final String bio;
  final String profileImageUrl;
  final String coverImageUrl;
  final String horoscopeStar;
  final String horoscopeRasi;
  final String horoscopePaatham;
  final String subsect; // Community details
  final bool isPremium;
  bool isFavourite;
  String interestStatus; // 'none', 'sent', 'received', 'accepted', 'rejected'

  Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.heightText,
    required this.koottam,
    required this.location,
    required this.education,
    required this.occupation,
    required this.bio,
    required this.profileImageUrl,
    required this.coverImageUrl,
    required this.horoscopeStar,
    required this.horoscopeRasi,
    required this.horoscopePaatham,
    required this.subsect,
    this.isPremium = false,
    this.isFavourite = false,
    this.interestStatus = 'none',
  });

  Profile copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? heightText,
    String? koottam,
    String? location,
    String? education,
    String? occupation,
    String? bio,
    String? profileImageUrl,
    String? coverImageUrl,
    String? horoscopeStar,
    String? horoscopeRasi,
    String? horoscopePaatham,
    String? subsect,
    bool? isPremium,
    bool? isFavourite,
    String? interestStatus,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightText: heightText ?? this.heightText,
      koottam: koottam ?? this.koottam,
      location: location ?? this.location,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      horoscopeStar: horoscopeStar ?? this.horoscopeStar,
      horoscopeRasi: horoscopeRasi ?? this.horoscopeRasi,
      horoscopePaatham: horoscopePaatham ?? this.horoscopePaatham,
      subsect: subsect ?? this.subsect,
      isPremium: isPremium ?? this.isPremium,
      isFavourite: isFavourite ?? this.isFavourite,
      interestStatus: interestStatus ?? this.interestStatus,
    );
  }
}

class ProfileDatabase {
  ProfileDatabase._();

  static const _kDisplayName = 'user_display_name';
  static const _kProfileImageUrl = 'user_profile_image_url';
  static const _kPlan = 'user_plan';
  static const _kDownloadedCount = 'user_downloaded_count';
  static const _kIsLoggedIn = 'user_is_logged_in';

  static bool _isLoggedIn = false;

  static const _kFavourites = 'user_favourites';
  static const _kInterests = 'user_interests';

  /// Initialize persisted user profile state. Call this before runApp.
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final displayName = prefs.getString(_kDisplayName);
      final imageUrl = prefs.getString(_kProfileImageUrl);
      final plan = prefs.getString(_kPlan);
      final downloadedCount = prefs.getInt(_kDownloadedCount);
      final isLogged = prefs.getBool(_kIsLoggedIn);

      _isLoggedIn = isLogged ?? false;

      final profileDetails = await RegistrationDraft.loadProfileDetails();
      final savedName = profileDetails['name']?.trim();
      final effectiveName = (savedName != null && savedName.isNotEmpty && savedName != 'User')
          ? savedName
          : (displayName != null && displayName.isNotEmpty ? displayName : 'User');

      userProfileNotifier.value = userProfileNotifier.value.copyWith(
        displayName: effectiveName,
        profileImageUrl: imageUrl ?? userProfileNotifier.value.profileImageUrl,
        plan: plan ?? userProfileNotifier.value.plan,
        downloadedCount: downloadedCount ?? userProfileNotifier.value.downloadedCount,
      );

      // Load persisted favourites & interests
      final favList = prefs.getStringList(_kFavourites) ?? [];
      final interestList = prefs.getStringList(_kInterests) ?? [];

      final Map<String, String> interestMap = {};
      for (final item in interestList) {
        final parts = item.split(':');
        if (parts.length == 2) {
          interestMap[parts[0]] = parts[1];
        }
      }

      // Load blocked profiles for the current user (based on their mobile number reference)
      final userMobile = profileDetails['mobile'] ?? '';
      final blockedList = prefs.getStringList('blocked_$userMobile') ?? [];
      _blockedIds.clear();
      _blockedIds.addAll(blockedList.map((e) => e.toLowerCase()));
      _blockedIds.addAll(blockedList);

      // Apply to initial profiles list (filtering out blocked profiles)
      final updatedProfiles = _initialProfiles
          .where((p) => !_blockedIds.contains(p.id.toLowerCase()) && !_blockedIds.contains(p.id))
          .map((p) {
            final isFav = favList.contains(p.id);
            final status = interestMap[p.id] ?? p.interestStatus;
            return p.copyWith(
              isFavourite: isFav,
              interestStatus: status,
            );
          }).toList();

      notifier.value = updatedProfiles;
    } catch (_) {
      // ignore persistence errors for now
    }
  }

  static bool get isLoggedIn => _isLoggedIn;

  static Future<void> login() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kIsLoggedIn, true);
      _isLoggedIn = true;
    } catch (_) {}
  }

  static final List<Profile> _initialProfiles = [
    Profile(
      id: 'p1',
      name: 'Karthik Ramasamy',
      age: 28,
      gender: 'male',
      heightText: "5'11\"",
      koottam: 'Sellan',
      location: 'Coimbatore',
      education: 'B.E. Computer Science, PSG Tech',
      occupation: 'Senior Software Engineer at TechCorp',
      bio:
          'Hello! I am a down-to-earth person who values family and traditions while maintaining a modern outlook. I love hiking, reading tech blogs, and traveling. Looking for a partner who is independent and shares similar values.',
      profileImageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80',
      coverImageUrl:
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&auto=format&fit=crop&q=80',
      horoscopeStar: 'Anusham',
      horoscopeRasi: 'Viruchigam',
      horoscopePaatham: '2',
      subsect: 'Kongu Vellalar Gounder',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
    Profile(
      id: 'p2',
      name: 'Priya Palanisamy',
      age: 26,
      gender: 'female',
      heightText: "5'5\"",
      koottam: 'Sathandhai',
      location: 'Erode',
      education: 'M.S. in Data Analytics, UK',
      occupation: 'Data Scientist at Analytics Solutions',
      bio:
          'An ambitious, family-oriented woman who loves cooking, painting, and classical music. I believe marriage is a beautiful journey of mutual respect and friendship. Seeking a companion who is supportive and progressive.',
      profileImageUrl:
          'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=500&auto=format&fit=crop&q=80',
      coverImageUrl:
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&auto=format&fit=crop&q=80',
      horoscopeStar: 'Rohini',
      horoscopeRasi: 'Rishabam',
      horoscopePaatham: '3',
      subsect: 'Kongu Vellalar Gounder',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
    Profile(
      id: 'p3',
      name: 'Arun Kumar Gounder',
      age: 30,
      gender: 'male',
      heightText: "5'8\"",
      koottam: 'Morasan',
      location: 'Tiruppur',
      education: 'MBA, IIM Bangalore',
      occupation: 'Business Director, Textile Exports',
      bio:
          'Managing our family textile export business in Tiruppur. I enjoy playing tennis, exploring new cafes, and discussing business strategies. Looking for a partner who is warm, understanding, and willing to balance career and family.',
      profileImageUrl:
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=500&auto=format&fit=crop&q=80',
      coverImageUrl:
          'https://images.unsplash.com/photo-1582560475093-ba66accbc424?w=800&auto=format&fit=crop&q=80',
      horoscopeStar: 'Uthiradam',
      horoscopeRasi: 'Dhanusu',
      horoscopePaatham: '1',
      subsect: 'Kongu Vellalar Gounder',
      isPremium: false,
      isFavourite: false,
      interestStatus: 'received',
    ),
    Profile(
      id: 'p4',
      name: 'Deepika Shanmugam',
      age: 25,
      gender: 'female',
      heightText: "5'3\"",
      koottam: 'Thennan',
      location: 'Salem',
      education: 'B.Arch, NIT Trichy',
      occupation: 'Interior Architect & Designer',
      bio:
          'Creative soul with an eye for detail. I run my own interior design studio. Love photography, gardening, and organic farming. Looking for a sensible, passionate, and understanding partner to share life\'s adventures.',
      profileImageUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
      coverImageUrl:
          'https://images.unsplash.com/photo-1469371670807-013ccf25f16a?w=800&auto=format&fit=crop&q=80',
      horoscopeStar: 'Karthigai',
      horoscopeRasi: 'Mesham',
      horoscopePaatham: '4',
      subsect: 'Kongu Vellalar Gounder',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
    Profile(
      id: 'p5',
      name: 'Siddharth Sengottaiyan',
      age: 29,
      gender: 'male',
      heightText: "5'10\"",
      koottam: 'Kannandhai',
      location: 'Namakkal',
      education: 'B.Tech Food Tech & M.S. Germany',
      occupation: 'Operations Manager, Poultry Foods',
      bio:
          'Passionate about agriculture and modern food tech. I run our agro-processing unit. I spend weekends playing badminton or reading history books. Looking for a partner who is cheerful, caring, and values simple living with high thinking.',
      profileImageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80',
      coverImageUrl:
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&auto=format&fit=crop&q=80',
      horoscopeStar: 'Aswini',
      horoscopeRasi: 'Mesham',
      horoscopePaatham: '2',
      subsect: 'Kongu Vellalar Gounder',
      isPremium: false,
      isFavourite: false,
      interestStatus: 'sent',
    ),
    Profile(
      id: 'p6',
      name: 'Divya Nachimuthu',
      age: 27,
      gender: 'female',
      heightText: "5'4\"",
      koottam: 'Thorathan',
      location: 'Coimbatore',
      education: 'M.D. Pediatrics, PSG Medical College',
      occupation: 'Consultant Pediatrician',
      bio:
          'Dedicated medical professional who loves children. I am soft-spoken, patient, and love baking. Balance in work and family life is important to me. Seeking an educated, caring, and understanding groom (preferably medical or tech professional).',
      profileImageUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&auto=format&fit=crop&q=80',
      coverImageUrl:
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&auto=format&fit=crop&q=80',
      horoscopeStar: 'Mirugaseerisham',
      horoscopeRasi: 'Rishabam',
      horoscopePaatham: '3',
      subsect: 'Kongu Vellalar Gounder',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
    Profile(
      id: 'p7',
      name: 'Vignesh Ponnusamy',
      age: 27,
      gender: 'male',
      heightText: "5'9\"",
      koottam: 'Sellan',
      location: 'Salem',
      education: 'B.E. Mechanical Engineer',
      occupation: 'Design Engineer, Automobile Sector',
      bio:
          'Automobile enthusiast who loves long drives, road trips, and working on mechanical DIY projects. I enjoy spending quality time with my parents and friends. Looking for a partner who is cheerful and family-oriented.',
      profileImageUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=500&auto=format&fit=crop&q=80',
      coverImageUrl:
          'https://images.unsplash.com/photo-1582560475093-ba66accbc424?w=800&auto=format&fit=crop&q=80',
      horoscopeStar: 'Poosam',
      horoscopeRasi: 'Katagam',
      horoscopePaatham: '1',
      subsect: 'Kongu Vellalar Gounder',
      isPremium: false,
      isFavourite: false,
      interestStatus: 'received',
    ),
    Profile(
      id: 'p8',
      name: 'Nandhini Eswaran',
      age: 24,
      gender: 'female',
      heightText: "5'6\"",
      koottam: 'Sathandhai',
      location: 'Coimbatore',
      education: 'B.Com & Chartered Accountant (CA)',
      occupation: 'Practicing Chartered Accountant',
      bio:
          'A career-oriented yet family-loving CA. I enjoy listening to podcasts, traveling, and learning new finance concepts. I am looking for a partner who is broad-minded, educated, and supportive of my professional career.',
      profileImageUrl:
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&auto=format&fit=crop&q=80',
      coverImageUrl:
          'https://images.unsplash.com/photo-1469371670807-013ccf25f16a?w=800&auto=format&fit=crop&q=80',
      horoscopeStar: 'Revathi',
      horoscopeRasi: 'Meenam',
      horoscopePaatham: '4',
      subsect: 'Kongu Vellalar Gounder',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
  ];

  static final ValueNotifier<List<Profile>> notifier = ValueNotifier(
    _initialProfiles,
  );

  static List<Profile> get currentProfiles => notifier.value;

  static void toggleFavorite(String id) async {
    final list = notifier.value;
    final updatedList =
        list.map((p) {
          if (p.id == id) {
            return p.copyWith(isFavourite: !p.isFavourite);
          }
          return p;
        }).toList();
    notifier.value = updatedList;

    try {
      final prefs = await SharedPreferences.getInstance();
      final favList = updatedList
          .where((p) => p.isFavourite)
          .map((p) => p.id)
          .toList();
      await prefs.setStringList(_kFavourites, favList);
    } catch (_) {}
  }

  static void updateInterest(String id, String status) async {
    final list = notifier.value;
    final updatedList =
        list.map((p) {
          if (p.id == id) {
            return p.copyWith(interestStatus: status);
          }
          return p;
        }).toList();
    notifier.value = updatedList;

    try {
      final prefs = await SharedPreferences.getInstance();
      final interestList = updatedList
          .map((p) => '${p.id}:${p.interestStatus}')
          .toList();
      await prefs.setStringList(_kInterests, interestList);
    } catch (_) {}
  }

  static final Set<String> _blockedIds = {};
  static bool isBlocked(String profileId) =>
      _blockedIds.contains(profileId.toLowerCase()) || _blockedIds.contains(profileId);
  static Set<String> get blockedIds => _blockedIds;

  static void blockProfile(String profileId) async {
    try {
      final cleanId = profileId.toLowerCase();
      _blockedIds.add(cleanId);
      _blockedIds.add(profileId);

      final prefs = await SharedPreferences.getInstance();
      final profileDetails = await RegistrationDraft.loadProfileDetails();
      final userMobile = profileDetails['mobile'] ?? '';
      final key = 'blocked_$userMobile';
      final blockedList = prefs.getStringList(key) ?? [];
      if (!blockedList.contains(profileId)) {
        blockedList.add(profileId);
      }
      if (!blockedList.contains(cleanId)) {
        blockedList.add(cleanId);
      }
      await prefs.setStringList(key, blockedList);

      // Update the active list immediately so the UI is in sync
      final currentList = notifier.value;
      notifier.value = currentList
          .where((p) => p.id.toLowerCase() != cleanId && p.id != profileId)
          .toList();
    } catch (_) {}
  }

  static final ValueNotifier<UserProfileState>
  userProfileNotifier = ValueNotifier(
    UserProfileState(
      displayName: 'User',
      profileImageUrl:
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=500&auto=format&fit=crop&q=80',
      plan: 'Gold',
      downloadedCount: 0,
    ),
  );

  static Future<void> updateUserProfile({
    String? displayName,
    String? imageUrl,
    String? plan,
    int? downloadedCount,
  }) async {
    userProfileNotifier.value = userProfileNotifier.value.copyWith(
      displayName: displayName,
      profileImageUrl: imageUrl,
      plan: plan,
      downloadedCount: downloadedCount,
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      if (displayName != null) await prefs.setString(_kDisplayName, displayName);
      if (imageUrl != null) await prefs.setString(_kProfileImageUrl, imageUrl);
      if (plan != null) await prefs.setString(_kPlan, plan);
      if (downloadedCount != null) await prefs.setInt(_kDownloadedCount, downloadedCount);
    } catch (_) {}
  }

  /// Clear persisted user profile (used on explicit logout).
  static Future<void> clearUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kDisplayName);
      await prefs.remove(_kProfileImageUrl);
      await prefs.remove(_kPlan);
      await prefs.remove(_kDownloadedCount);
      await prefs.remove(_kFavourites);
      await prefs.remove(_kInterests);
      await prefs.setBool(_kIsLoggedIn, false);
      _isLoggedIn = false;
      // Keep profile details on logout so user can log in again
      // await RegistrationDraft.clearProfileDetails();
      await RegistrationDraft.clearDraft();
    } catch (_) {}

    // Reset to default in-memory state
    userProfileNotifier.value = UserProfileState(
      displayName: 'User',
      profileImageUrl: userProfileNotifier.value.profileImageUrl,
      plan: 'Gold',
      downloadedCount: 0,
    );

    // Reset profiles list to defaults
    final resetProfiles = _initialProfiles.map((p) {
      return p.copyWith(
        isFavourite: p.isFavourite,
        interestStatus: p.interestStatus,
      );
    }).toList();
    notifier.value = resetProfiles;
  }
}
