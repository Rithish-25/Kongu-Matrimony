import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration_draft.dart';

class UserProfileState {
  final String displayName;
  final String profileImageUrl;
  final String plan; // 'Free', 'Gold', 'Platinum'
  final int downloadedCount;
  final String userGender;

  UserProfileState({
    required this.displayName,
    required this.profileImageUrl,
    required this.plan,
    required this.downloadedCount,
    this.userGender = '',
  });

  UserProfileState copyWith({
    String? displayName,
    String? profileImageUrl,
    String? plan,
    int? downloadedCount,
    String? userGender,
  }) {
    return UserProfileState(
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      plan: plan ?? this.plan,
      downloadedCount: downloadedCount ?? this.downloadedCount,
      userGender: userGender ?? this.userGender,
    );
  }
}

class Profile {
  final String id;
  final String name;
  final int age;
  final String gender; // 'male' or 'female'
  final String maritalStatus;
  final String dob;
  final String timeOfBirth;
  final String mobile;
  final String email;
  final String profileCreatedBy;

  // Physical Attributes
  final String heightText;
  final String weightText;
  final String bloodGroup;
  final String complexion;
  final String bodyType;
  final String disability;

  // Astrology & Horoscope Details
  final String koottam; // Kongu Vellalar sub-sects
  final String subsect; // Community details
  final String horoscopeStar;
  final String horoscopeRasi;
  final String horoscopePaatham;
  final String lagnam;
  final String dosham;
  final String gothram;

  // Lifestyle & Habits
  final String eatingHabits;
  final String smokingHabits;
  final String drinkingHabits;
  final String hobbies;

  // Family Background
  final String familyStatus;
  final String familyType;
  final String familyValues;
  final String fatherOccupation;
  final String motherOccupation;
  final String brothersCount;
  final String sistersCount;
  final String ancestralOrigin;

  // Education & Career
  final String education;
  final String educationDetail;
  final String occupation;
  final String employedIn;
  final String annualIncome;
  final String workLocation;

  // Communication & Location
  final String location;
  final String nativePlace;
  final String city;
  final String district;
  final String state;
  final String country;
  final String alternateMobile;

  // Partner Preferences
  final String prefAgeRange;
  final String prefHeightRange;
  final String prefMaritalStatus;
  final String prefEducation;
  final String prefOccupation;
  final String prefLocation;

  // Bio & Expectations
  final String bio;
  final String partnerExpectations;

  final String profileImageUrl;
  final String coverImageUrl;
  final bool isPremium;
  bool isFavourite;
  String interestStatus; // 'none', 'sent', 'received', 'accepted', 'rejected'

  Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.maritalStatus = 'Single (Never Married)',
    this.dob = '14-06-2000',
    this.timeOfBirth = '07:30 AM',
    this.mobile = '+91 98765 43210',
    this.email = 'profile.user@example.com',
    this.profileCreatedBy = 'Parents',
    required this.heightText,
    this.weightText = '58 kg',
    this.bloodGroup = 'B+ Positive',
    this.complexion = 'Fair',
    this.bodyType = 'Average / Slim',
    this.disability = 'None (Normal)',
    required this.koottam,
    required this.subsect,
    required this.horoscopeStar,
    required this.horoscopeRasi,
    required this.horoscopePaatham,
    this.lagnam = 'Dhanusu',
    this.dosham = 'No Dosham (Sevvai Dhosham Illai)',
    this.gothram = 'Sathandhai Gothram',
    this.eatingHabits = 'Vegetarian',
    this.smokingHabits = 'No',
    this.drinkingHabits = 'No',
    this.hobbies = 'Classical Music, Reading Finance Books, Baking, Podcasts',
    this.familyStatus = 'Upper Middle Class',
    this.familyType = 'Nuclear Family',
    this.familyValues = 'Traditional & Modern Values',
    this.fatherOccupation = 'Businessman (Textile Manufacturer)',
    this.motherOccupation = 'Homemaker',
    this.brothersCount = '1 Brother (Married)',
    this.sistersCount = 'None',
    this.ancestralOrigin = 'Perundurai, Erode',
    required this.education,
    this.educationDetail = 'B.Com & CA (ICAI Chennai)',
    required this.occupation,
    this.employedIn = 'Private Firm / Practice',
    this.annualIncome = '₹ 12,00,000 / Annum',
    this.workLocation = 'Coimbatore',
    required this.location,
    this.nativePlace = 'Erode',
    this.city = 'Coimbatore',
    this.district = 'Coimbatore',
    this.state = 'Tamil Nadu',
    this.country = 'India',
    this.alternateMobile = '+91 94432 12345',
    this.prefAgeRange = '25 - 29 Years',
    this.prefHeightRange = "5'8\" - 6'1\"",
    this.prefMaritalStatus = 'Single (Never Married)',
    this.prefEducation = 'B.E. / B.Tech / M.B.B.S. / M.B.A. / C.A.',
    this.prefOccupation = 'Software Engineer / Doctor / Business Executive',
    this.prefLocation = 'Coimbatore, Erode, Tiruppur, Salem',
    required this.bio,
    this.partnerExpectations = 'Seeking a well-educated, respectful, and caring partner from Kongu Vellalar Gounder community with stable career or business.',
    required this.profileImageUrl,
    required this.coverImageUrl,
    this.isPremium = false,
    this.isFavourite = false,
    this.interestStatus = 'none',
  });

  Profile copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? maritalStatus,
    String? dob,
    String? mobile,
    String? email,
    String? profileCreatedBy,
    String? heightText,
    String? weightText,
    String? bloodGroup,
    String? complexion,
    String? bodyType,
    String? disability,
    String? koottam,
    String? subsect,
    String? horoscopeStar,
    String? horoscopeRasi,
    String? horoscopePaatham,
    String? lagnam,
    String? dosham,
    String? gothram,
    String? eatingHabits,
    String? smokingHabits,
    String? drinkingHabits,
    String? hobbies,
    String? familyStatus,
    String? familyType,
    String? familyValues,
    String? fatherOccupation,
    String? motherOccupation,
    String? brothersCount,
    String? sistersCount,
    String? ancestralOrigin,
    String? education,
    String? educationDetail,
    String? occupation,
    String? employedIn,
    String? annualIncome,
    String? workLocation,
    String? location,
    String? nativePlace,
    String? city,
    String? district,
    String? state,
    String? country,
    String? alternateMobile,
    String? prefAgeRange,
    String? prefHeightRange,
    String? prefMaritalStatus,
    String? prefEducation,
    String? prefOccupation,
    String? prefLocation,
    String? bio,
    String? partnerExpectations,
    String? profileImageUrl,
    String? coverImageUrl,
    bool? isPremium,
    bool? isFavourite,
    String? interestStatus,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      dob: dob ?? this.dob,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      profileCreatedBy: profileCreatedBy ?? this.profileCreatedBy,
      heightText: heightText ?? this.heightText,
      weightText: weightText ?? this.weightText,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      complexion: complexion ?? this.complexion,
      bodyType: bodyType ?? this.bodyType,
      disability: disability ?? this.disability,
      koottam: koottam ?? this.koottam,
      subsect: subsect ?? this.subsect,
      horoscopeStar: horoscopeStar ?? this.horoscopeStar,
      horoscopeRasi: horoscopeRasi ?? this.horoscopeRasi,
      horoscopePaatham: horoscopePaatham ?? this.horoscopePaatham,
      lagnam: lagnam ?? this.lagnam,
      dosham: dosham ?? this.dosham,
      gothram: gothram ?? this.gothram,
      eatingHabits: eatingHabits ?? this.eatingHabits,
      smokingHabits: smokingHabits ?? this.smokingHabits,
      drinkingHabits: drinkingHabits ?? this.drinkingHabits,
      hobbies: hobbies ?? this.hobbies,
      familyStatus: familyStatus ?? this.familyStatus,
      familyType: familyType ?? this.familyType,
      familyValues: familyValues ?? this.familyValues,
      fatherOccupation: fatherOccupation ?? this.fatherOccupation,
      motherOccupation: motherOccupation ?? this.motherOccupation,
      brothersCount: brothersCount ?? this.brothersCount,
      sistersCount: sistersCount ?? this.sistersCount,
      ancestralOrigin: ancestralOrigin ?? this.ancestralOrigin,
      education: education ?? this.education,
      educationDetail: educationDetail ?? this.educationDetail,
      occupation: occupation ?? this.occupation,
      employedIn: employedIn ?? this.employedIn,
      annualIncome: annualIncome ?? this.annualIncome,
      workLocation: workLocation ?? this.workLocation,
      location: location ?? this.location,
      nativePlace: nativePlace ?? this.nativePlace,
      city: city ?? this.city,
      district: district ?? this.district,
      state: state ?? this.state,
      country: country ?? this.country,
      alternateMobile: alternateMobile ?? this.alternateMobile,
      prefAgeRange: prefAgeRange ?? this.prefAgeRange,
      prefHeightRange: prefHeightRange ?? this.prefHeightRange,
      prefMaritalStatus: prefMaritalStatus ?? this.prefMaritalStatus,
      prefEducation: prefEducation ?? this.prefEducation,
      prefOccupation: prefOccupation ?? this.prefOccupation,
      prefLocation: prefLocation ?? this.prefLocation,
      bio: bio ?? this.bio,
      partnerExpectations: partnerExpectations ?? this.partnerExpectations,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
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
  static final ValueNotifier<bool> authNotifier = ValueNotifier<bool>(false);

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
      authNotifier.value = _isLoggedIn;

      final profileDetails = await RegistrationDraft.loadProfileDetails();
      final savedName = profileDetails['name']?.trim();
      final effectiveName = (savedName != null && savedName.isNotEmpty && savedName != 'User')
          ? savedName
          : (displayName != null && displayName.isNotEmpty ? displayName : 'User');
      final savedGender = profileDetails['gender'] ?? prefs.getString('user_gender') ?? 'Male';
      final effectiveGender = savedGender.trim().isNotEmpty ? savedGender.trim() : 'Male';

      userProfileNotifier.value = userProfileNotifier.value.copyWith(
        displayName: effectiveName,
        profileImageUrl: imageUrl ?? userProfileNotifier.value.profileImageUrl,
        plan: (plan != null && plan.isNotEmpty) ? plan : 'Free Plan',
        downloadedCount: downloadedCount ?? userProfileNotifier.value.downloadedCount,
        userGender: effectiveGender,
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

      // Reset blocked profiles set on init so all 12 profiles are available for testing
      _blockedIds.clear();

      // Apply to initial profiles list
      final updatedProfiles = _initialProfiles
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
      final profileDetails = await RegistrationDraft.loadProfileDetails();
      final savedGender = (profileDetails['gender'] != null && profileDetails['gender']!.trim().isNotEmpty)
          ? profileDetails['gender']!.trim()
          : (prefs.getString('user_gender')?.trim() ?? (userProfileNotifier.value.userGender.trim().isNotEmpty ? userProfileNotifier.value.userGender.trim() : 'Male'));
      final effectiveGender = (savedGender.isNotEmpty) ? savedGender : 'Male';

      userProfileNotifier.value = userProfileNotifier.value.copyWith(
        userGender: effectiveGender,
      );
      authNotifier.value = true;
    } catch (_) {}
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kIsLoggedIn, false);
      _isLoggedIn = false;
      authNotifier.value = false;
    } catch (_) {}
  }

  static final List<Profile> _initialProfiles = [
    // --- 5 WOMEN PROFILES ---
    Profile(
      id: 'p8',
      name: 'Nandhini Eswaran',
      age: 24,
      gender: 'female',
      maritalStatus: 'Single (Never Married)',
      dob: '28-08-2000',
      mobile: '+91 98765 43210',
      email: 'nandhini.eswaran@example.com',
      profileCreatedBy: 'Parents',
      heightText: "5'6\"",
      weightText: '58 kg',
      bloodGroup: 'B+ Positive',
      complexion: 'Fair',
      bodyType: 'Slim / Average',
      disability: 'None (Normal)',
      koottam: 'Sathandhai',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Revathi',
      horoscopeRasi: 'Meenam',
      horoscopePaatham: '4',
      lagnam: 'Dhanusu',
      dosham: 'No Dosham (Sevvai Dhosham Illai)',
      gothram: 'Sathandhai Gothram',
      eatingHabits: 'Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Classical Music, Reading Finance Books, Baking, Podcasts',
      familyStatus: 'Upper Middle Class',
      familyType: 'Nuclear Family',
      familyValues: 'Traditional & Modern Values',
      fatherOccupation: 'Businessman (Textile Manufacturing)',
      motherOccupation: 'Homemaker',
      brothersCount: '1 Brother (Married, M.S. USA)',
      sistersCount: 'None',
      ancestralOrigin: 'Perundurai, Erode',      education: 'B.Com & CA',
      educationDetail: 'Cleared CA First Attempt (ICAI Chennai)',
      occupation: 'Practicing Chartered Accountant',
      employedIn: 'Private Practice / Big 4 Firm',
      annualIncome: '₹ 14,00,000 / Annum',
      workLocation: 'Coimbatore',
      location: 'Coimbatore',
      nativePlace: 'Erode',
      city: 'Coimbatore',
      district: 'Coimbatore',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 94432 12345',
      prefAgeRange: '25 - 29 Years',
      prefHeightRange: "5'8\" - 6'1\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'B.E. / B.Tech / M.B.B.S. / M.D. / M.B.A. / C.A.',
      prefOccupation: 'Software Engineer / Doctor / Business Executive',
      prefLocation: 'Coimbatore, Erode, Tiruppur, Salem',
      bio: 'A career-oriented yet family-loving Chartered Accountant. I enjoy listening to finance podcasts, traveling, and learning new concepts. I am looking for a broad-minded, educated Kongu groom who values family togetherness.',
      partnerExpectations: 'Seeking a well-educated, respectful, and caring partner from Kongu Vellalar Gounder community. He should have a stable career or business and respect mutual growth.',
      profileImageUrl: 'assets/photos/women1.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1469371670807-013ccf25f16a?w=800&auto=format&fit=crop&q=80',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
    Profile(
      id: 'p2',
      name: 'Priya Palanisamy',
      age: 26,
      gender: 'female',
      maritalStatus: 'Single (Never Married)',
      dob: '12-11-1998',
      mobile: '+91 97890 67890',
      email: 'priya.palanisamy@example.com',
      profileCreatedBy: 'Parents',
      heightText: "5'5\"",
      weightText: '54 kg',
      bloodGroup: 'A+ Positive',
      complexion: 'Fair',
      bodyType: 'Slim',
      disability: 'None (Normal)',
      koottam: 'Sathandhai',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Rohini',
      horoscopeRasi: 'Rishabam',
      horoscopePaatham: '3',
      lagnam: 'Kanni',
      dosham: 'No Dosham',
      gothram: 'Sathandhai Gothram',
      eatingHabits: 'Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Cooking, Painting, Classical Music',
      familyStatus: 'High Class / Rich',
      familyType: 'Joint Family',
      familyValues: 'Traditional',
      fatherOccupation: 'Industrialist (Engineering Works)',
      motherOccupation: 'School Principal',
      brothersCount: '1 Brother (Unmarried)',
      sistersCount: 'None',
      ancestralOrigin: 'Gobichettipalayam, Erode',
      education: 'M.S. Data Analytics',
      educationDetail: 'Master of Science in Data Analytics (UK)',
      occupation: 'Data Scientist at Analytics Solutions',
      employedIn: 'Private Corporate Firm',
      annualIncome: '₹ 16,00,000 / Annum',
      workLocation: 'Erode',
      location: 'Erode',
      nativePlace: 'Gobichettipalayam',
      city: 'Erode',
      district: 'Erode',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 97890 11111',
      prefAgeRange: '27 - 31 Years',
      prefHeightRange: "5'8\" - 6'2\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'M.S. / M.B.A. / B.E. / M.D.',
      prefOccupation: 'Corporate / Data Analytics / Engineer / Business',
      prefLocation: 'Erode, Coimbatore, Bangalore, UK',
      bio: 'An ambitious, family-oriented woman who loves cooking, painting, and classical music. I believe marriage is a beautiful journey of mutual respect and friendship. Seeking a companion who is supportive and progressive.',
      partnerExpectations: 'Seeking an educated, understanding partner with good family background.',
      profileImageUrl: 'assets/photos/women2.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&auto=format&fit=crop&q=80',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
    Profile(
      id: 'p4',
      name: 'Deepika Shanmugam',
      age: 25,
      gender: 'female',
      maritalStatus: 'Single (Never Married)',
      dob: '05-09-1999',
      mobile: '+91 96555 43210',
      email: 'deepika.s@example.com',
      profileCreatedBy: 'Self',
      heightText: "5'3\"",
      weightText: '50 kg',
      bloodGroup: 'O+ Positive',
      complexion: 'Wheatish',
      bodyType: 'Slim',
      disability: 'None (Normal)',
      koottam: 'Thennan',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Karthigai',
      horoscopeRasi: 'Mesham',
      horoscopePaatham: '4',
      lagnam: 'Rishabam',
      dosham: 'No Dosham',
      gothram: 'Thennan Gothram',
      eatingHabits: 'Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Photography, Gardening, Organic Farming',
      familyStatus: 'Upper Middle Class',
      familyType: 'Nuclear Family',
      familyValues: 'Moderate',
      fatherOccupation: 'Civil Engineer / Contractor',
      motherOccupation: 'Teacher',
      brothersCount: 'None',
      sistersCount: '1 Sister (Student)',
      ancestralOrigin: 'Salem Native',
      education: 'B.Arch Architecture',
      educationDetail: 'Bachelor of Architecture (NIT Trichy)',
      occupation: 'Interior Architect & Designer',
      employedIn: 'Self-Employed Design Studio',
      annualIncome: '₹ 10,00,000 / Annum',
      workLocation: 'Salem',
      location: 'Salem',
      nativePlace: 'Salem',
      city: 'Salem',
      district: 'Salem',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 96555 88888',
      prefAgeRange: '26 - 30 Years',
      prefHeightRange: "5'6\" - 6'0\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'B.Arch / B.E. / M.B.A. / Architect',
      prefOccupation: 'Architect / Engineer / Designer / Corporate',
      prefLocation: 'Salem, Coimbatore, Chennai',
      bio: 'Creative soul with an eye for detail. I run my own interior design studio. Love photography, gardening, and organic farming. Looking for a sensible, passionate, and understanding partner.',
      partnerExpectations: 'Looking for a creative, supportive groom who respects independence.',
      profileImageUrl: 'assets/photos/women3.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1469371670807-013ccf25f16a?w=800&auto=format&fit=crop&q=80',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
    Profile(
      id: 'p6',
      name: 'Dr. Divya Nachimuthu',
      age: 27,
      gender: 'female',
      maritalStatus: 'Single (Never Married)',
      dob: '18-04-1997',
      mobile: '+91 94422 11223',
      email: 'dr.divya@example.com',
      profileCreatedBy: 'Parents',
      heightText: "5'4\"",
      weightText: '52 kg',
      bloodGroup: 'AB+ Positive',
      complexion: 'Fair',
      bodyType: 'Slim',
      disability: 'None (Normal)',
      koottam: 'Thorathan',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Mirugaseerisham',
      horoscopeRasi: 'Rishabam',
      horoscopePaatham: '3',
      lagnam: 'Thulaam',
      dosham: 'No Dosham',
      gothram: 'Thorathan Gothram',
      eatingHabits: 'Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Baking, Reading Medical Journals, Travel',
      familyStatus: 'Upper Middle Class',
      familyType: 'Nuclear Family',
      familyValues: 'Traditional',
      fatherOccupation: 'Senior Doctor (M.D.)',
      motherOccupation: 'Professor',
      brothersCount: '1 Brother (Studying M.D.)',
      sistersCount: 'None',
      ancestralOrigin: 'Pollachi, Coimbatore',
      education: 'M.D. Pediatrics',
      educationDetail: 'Doctor of Medicine in Pediatrics (PSG Tech)',
      occupation: 'Consultant Pediatrician',
      employedIn: 'Private Hospital',
      annualIncome: '₹ 15,00,000 / Annum',
      workLocation: 'Coimbatore',
      location: 'Coimbatore',
      nativePlace: 'Pollachi',
      city: 'Coimbatore',
      district: 'Coimbatore',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 94422 99999',
      prefAgeRange: '28 - 32 Years',
      prefHeightRange: "5'7\" - 6'1\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'M.D. / M.S. / M.B.B.S. / B.E. / M.B.A.',
      prefOccupation: 'Doctor / Medical Professional / Software Lead',
      prefLocation: 'Coimbatore, Erode, Tiruppur',
      bio: 'Dedicated medical professional who loves children. I am soft-spoken, patient, and love baking. Balance in work and family life is important to me.',
      partnerExpectations: 'Seeking an educated, caring groom from medical or engineering field.',
      profileImageUrl: 'assets/photos/women4.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&auto=format&fit=crop&q=80',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
    Profile(
      id: 'p10',
      name: 'Kaviya Kandasamy',
      age: 25,
      gender: 'female',
      maritalStatus: 'Single (Never Married)',
      dob: '20-02-1999',
      mobile: '+91 99441 55555',
      email: 'kaviya.k@example.com',
      profileCreatedBy: 'Parents',
      heightText: "5'5\"",
      weightText: '53 kg',
      bloodGroup: 'O+ Positive',
      complexion: 'Fair',
      bodyType: 'Average',
      disability: 'None (Normal)',
      koottam: 'Perunkudi',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Swathi',
      horoscopeRasi: 'Thulaam',
      horoscopePaatham: '2',
      lagnam: 'Simmam',
      dosham: 'No Dosham',
      gothram: 'Perunkudi Gothram',
      eatingHabits: 'Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Carnatic Music, Classical Dance, Reading',
      familyStatus: 'Upper Middle Class',
      familyType: 'Nuclear Family',
      familyValues: 'Traditional',
      fatherOccupation: 'Garment Exporter (Tiruppur)',
      motherOccupation: 'Homemaker',
      brothersCount: '1 Brother (Managing Export Unit)',
      sistersCount: 'None',
      ancestralOrigin: 'Avinashi, Tiruppur',
      education: 'M.Tech Biotechnology',
      educationDetail: 'Master of Technology in Bio-Tech',
      occupation: 'Assistant Professor at Arts & Science College',
      employedIn: 'Educational Institution',
      annualIncome: '₹ 8,00,000 / Annum',
      workLocation: 'Tiruppur',
      location: 'Tiruppur',
      nativePlace: 'Avinashi',
      city: 'Tiruppur',
      district: 'Tiruppur',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 99441 12345',
      prefAgeRange: '26 - 30 Years',
      prefHeightRange: "5'8\" - 6'1\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'B.E. / M.Tech / M.B.A. / Business Executive',
      prefOccupation: 'Business / Software / Engineering',
      prefLocation: 'Tiruppur, Coimbatore, Erode',
      bio: 'Cultured and academic-minded woman. I teach biotechnology and love traditional arts.',
      partnerExpectations: 'Seeking a family-oriented groom with good morals and stable career.',
      profileImageUrl: 'assets/photos/women5.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1469371670807-013ccf25f16a?w=800&auto=format&fit=crop&q=80',
      isPremium: false,
      isFavourite: false,
      interestStatus: 'none',
    ),

    // --- 5 MEN PROFILES ---
    Profile(
      id: 'p1',
      name: 'Karthik Ramasamy',
      age: 28,
      gender: 'male',
      maritalStatus: 'Single (Never Married)',
      dob: '15-05-1996',
      mobile: '+91 98421 12345',
      email: 'karthik.ramasamy@example.com',
      profileCreatedBy: 'Self',
      heightText: "5'11\"",
      weightText: '72 kg',
      bloodGroup: 'O+ Positive',
      complexion: 'Wheatish',
      bodyType: 'Athletic',
      disability: 'None (Normal)',
      koottam: 'Sellan',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Anusham',
      horoscopeRasi: 'Viruchigam',
      horoscopePaatham: '2',
      lagnam: 'Simmam',
      dosham: 'No Dosham',
      gothram: 'Sellan Gothram',
      eatingHabits: 'Non-Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Hiking, Tech Blogs, Badminton, Traveling',
      familyStatus: 'Upper Middle Class',
      familyType: 'Nuclear Family',
      familyValues: 'Moderate',
      fatherOccupation: 'Retired Government Officer',
      motherOccupation: 'Homemaker',
      brothersCount: 'None',
      sistersCount: '1 Sister (Married)',
      ancestralOrigin: 'Pollachi, Coimbatore',
      education: 'B.E. Computer Science',
      educationDetail: 'Bachelor of Engineering in CS (PSG Tech)',
      occupation: 'Senior Software Engineer at TechCorp',
      employedIn: 'MNC Software Company',
      annualIncome: '₹ 18,00,000 / Annum',
      workLocation: 'Coimbatore',
      location: 'Coimbatore',
      nativePlace: 'Pollachi',
      city: 'Coimbatore',
      district: 'Coimbatore',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 98421 99999',
      prefAgeRange: '23 - 27 Years',
      prefHeightRange: "5'3\" - 5'7\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'B.E. / B.Tech / M.S. / M.B.B.S.',
      prefOccupation: 'Software / Corporate / Doctor',
      prefLocation: 'Coimbatore, Erode, Chennai',
      bio: 'Hello! I am a down-to-earth person who values family and traditions while maintaining a modern outlook. I love hiking, reading tech blogs, and traveling. Looking for a partner who is independent and shares similar values.',
      partnerExpectations: 'Looking for a warm, caring, and progressive life partner from Kongu community.',
      profileImageUrl: 'assets/photos/men1.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&auto=format&fit=crop&q=80',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
    Profile(
      id: 'p3',
      name: 'Arun Kumar Gounder',
      age: 30,
      gender: 'male',
      maritalStatus: 'Single (Never Married)',
      dob: '10-10-1994',
      mobile: '+91 98940 12345',
      email: 'arun.gounder@example.com',
      profileCreatedBy: 'Parents',
      heightText: "5'8\"",
      weightText: '75 kg',
      bloodGroup: 'B+ Positive',
      complexion: 'Wheatish',
      bodyType: 'Average',
      disability: 'None (Normal)',
      koottam: 'Morasan',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Uthiradam',
      horoscopeRasi: 'Dhanusu',
      horoscopePaatham: '1',
      lagnam: 'Katagam',
      dosham: 'No Dosham',
      gothram: 'Morasan Gothram',
      eatingHabits: 'Non-Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Tennis, Cafe Exploring, Business Strategy',
      familyStatus: 'High Class / Rich',
      familyType: 'Joint Family',
      familyValues: 'Traditional',
      fatherOccupation: 'Managing Director (Textile Exports)',
      motherOccupation: 'Homemaker',
      brothersCount: '1 Brother (Married, Business Partner)',
      sistersCount: 'None',
      ancestralOrigin: 'Tiruppur Native',
      education: 'MBA (IIM Bangalore)',
      educationDetail: 'Master of Business Administration',
      occupation: 'Business Director, Textile Exports',
      employedIn: 'Family Business Enterprise',
      annualIncome: '₹ 35,00,000 / Annum',
      workLocation: 'Tiruppur',
      location: 'Tiruppur',
      nativePlace: 'Tiruppur',
      city: 'Tiruppur',
      district: 'Tiruppur',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 98940 99999',
      prefAgeRange: '24 - 28 Years',
      prefHeightRange: "5'2\" - 5'6\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'M.B.A. / B.E. / M.S. / M.D.',
      prefOccupation: 'Corporate / Finance / Business / Doctor',
      prefLocation: 'Tiruppur, Coimbatore, Erode',
      bio: 'Managing our family textile export business in Tiruppur. I enjoy playing tennis, exploring new cafes, and discussing business strategies.',
      partnerExpectations: 'Looking for a warm, understanding bride willing to balance career and family.',
      profileImageUrl: 'assets/photos/men2.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1582560475093-ba66accbc424?w=800&auto=format&fit=crop&q=80',
      isPremium: false,
      isFavourite: false,
      interestStatus: 'received',
    ),
    Profile(
      id: 'p5',
      name: 'Siddharth Sengottaiyan',
      age: 29,
      gender: 'male',
      maritalStatus: 'Single (Never Married)',
      dob: '02-03-1995',
      mobile: '+91 97877 66554',
      email: 'siddharth.s@example.com',
      profileCreatedBy: 'Self',
      heightText: "5'10\"",
      weightText: '70 kg',
      bloodGroup: 'A+ Positive',
      complexion: 'Fair',
      bodyType: 'Athletic',
      disability: 'None (Normal)',
      koottam: 'Kannandhai',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Aswini',
      horoscopeRasi: 'Mesham',
      horoscopePaatham: '2',
      lagnam: 'Mesham',
      dosham: 'No Dosham',
      gothram: 'Kannandhai Gothram',
      eatingHabits: 'Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Badminton, Reading History Books, Agriculture Tech',
      familyStatus: 'Upper Middle Class',
      familyType: 'Nuclear Family',
      familyValues: 'Traditional & Modern',
      fatherOccupation: 'Agriculture & Poultry Business',
      motherOccupation: 'Homemaker',
      brothersCount: 'None',
      sistersCount: '1 Sister (Unmarried)',
      ancestralOrigin: 'Namakkal Native',
      education: 'B.Tech & M.S. Germany',
      educationDetail: 'Master of Science (Germany)',
      occupation: 'Operations Manager, Poultry Foods',
      employedIn: 'Agro-Processing Corporate Unit',
      annualIncome: '₹ 20,00,000 / Annum',
      workLocation: 'Namakkal',
      location: 'Namakkal',
      nativePlace: 'Namakkal',
      city: 'Namakkal',
      district: 'Namakkal',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 97877 11111',
      prefAgeRange: '23 - 27 Years',
      prefHeightRange: "5'3\" - 5'7\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'B.E. / B.Tech / M.S. / M.B.A.',
      prefOccupation: 'Engineering / Corporate / Agriculture / Doctor',
      prefLocation: 'Namakkal, Erode, Salem, Coimbatore',
      bio: 'Passionate about agriculture and modern food tech. I run our agro-processing unit. I spend weekends playing badminton or reading history books.',
      partnerExpectations: 'Seeking a cheerful, caring bride with simple living and high thinking.',
      profileImageUrl: 'assets/photos/men3.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&auto=format&fit=crop&q=80',
      isPremium: false,
      isFavourite: false,
      interestStatus: 'sent',
    ),
    Profile(
      id: 'p7',
      name: 'Vignesh Ponnusamy',
      age: 27,
      gender: 'male',
      maritalStatus: 'Single (Never Married)',
      dob: '25-07-1997',
      mobile: '+91 98430 33445',
      email: 'vignesh.p@example.com',
      profileCreatedBy: 'Self',
      heightText: "5'9\"",
      weightText: '68 kg',
      bloodGroup: 'B+ Positive',
      complexion: 'Wheatish',
      bodyType: 'Slim',
      disability: 'None (Normal)',
      koottam: 'Sellan',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Poosam',
      horoscopeRasi: 'Katagam',
      horoscopePaatham: '1',
      lagnam: 'Viruchigam',
      dosham: 'No Dosham',
      gothram: 'Sellan Gothram',
      eatingHabits: 'Non-Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Automobile DIY, Long Drives, Road Trips',
      familyStatus: 'Upper Middle Class',
      familyType: 'Nuclear Family',
      familyValues: 'Moderate',
      fatherOccupation: 'Executive Engineer (PWD)',
      motherOccupation: 'Teacher',
      brothersCount: '1 Brother (Studying B.E.)',
      sistersCount: 'None',
      ancestralOrigin: 'Salem Native',
      education: 'B.E. Mechanical',
      educationDetail: 'Bachelor of Mechanical Engineering',
      occupation: 'Design Engineer, Automobile Sector',
      employedIn: 'Automobile Manufacturing Plant',
      annualIncome: '₹ 12,00,000 / Annum',
      workLocation: 'Salem',
      location: 'Salem',
      nativePlace: 'Salem',
      city: 'Salem',
      district: 'Salem',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 98430 00000',
      prefAgeRange: '23 - 26 Years',
      prefHeightRange: "5'2\" - 5'6\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'B.E. / B.Tech / B.Sc / M.Sc',
      prefOccupation: 'Engineering / Teaching / Corporate',
      prefLocation: 'Salem, Erode, Namakkal',
      bio: 'Automobile enthusiast who loves long drives, road trips, and working on mechanical DIY projects.',
      partnerExpectations: 'Looking for a cheerful and family-oriented bride.',
      profileImageUrl: 'assets/photos/men4.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1582560475093-ba66accbc424?w=800&auto=format&fit=crop&q=80',
      isPremium: false,
      isFavourite: false,
      interestStatus: 'received',
    ),
    Profile(
      id: 'p9',
      name: 'Dr. Praveen Muthusamy',
      age: 31,
      gender: 'male',
      maritalStatus: 'Single (Never Married)',
      dob: '14-01-1993',
      mobile: '+91 94433 77777',
      email: 'dr.praveen@example.com',
      profileCreatedBy: 'Parents',
      heightText: "6'0\"",
      weightText: '78 kg',
      bloodGroup: 'O+ Positive',
      complexion: 'Fair',
      bodyType: 'Athletic',
      disability: 'None (Normal)',
      koottam: 'Thennan',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Uthiratadhi',
      horoscopeRasi: 'Meenam',
      horoscopePaatham: '3',
      lagnam: 'Dhanusu',
      dosham: 'No Dosham',
      gothram: 'Thennan Gothram',
      eatingHabits: 'Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Fitness, Medical Research, Classical Violin',
      familyStatus: 'High Class / Rich',
      familyType: 'Nuclear Family',
      familyValues: 'Traditional',
      fatherOccupation: 'Hospital Founder & Chairman',
      motherOccupation: 'Obstetrician (Doctor)',
      brothersCount: 'None',
      sistersCount: '1 Sister (Doctor, Married)',
      ancestralOrigin: 'Erode Native',
      education: 'M.D. General Medicine',
      educationDetail: 'Doctor of Medicine (M.D.)',
      occupation: 'Consultant Physician & Cardiologist',
      employedIn: 'Multi-Specialty Hospital',
      annualIncome: '₹ 28,00,000 / Annum',
      workLocation: 'Erode',
      location: 'Erode',
      nativePlace: 'Erode',
      city: 'Erode',
      district: 'Erode',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 94433 11111',
      prefAgeRange: '25 - 29 Years',
      prefHeightRange: "5'4\" - 5'8\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'M.B.B.S. / M.D. / M.S. / B.E. / C.A.',
      prefOccupation: 'Doctor / Medical Professional / CA / Engineer',
      prefLocation: 'Erode, Coimbatore, Salem, Tiruppur',
      bio: 'Cardiologist with a passion for healthcare and healthy living. I play the violin during spare time.',
      partnerExpectations: 'Seeking an educated, warm, and cultured bride from a good family.',
      profileImageUrl: 'assets/photos/men5.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&auto=format&fit=crop&q=80',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
    Profile(
      id: 'p11',
      name: 'Gokul Sampath',
      age: 28,
      gender: 'male',
      maritalStatus: 'Single (Never Married)',
      dob: '04-06-1996',
      mobile: '+91 98425 66778',
      email: 'gokul.sampath@example.com',
      profileCreatedBy: 'Self',
      heightText: "5'11\"",
      weightText: '74 kg',
      bloodGroup: 'A+ Positive',
      complexion: 'Fair',
      bodyType: 'Athletic',
      disability: 'None (Normal)',
      koottam: 'Vaanan',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Thiruvonam',
      horoscopeRasi: 'Makaram',
      horoscopePaatham: '2',
      lagnam: 'Katagam',
      dosham: 'No Dosham',
      gothram: 'Vaanan Gothram',
      eatingHabits: 'Non-Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Cycling, Tech Innovations, Gaming',
      familyStatus: 'Upper Middle Class',
      familyType: 'Nuclear Family',
      familyValues: 'Moderate',
      fatherOccupation: 'Textile Factory Owner',
      motherOccupation: 'Homemaker',
      brothersCount: '1 Brother (Unmarried)',
      sistersCount: 'None',
      ancestralOrigin: 'Coimbatore Native',
      education: 'B.E. & MBA (IIT)',
      educationDetail: 'B.E. Computer Science & MBA (IIT Madras)',
      occupation: 'Product Manager at Tech Systems',
      employedIn: 'Product MNC Corporate',
      annualIncome: '₹ 24,00,000 / Annum',
      workLocation: 'Coimbatore',
      location: 'Coimbatore',
      nativePlace: 'Coimbatore',
      city: 'Coimbatore',
      district: 'Coimbatore',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 98425 11111',
      prefAgeRange: '23 - 27 Years',
      prefHeightRange: "5'3\" - 5'7\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'B.E. / M.B.A. / M.S. / M.D.',
      prefOccupation: 'Corporate / Product / Software / Doctor',
      prefLocation: 'Coimbatore, Erode, Tiruppur',
      bio: 'Product Manager with passion for building scalable software products. Enjoy weekend cycling, tech reading, and family gatherings.',
      partnerExpectations: 'Seeking an educated, warm, and progressive partner with good values.',
      profileImageUrl: 'assets/photos/men6.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&auto=format&fit=crop&q=80',
      isPremium: true,
      isFavourite: false,
      interestStatus: 'none',
    ),
    Profile(
      id: 'p12',
      name: 'Ananya Velusamy',
      age: 26,
      gender: 'female',
      maritalStatus: 'Single (Never Married)',
      dob: '19-10-1998',
      mobile: '+91 97899 44332',
      email: 'ananya.v@example.com',
      profileCreatedBy: 'Parents',
      heightText: "5'4\"",
      weightText: '52 kg',
      bloodGroup: 'B+ Positive',
      complexion: 'Fair',
      bodyType: 'Slim',
      disability: 'None (Normal)',
      koottam: 'Sempoothan',
      subsect: 'Kongu Vellalar Gounder',
      horoscopeStar: 'Anusham',
      horoscopeRasi: 'Viruchigam',
      horoscopePaatham: '3',
      lagnam: 'Thulaam',
      dosham: 'No Dosham',
      gothram: 'Sempoothan Gothram',
      eatingHabits: 'Vegetarian',
      smokingHabits: 'No',
      drinkingHabits: 'No',
      hobbies: 'Violin, Fine Arts, Traveling',
      familyStatus: 'Upper Middle Class',
      familyType: 'Nuclear Family',
      familyValues: 'Traditional',
      fatherOccupation: 'Paper Mill Executive Director',
      motherOccupation: 'Homemaker',
      brothersCount: 'None',
      sistersCount: '1 Sister (Married)',
      ancestralOrigin: 'Karur Native',
      education: 'M.Com & Financial Analyst',
      educationDetail: 'Master of Commerce & Certified Financial Analyst',
      occupation: 'Senior Financial Analyst',
      employedIn: 'Corporate Financial Consultancy',
      annualIncome: '₹ 12,00,000 / Annum',
      workLocation: 'Karur',
      location: 'Karur',
      nativePlace: 'Karur',
      city: 'Karur',
      district: 'Karur',
      state: 'Tamil Nadu',
      country: 'India',
      alternateMobile: '+91 97899 11111',
      prefAgeRange: '27 - 30 Years',
      prefHeightRange: "5'8\" - 6'1\"",
      prefMaritalStatus: 'Single (Never Married)',
      prefEducation: 'B.E. / M.B.A. / C.A. / Corporate Lead',
      prefOccupation: 'Finance / Corporate / Software / Business',
      prefLocation: 'Karur, Coimbatore, Erode, Tiruppur',
      bio: 'Finance enthusiast with an artistic touch. I play the violin and enjoy exploring classical architecture.',
      partnerExpectations: 'Seeking a family-oriented, mature groom from Kongu community.',
      profileImageUrl: 'assets/photos/women6.jpg',
      coverImageUrl: 'https://images.unsplash.com/photo-1469371670807-013ccf25f16a?w=800&auto=format&fit=crop&q=80',
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
      plan: 'Free Plan',
      downloadedCount: 0,
    ),
  );

  static Future<void> updateUserProfile({
    String? displayName,
    String? imageUrl,
    String? plan,
    int? downloadedCount,
    String? gender,
  }) async {
    userProfileNotifier.value = userProfileNotifier.value.copyWith(
      displayName: displayName,
      profileImageUrl: imageUrl,
      plan: plan,
      downloadedCount: downloadedCount,
      userGender: gender,
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      if (displayName != null) await prefs.setString(_kDisplayName, displayName);
      if (imageUrl != null) await prefs.setString(_kProfileImageUrl, imageUrl);
      if (plan != null) await prefs.setString(_kPlan, plan);
      if (downloadedCount != null) await prefs.setInt(_kDownloadedCount, downloadedCount);
      if (gender != null) await prefs.setString('user_gender', gender);
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
      plan: 'Free Plan',
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
