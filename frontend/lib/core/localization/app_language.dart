import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, tamil }

class AppLanguageController {
  static const String _kLanguagePrefKey = 'selected_app_language';

  static final ValueNotifier<AppLanguage> notifier = ValueNotifier<AppLanguage>(AppLanguage.english);

  static AppLanguage get current => notifier.value;
  static bool get isTamil => notifier.value == AppLanguage.tamil;

  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLang = prefs.getString(_kLanguagePrefKey);
      if (savedLang == 'tamil') {
        notifier.value = AppLanguage.tamil;
      } else {
        notifier.value = AppLanguage.english;
      }
    } catch (_) {}
  }

  static Future<void> setLanguage(AppLanguage lang) async {
    notifier.value = lang;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLanguagePrefKey, lang == AppLanguage.tamil ? 'tamil' : 'english');
    } catch (_) {}
  }

  static String text(String input) {
    if (input.trim().isEmpty) return input;
    if (notifier.value == AppLanguage.tamil) {
      // 1. Direct key match
      if (_tamilTranslations.containsKey(input)) {
        return _tamilTranslations[input]!;
      }
      // 2. Case-insensitive key match
      final lower = input.toLowerCase().trim();
      if (_tamilTranslations.containsKey(lower)) {
        return _tamilTranslations[lower]!;
      }

      // 3. Smart substring replacement for mixed phrases
      String translated = input;
      bool matched = false;
      _tamilTranslations.forEach((engKey, tamilVal) {
        if (engKey.length > 2 && translated.toLowerCase().contains(engKey.toLowerCase())) {
          final regex = RegExp(RegExp.escape(engKey), caseSensitive: false);
          translated = translated.replaceAll(regex, tamilVal);
          matched = true;
        }
      });
      if (matched) return translated;
    }
    return _englishTranslations[input] ?? input;
  }

  // English Dictionary
  static final Map<String, String> _englishTranslations = {
    // Navigation & App Bar
    'app_title': 'Kongu Matrimony',
    'nav_home': 'Home',
    'nav_horoscope': 'Horoscope',
    'nav_favourites': 'Favourites',
    'nav_interests': 'Interests',
    'nav_profile': 'Profile',

    // Home Page
    'welcome_title': 'Kongu Matrimony',
    'home_subtitle': 'Trusted Matrimony for Kongu Vellalar Gounder Community',
    'verified_profiles_count': '12 Active Verified Profiles',
    'explore_matches': 'Explore Horoscope Matches',
    'featured_profiles': 'Featured Profiles',
    'smart_discovery': 'Smart Discovery',
    'horoscope_sync': 'Horoscope Porutham',
    'direct_connect': 'Direct Family Contact',
    'kootam_verified': '100% Kootam Verified',

    // Language Selector Sheet
    'select_language': 'Select Language',
    'english_label': 'English',
    'tamil_label': 'தமிழ் (Tamil)',
    'choose_app_language': 'Choose your preferred app language:',

    // Horoscope & Filters
    'horoscope_profiles': 'Horoscope Profiles',
    'all_profiles': 'All Profiles',
    'women_profiles': 'Women Profiles',
    'men_profiles': 'Men Profiles',
    'view_full_profile': 'View Full Profile',
    'yrs': 'Yrs',
    'no_profiles_found': 'No Profiles Found',

    // Card Headers in Profile Details
    'profile_overview': 'Profile Overview',
    'basic_information': 'Basic Information',
    'physical_attributes': 'Physical Attributes',
    'religious_horoscope': 'Religious & Horoscope Details',
    'education_professional': 'Education & Professional Details',
    'family_details': 'Family Details',
    'location_contact': 'Location & Contact Details',
    'habits_lifestyle': 'Habits & Lifestyle',
    'partner_expectations': 'Partner Expectations',
    'about_bio': 'About & Short Bio',
    'download_actions': 'Download & Actions',

    // Field Labels
    'name': 'Name',
    'age': 'Age',
    'gender': 'Gender',
    'female': 'Female',
    'male': 'Male',
    'marital_status': 'Marital Status',
    'dob': 'Date of Birth',
    'mobile': 'Mobile',
    'email': 'Email',
    'height': 'Height',
    'weight': 'Weight',
    'blood_group': 'Blood Group',
    'complexion': 'Complexion',
    'body_type': 'Body Type',
    'disability': 'Physical Status / Disability',
    'koottam': 'Kongu Kootam',
    'subsect': 'Subsect / Caste',
    'horoscope_star': 'Horoscope Star (Natchathiram)',
    'horoscope_rasi': 'Rasi (Zodiac)',
    'horoscope_paatham': 'Paatham',
    'lagnam': 'Lagnam',
    'dosham': 'Dosham',
    'gothram': 'Gothram',
    'family_status': 'Family Status',
    'family_type': 'Family Type',
    'family_values': 'Family Values',
    'father_occupation': 'Father Occupation',
    'mother_occupation': 'Mother Occupation',
    'brothers': 'Brothers',
    'sisters': 'Sisters',
    'ancestral_origin': 'Ancestral Origin',
    'education': 'Education',
    'education_detail': 'Education Details',
    'occupation': 'Occupation',
    'employed_in': 'Employed In',
    'annual_income': 'Annual Income',
    'work_location': 'Work Location',
    'location': 'Location',
    'native_place': 'Native Place',
    'city': 'City',
    'district': 'District',
    'state': 'State',
    'country': 'Country',
    'eating_habits': 'Eating Habits',
    'smoking_habits': 'Smoking Habits',
    'drinking_habits': 'Drinking Habits',
    'hobbies': 'Hobbies',
    'pref_age': 'Preferred Age Range',
    'pref_height': 'Preferred Height',
    'pref_marital_status': 'Preferred Marital Status',
    'pref_education': 'Preferred Education',
    'pref_occupation': 'Preferred Occupation',
    'pref_location': 'Preferred Location',
    'bio': 'About Me',
    'download_horoscope': 'Download Horoscope Copy (PDF)',
    'view_horoscope': 'View Horoscope',
    'send_interest': 'Express Interest',
    'add_favourite': 'Save Profile',
    'verified': 'Verified Profile',

    // Paywall & Membership
    'locked_info': '🔒 Upgrade Plan to Unlock',
    'unlock_contact': 'Unlock Contact Details',
    'contact_locked_msg': 'Contact info is locked for Free users. Upgrade to Gold or Platinum plan to view full phone number, email & horoscope.',
    'membership_plans': 'Membership Plans',
    'gold_membership': 'Gold Plan (50 Contacts)',
    'platinum_membership': 'Platinum Plan (Unlimited)',
    'upgrade_now': 'Upgrade Now',
    'plan_upgraded_success': 'Plan successfully upgraded! All details unlocked.',

    // Common Values
    'vegetarian': 'Vegetarian',
    'non_vegetarian': 'Non-Vegetarian',
    'no_dosham': 'No Dosham (Sevvai Dhosham Illai)',
    'single_never_married': 'Single (Never Married)',
  };

  // Tamil Dictionary
  static final Map<String, String> _tamilTranslations = {
    // Navigation & App Bar
    'app_title': 'கொங்கு மேட்ரிமோனி',
    'nav_home': 'முகப்பு',
    'nav_horoscope': 'ஜாதகம்',
    'nav_favourites': 'விருப்பம்',
    'nav_interests': 'ஆர்வம்',
    'nav_profile': 'சுயவிவரம்',

    // Home Page
    'welcome_title': 'கொங்கு மேட்ரிமோனி',
    'home_subtitle': 'கொங்கு வேளாளர் கவுண்டர் சமூகத்தின் நம்பகமான மேட்ரிமோனி',
    'verified_profiles_count': '12 உறுதிசெய்யப்பட்ட சுயவிவரங்கள்',
    'explore_matches': 'ஜாதக சுயவிவரங்களை காண்க',
    'featured_profiles': 'சிறப்பு சுயவிவரங்கள்',
    'smart_discovery': 'ஸ்மார்ட் தேடல்',
    'horoscope_sync': 'ஜாதக பொருத்தம்',
    'direct_connect': 'நேரடி குடும்ப தொடர்பு',
    'kootam_verified': '100% கூட்டம் சரிபார்க்கப்பட்டது',

    // Language Selector Sheet
    'select_language': 'மொழியைத் தேர்ந்தெடுக்கவும்',
    'english_label': 'English',
    'tamil_label': 'தமிழ் (Tamil)',
    'choose_app_language': 'உங்கள் பயன்பாட்டு மொழியைத் தேர்வு செய்யவும்:',

    // Horoscope & Filters
    'horoscope_profiles': 'ஜாதக சுயவிவரங்கள்',
    'all_profiles': 'அனைத்தும்',
    'women_profiles': 'பெண் வரன்கள்',
    'men_profiles': 'ஆண் வரன்கள்',
    'view_full_profile': 'முழு விவரம்',
    'yrs': 'வயது',
    'no_profiles_found': 'சுயவிவரங்கள் எதுவும் கிடைக்கவில்லை',

    // Card Headers in Profile Details
    'profile_overview': 'சுயவிவர மேலோட்டம்',
    'basic_information': 'அடிப்படை விவரங்கள்',
    'physical_attributes': 'உடல் பண்புகள்',
    'religious_horoscope': 'சமயம் மற்றும் ஜாதக விவரங்கள்',
    'education_professional': 'கல்வி மற்றும் தொழில் விவரங்கள்',
    'family_details': 'குடும்ப விவரங்கள்',
    'location_contact': 'இருப்பிடம் மற்றும் தொடர்பு விவரங்கள்',
    'habits_lifestyle': 'பழக்கவழக்கங்கள் மற்றும் வாழ்க்கை முறை',
    'partner_expectations': 'எதிர்பார்க்கும் துணை விவரங்கள்',
    'about_bio': 'சுய அறிமுகம்',
    'download_actions': 'பதிவிறக்கம் மற்றும் நடவடிக்கைகள்',

    // Field Labels
    'name': 'பெயர்',
    'age': 'வயது',
    'gender': 'பாலினம்',
    'female': 'பெண்',
    'male': 'ஆண்',
    'marital_status': 'திருமண நிலை',
    'dob': 'பிறந்த தேதி',
    'mobile': 'தொலைபேசி எண்',
    'email': 'மின்னஞ்சல்',
    'height': 'உயரம்',
    'weight': 'எடை',
    'blood_group': 'இரத்த வகை',
    'complexion': 'நிறம்',
    'body_type': 'உடல் அமைப்பு',
    'disability': 'உடல் குறைபாடு',
    'koottam': 'கூட்டம்',
    'subsect': 'உட்பிரிவு / சாதி',
    'star': 'நட்சத்திரம்',
    'rasi': 'ராசி',
    'paatham': 'பாதம்',
    'lagnam': 'லக்னம்',
    'dosham': 'தோஷம்',
    'gothram': 'கோத்திரம்',
    'education': 'கல்வி தகுதி',
    'education_detail': 'கல்வி விவரம்',
    'occupation': 'தொழில் / பணி',
    'employed_in': 'பணிபுரியும் துறை',
    'annual_income': 'ஆண்டு வருமானம்',
    'work_location': 'பணிபுரியும் இடம்',
    'location': 'இருப்பிடம்',
    'native_place': 'சொந்த ஊர்',
    'city': 'நகரம்',
    'district': 'மாவட்டம்',
    'state': 'மாநிலம்',
    'country': 'நாடு',
    'father_occupation': 'தந்தையின் தொழில்',
    'mother_occupation': 'தாயின் தொழில்',
    'brothers': 'சகோதரர்கள்',
    'sisters': 'சகோதரிகள்',
    'ancestral_origin': 'பூர்வீகம்',
    'eating_habits': 'உணவுப் பழக்கம்',
    'smoking_habits': 'புகைப்பிடிக்கும் பழக்கம்',
    'drinking_habits': 'மது அருந்தும் பழக்கம்',
    'hobbies': 'பொழுதுபோக்குகள்',
    'pref_age': 'எதிர்பார்க்கும் வயது',
    'pref_height': 'எதிர்பார்க்கும் உயரம்',
    'pref_marital_status': 'எதிர்பார்க்கும் திருமண நிலை',
    'pref_education': 'எதிர்பார்க்கும் கல்வி',
    'pref_occupation': 'எதிர்பார்க்கும் தொழில்',
    'pref_location': 'எதிர்பார்க்கும் இடம்',
    'bio': 'என்னைப் பற்றி',
    'download_horoscope': 'ஜாதக நகல் பதிவிறக்கம் (PDF)',
    'view_horoscope': 'ஜாதகம் பார்க்க',
    'send_interest': 'விருப்பம் தெரிவிக்க',
    'add_favourite': 'சுயவிவரம் சேமிக்க',
    'verified': 'உறுதிசெய்யப்பட்ட சுயவிவரம்',

    // Paywall & Membership
    'locked_info': '🔒 அறிய திட்டத்தை உயர்த்தவும்',
    'unlock_contact': 'தொடர்பு விவரங்களை பெற',
    'contact_locked_msg': 'இலவச பயனர்களுக்கு தொடர்பு விவரங்கள் மறைக்கப்பட்டுள்ளன. தொலைபேசி எண், மின்னஞ்சல் மற்றும் ஜாதகம் பெற திட்டத்தை உயர்த்தவும்.',
    'membership_plans': 'உறுப்பினர்தன்மை திட்டங்கள்',
    'gold_membership': 'கோல்ட் திட்டம் (50 தொடர்புகள்)',
    'platinum_membership': 'பிளாட்டினம் திட்டம் (வரம்பற்ற தொடர்புகள்)',
    'upgrade_now': 'இப்பொழுதே உயர்த்தவும்',
    'plan_upgraded_success': 'திட்டம் உயர்த்தப்பட்டது! அனைத்து விவரங்களும் திறக்கப்பட்டன.',

    // Common Values
    'vegetarian': 'சைவம்',
    'non_vegetarian': 'அசைவம்',
    'no_dosham': 'செவ்வாய் தோஷம் இல்லை',
    'single_never_married': 'திருமணமாகாதவர்',

    // Cities
    'coimbatore': 'கோயம்புத்தூர்',
    'salem': 'சேலம்',
    'chennai': 'சென்னை',
    'erode': 'ஈரோடு',
    'tiruppur': 'திருப்பூர்',
    'namakkal': 'நாமக்கல்',
    'karur': 'கரூர்',
    'dindigul': 'திண்டுக்கல்',
    'tamil nadu': 'தமிழ்நாடு',
    'india': 'இந்தியா',

    // Educations & Degrees
    'b.e. computer science': 'பி.இ. கம்ப்யூட்டர் சயின்ஸ்',
    'm.d. pediatrics': 'எம்.டி. குழந்தைகள் மருத்துவம்',
    'b.tech & mba': 'பி.டெக் & எம்பா',
    'b.arch architecture': 'பி.ஆர்க் கட்டிடக்கலை',
    'b.com & ca': 'பி.காம் & சி.ஏ',
    'm.sc data analytics': 'எம்.எஸ்சி டேட்டா அனலிட்டிக்ஸ்',
    'm.d. general medicine': 'எம்.டி. பொது மருத்துவம்',
    'b.des interior design': 'பி.டெஸ் இன்டீரியர் டிசைன்',
    'b.e. mechanical': 'பி.இ. மெக்கானிக்கல்',
    'm.com & financial analyst': 'எம்.காம் நிதி ஆய்வாளர்',
    'b.e. & mba (iit)': 'பி.இ. & எம்பா (ஐஐடி)',

    // Common Answers & Hobbies
    'no': 'இல்லை',
    'yes': 'ஆம்',
    'not_interested': 'விருப்பமில்லை',
    'not interested': 'விருப்பமில்லை',
    'express interest': 'விருப்பம் தெரிவிக்க',
    'classical music, reading finance books, baking, podcasts': 'இசை, நிதி புத்தகங்கள் படித்தல், சமையல்',
    'cooking, painting, classical music': 'சமையல், ஓவியம், இசை',
    'photography, gardening, organic farming': 'புகைப்படம், தோட்டம் அமைத்தல்',
    'baking, reading medical journals, travel': 'மருத்துவ இதழ்கள் படித்தல், பயணம்',
    'carnatic music, classical dance, reading': 'கர்நாடக இசை, பரதநாட்டியம்',
    'hiking, tech blogs, badminton, traveling': 'பேட்மிண்டன், தொழில்நுட்பம், பயணம்',
    'tennis, cafe exploring, business strategy': 'டென்னிஸ், வணிக உத்திகள்',
    'badminton, reading history books, agriculture tech': 'பேட்மிண்டன், வரலாறு படித்தல்',
    'automobile diy, long drives, road trips': 'வாகனம் ஓட்டுதல், பயணம்',
    'fitness, medical research, classical violin': 'வயலின் இசை, உடற்பயிற்சி',
    'cycling, tech innovations, gaming': 'சைக்கிள் ஓட்டுதல், கேமிங்',
  };
}
