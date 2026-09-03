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
      // 2. Case-insensitive key match & space/underscore normalization
      final lower = input.toLowerCase().trim();
      if (_tamilTranslations.containsKey(lower)) {
        return _tamilTranslations[lower]!;
      }
      final lowerUnderscore = lower.replaceAll(' ', '_');
      if (_tamilTranslations.containsKey(lowerUnderscore)) {
        return _tamilTranslations[lowerUnderscore]!;
      }
      final lowerSpace = lower.replaceAll('_', ' ');
      if (_tamilTranslations.containsKey(lowerSpace)) {
        return _tamilTranslations[lowerSpace]!;
      }

      // 3. Smart substring replacement with word boundaries for mixed phrases (sorted longest keys first)
      String translated = input;
      bool matched = false;
      final sortedKeys = _tamilTranslations.keys.toList()
        ..sort((a, b) => b.length.compareTo(a.length));

      for (final engKey in sortedKeys) {
        final tamilVal = _tamilTranslations[engKey]!;
        if (engKey.length > 2 && translated.toLowerCase().contains(engKey.toLowerCase())) {
          final regex = RegExp(r'\b' + RegExp.escape(engKey) + r'\b', caseSensitive: false);
          if (regex.hasMatch(translated)) {
            translated = translated.replaceAll(regex, tamilVal);
            matched = true;
          }
        }
      }
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
    'about_bio': 'About Myself',
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
    'not_interested': 'Not Interested',
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
    'not_interested': 'விருப்பமில்லை',
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

    // Membership Plan Features
    'valid for 3 months': '3 மாதங்கள் செல்லுபடியாகும்',
    'valid for 6 months': '6 மாதங்கள் செல்லுபடியாகும்',
    'access 40 verified phone & email': '40 உறுதிசெய்யப்பட்ட தொடர்பு எண்கள்',
    'access 100 verified phone & email': '100 உறுதிசெய்யப்பட்ட தொடர்பு எண்கள்',
    'send unlimited messages & chat': 'வரம்பற்ற செய்திகள் அனுப்புதல்',
    'unlimited horoscope views & downloads': 'வரம்பற்ற ஜாதகம் பார்த்தல்',
    'view verified profiles with photos': 'உறுதிசெய்யப்பட்ட சுயவிவரங்கள்',
    'view unlimited phone nos*': 'வரம்பற்ற தொடர்பு எண்கள் பார்க்க',
    'free profile highlighter & top rank': 'இலவச சுயவிவர விளம்பரம்',
    'cannot view mobile & email (locked)': 'தொடர்பு எண்கள் பார்க்க முடியாது',
    'cannot view horoscope charts (locked)': 'ஜாதக கட்டங்கள் பார்க்க முடியாது',
    'cannot view family & income (locked)': 'குடும்ப விவரங்கள் பார்க்க முடியாது',
    '₹ 0 / free forever': '₹ 0 / எப்போதும் இலவசம்',
    '₹ 900 per month': 'மாதம் ₹ 900 மட்டுமே',
    '₹ 800 per month': 'மாதம் ₹ 800 மட்டுமே',
    '₹ 1,333 per month': 'மாதம் ₹ 1,333 மட்டுமே',

    // Registration Steps & Headers
    'create your account': 'உங்கள் கணக்கை உருவாக்கவும்',
    'find your perfect match from erode and surrounding areas': 'ஈரோடு மற்றும் சுற்றியுள்ள பகுதிகளின் சிறந்த வரன்கள்',
    'edit profile': 'சுயவிவரத்தை திருத்து',
    'step': 'படி',
    'save draft': 'வரைவை சேமி',
    'personal details': 'தனிப்பட்ட விவரங்கள்',
    'account credentials': 'கணக்கு கடவுச்சொல்',
    'profile created by': 'சுயவிவரம் உருவாக்குபவர்',
    'physical details': 'உடல் விவரங்கள்',
    'physical attributes': 'உடல் அமைப்பு விவரங்கள்',
    'astrology profile': 'ஜாதக விவரங்கள்',
    'astrological details': 'ஜாதக விவரங்கள்',
    'lifestyle & hobbies': 'வாழ்க்கை முறை & பொழுதுபோக்குகள்',
    'lifestyle & habits': 'வாழ்க்கை முறை & பழக்கவழக்கங்கள்',
    'family details': 'குடும்ப விவரங்கள்',
    'family background': 'குடும்ப பின்னணி விவரங்கள்',
    'education & career': 'கல்வி & பணி விவரங்கள்',
    'education & occupation profile': 'கல்வி & தொழில் விவரங்கள்',
    'education & occupation': 'கல்வி & தொழில் விவரங்கள்',
    'contact & location': 'தொடர்பு & முகவரி விவரங்கள்',
    'communication details': 'தொடர்பு விவரங்கள்',
    'partner preference details': 'எதிர்பார்க்கும் துணை விருப்பங்கள்',
    'partner expectation': 'துணை பற்றிய எதிர்பார்ப்புகள்',
    'partner expectations': 'துணை பற்றிய எதிர்பார்ப்புகள்',
    'partner preferences': 'வாழ்க்கை துணை விருப்பங்கள்',
    'about myself': 'என்னை பற்றி',
    'write about yourself': 'உங்களைப் பற்றி எழுதுங்கள்',

    // Form Field Labels & Choices
    'full name *': 'முழு பெயர் *',
    'gender *': 'பாலினம் *',
    'marital status *': 'திருமண நிலை *',
    'date of birth *': 'பிறந்த தேதி *',
    'phone number *': 'தொலைபேசி எண் *',
    'password *': 'கடவுச்சொல் *',
    'confirm password *': 'கடவுச்சொல்லை உறுதிப்படுத்தவும் *',
    'blood group': 'இரத்த வகை',
    'body type': 'உடல் அமைப்பு',
    'athletic': 'தடகளம்',
    'slim': 'மெலிந்த',
    'average': 'சாதாரண',
    'heavy': 'உடல் பருமன்',
    'drink': 'மது அருந்துதல்',
    'smoke': 'புகைப்பிடித்தல்',
    'occasionally': 'எப்போதாவது',
    'skin tone': 'தோல் நிறம்',
    'brown': 'பழுப்பு',
    'medium': 'நடுத்தரம்',
    'very fair': 'மிகவும் சிகப்பு',
    'fair': 'சிகப்பு',
    'wheatish': 'கோதுமை நிறம்',
    'diet': 'உணவுப் பழக்கம்',
    'veg': 'சைவம்',
    'non-veg': 'அசைவம்',
    'vegan': 'சுத்த சைவ உணவு',
    'physically challenged': 'உடல் மாற்றுத்திறனாளி',
    'kula theiva temple': 'குலதெய்வம் கோயில்',
    'time of birth': 'பிறந்த நேரம்',
    'place of birth': 'பிறந்த இடம்',
    'father name': 'தந்தையின் பெயர்',
    'mother name': 'தாயின் பெயர்',
    'father occupation': 'தந்தையின் தொழில்',
    'mother occupation': 'தாயின் தொழில்',
    'no. of brothers': 'சகோதரர்களின் எண்ணிக்கை',
    'no. of sisters': 'சகோதரிகளின் எண்ணிக்கை',
    'sisters married': 'திருமணமான சகோதரிகள்',
    'brothers married': 'திருமணமான சகோதரர்கள்',
    'family type': 'குடும்ப வகை',
    'family status': 'குடும்ப நிலை',
    'family values': 'குடும்ப கொள்கைகள்',
    'affluent': 'மிகவும் செல்வந்தர்',
    'rich': 'செல்வந்தர்',
    'upper middle': 'உயர் நடுத்தர வர்க்கம்',
    'middle': 'நடுத்தர வர்க்கம்',
    'family annual income': 'குடும்ப ஆண்டு வருமானம்',
    'family property': 'குடும்ப சொத்து விவரங்கள்',
    'family monthly income': 'குடும்ப மாத வருமானம்',
    'farming land details': 'விவசாய நில விவரங்கள்',
    'native place': 'சொந்த ஊர்',
    'native': 'சொந்த ஊர்',
    'education level': 'கல்வி தகுதி நிலை',
    'family name': 'குடும்ப பெயர் / வகையறா',
    'education detail': 'கல்வி விரிவான விவரம்',
    'highest education': 'உயர்கல்வி தகுதி',
    'education details': 'கல்வி விவரம்',
    'job details': 'பணி விவரங்கள்',
    'current working company': 'தற்போதைய நிறுவனம்',
    'current city or near by city': 'தற்போதைய அல்லது அருகில் உள்ள நகரம்',
    'annual income': 'ஆண்டு வருமானம்',
    'monthly income': 'மாத வருமானம்',
    'alternate mobile': 'மாற்று கைபேசி எண்',
    'email address': 'மின்னஞ்சல் முகவரி',
    'refer name': 'பரிந்துரைத்தவர் பெயர்',
    'refer mobile': 'பரிந்துரைத்தவர் கைபேசி எண்',
    'work location': 'பணிபுரியும் இடம்',
    'address': 'முகவரி',
    'postal code': 'அஞ்சல் குறியீடு (Pincode)',
    'interests': 'ஆர்வங்கள்',
    'favourite music': 'விருப்பமான இசை',
    'preferred musics': 'விருப்பமான இசை வகைகள்',
    'sport/fitness activities': 'விளையாட்டு & உடற்பயிற்சி',
    'favourite cuisine': 'விருப்பமான உணவு வகைகள்',
    'preferred dress styles': 'விருப்பமான ஆடை வகைகள்',
    'spoken language': 'பேசும் மொழிகள்',
    'partner\'s age (e.g. 20-25)': 'துணையின் வயது (எ.கா. 20-25)',
    'height preference': 'எதிர்பார்க்கும் உயரம்',
    'weight preference': 'எதிர்பார்க்கும் எடை',
    'education preference': 'எதிர்பார்க்கும் கல்வி',
    'country preference': 'எதிர்பார்க்கும் நாடு',
    'occupation preference': 'எதிர்பார்க்கும் தொழில்',
    'partner income value': 'எதிர்பார்க்கும் வருமானம்',
    'kootam preference': 'எதிர்பார்க்கும் கூட்டம்',
    'kulam preference': 'எதிர்பார்க்கும் குலம்',
    'horoscope match required': 'ஜாதக பொருத்தம் அவசியமா?',
    'doesn\'t matter': 'பொருட்டல்ல',
    'star preference': 'எதிர்பார்க்கும் நட்சத்திரம்',
    'rasi preference': 'எதிர்பார்க்கும் ராசி',
    'marital status preference': 'எதிர்பார்க்கும் திருமண நிலை',
    'dosham preference': 'எதிர்பார்க்கும் தோஷம்',
    'describe your expectations': 'உங்கள் எதிர்பார்ப்புகளை விவரிக்கவும்',
    'preferred age': 'எதிர்பார்க்கும் வயது',
    'preferred height': 'எதிர்பார்க்கும் உயரம்',
    'preferred education': 'எதிர்பார்க்கும் கல்வி',
    'preferred occupation': 'எதிர்பார்க்கும் தொழில்',
    'preferred location': 'எதிர்பார்க்கும் இடம்',
    'back': 'முந்தைய படி',
    'next': 'அடுத்த படி',
    'submit': 'சமர்ப்பிக்கவும்',

    // Placeholders & Validation Error Messages
    'enter your full name': 'உங்கள் முழு பெயரை உள்ளிடவும்',
    'select your date of birth': 'பிறந்த தேதியை தேர்ந்தெடுக்கவும்',
    'select date of birth': 'பிறந்த தேதியை தேர்ந்தெடுக்கவும்',
    'enter 10-digit mobile number': '10 இலக்க கைபேசி எண்',
    'enter your phone number': 'தொலைபேசி எண்ணை உள்ளிடவும்',
    'enter your email address': 'உங்கள் மின்னஞ்சலை உள்ளிடவும்',
    'create a password': 'கடவுச்சொல்லை உருவாக்கவும்',
    'done': 'முடிந்தது',
    'divorced': 'விவாகரத்தானவர்',
    'widowed': 'விதவை / விதவை ஆண்',
    'awaiting divorce': 'விவாகரத்து எதிர்நோக்குபவர்',
    'profile created by *': 'சுயவிவரம் உருவாக்குபவர் *',
    'self': 'சுயமாக',
    'parents': 'பெற்றோர்கள்',
    'sibling': 'சகோதரர் / சகோதரி',
    'relative': 'உறவினர்',
    'friend': 'நண்பர்',
    'save & continue': 'சேமித்து தொடரவும்',
    'register & continue': 'பதிவு செய்து தொடரவும்',
    'already have an account? ': 'ஏற்கனவே கணக்கு உள்ளதா? ',
    'login': 'உள்நுழைய',
    'please select height': 'தயவுசெய்து உயரத்தை தேர்ந்தெடுக்கவும்',
    'please select weight': 'தயவுசெய்து எடையை தேர்ந்தெடுக்கவும்',
    'please select blood group': 'தயவுசெய்து இரத்த வகையை தேர்ந்தெடுக்கவும்',
    'please select body type': 'தயவுசெய்து உடல் அமைப்பை தேர்ந்தெடுக்கவும்',
    'please select an option': 'தயவுசெய்து ஒரு விருப்பத்தை தேர்ந்தெடுக்கவும்',
    'please select skin tone': 'தயவுசெய்து தோல் நிறத்தை தேர்ந்தெடுக்கவும்',
    'please select diet': 'தயவுசெய்து உணவு முறையை தேர்ந்தெடுக்கவும்',
    'please select physically challenged': 'தயவுசெய்து தேர்வை தேர்ந்தெடுக்கவும்',
    'please enter kootam': 'தயவுசெய்து கூட்டத்தை உள்ளிடவும்',
    'please enter kula theiva temple': 'தயவுசெய்து குலதெய்வ கோயிலை உள்ளிடவும்',
    'please enter time of birth': 'தயவுசெய்து பிறந்த நேரத்தை உள்ளிடவும்',
    'please enter place of birth': 'தயவுசெய்து பிறந்த இடத்தை உள்ளிடவும்',
    'please enter star': 'தயவுசெய்து நட்சத்திரத்தை உள்ளிடவும்',
    'please select padham': 'தயவுசெய்து பாதத்தை தேர்ந்தெடுக்கவும்',
    'please enter rasi': 'தயவுசெய்து ராசியை உள்ளிடவும்',
    'please enter lagnam': 'தயவுசெய்து லக்னத்தை உள்ளிடவும்',
    'please enter your hobbies': 'தயவுசெய்து உங்கள் பொழுதுபோக்குகளை உள்ளிடவும்',
    'please enter your interests': 'தயவுசெய்து உங்கள் ஆர்வங்களை உள்ளிடவும்',
    'please enter favourite music': 'தயவுசெய்து விருப்பமான இசையை உள்ளிடவும்',
    'please enter preferred musics': 'தயவுசெய்து விருப்பமான இசையை உள்ளிடவும்',
    'please enter sport/fitness activities': 'தயவுசெய்து உடற்பயிற்சி விவரங்களை உள்ளிடவும்',
    'please enter favourite cuisine': 'தயவுசெய்து உணவு வகைகளை உள்ளிடவும்',
    'please enter preferred dress styles': 'தயவுசெய்து ஆடை வகைகளை உள்ளிடவும்',
    'please enter spoken languages': 'தயவுசெய்து பேசும் மொழிகளை உள்ளிடவும்',
    'please enter father\'s name': 'தயவுசெய்து தந்தையின் பெயரை உள்ளிடவும்',
    'please enter mother\'s name': 'தயவுசெய்து தாயின் பெயரை உள்ளிடவும்',
    'please enter father\'s occupation': 'தயவுசெய்து தந்தையின் தொழிலை உள்ளிடவும்',
    'please enter mother\'s occupation': 'தயவுசெய்து தாயின் தொழிலை உள்ளிடவும்',
    'please enter number': 'தயவுசெய்து எண்ணிக்கையை உள்ளிடவும்',
    'please select family status': 'தயவுசெய்து குடும்ப நிலையை தேர்ந்தெடுக்கவும்',
    'please enter property details': 'தயவுசெய்து சொத்து விவரங்களை உள்ளிடவும்',
    'please enter monthly income': 'தயவுசெய்து மாத வருமானத்தை உள்ளிடவும்',
    'please enter farming land details': 'தயவுசெய்து விவசாய நில விவரங்களை உள்ளிடவும்',
    'please enter native place': 'தயவுசெய்து சொந்த ஊரை உள்ளிடவும்',
    'please enter education level': 'தயவுசெய்து கல்வி நிலையை உள்ளிடவும்',
    'please enter education': 'தயவுசெய்து கல்வியை உள்ளிடவும்',
    'please enter occupation': 'தயவுசெய்து தொழிலை உள்ளிடவும்',
    'please enter country': 'தயவுசெய்து நாட்டை உள்ளிடவும்',
    'please enter state': 'தயவுசெய்து மாநிலத்தை உள்ளிடவும்',
    'please enter family name': 'தயவுசெய்து குடும்ப பெயரை உள்ளிடவும்',
    'please enter education details': 'தயவுசெய்து கல்வி விவரங்களை உள்ளிடவும்',
    'please enter job details': 'தயவுசெய்து பணி விவரங்களை உள்ளிடவும்',
    'please enter working company': 'தயவுசெய்து நிறுவனத்தை உள்ளிடவும்',
    'please enter city': 'தயவுசெய்து நகரத்தை உள்ளிடவும்',
    'please enter alternate mobile': 'தயவுசெய்து மாற்று கைபேசி எண்ணை உள்ளிடவும்',
    'please enter email': 'தயவுசெய்து மின்னஞ்சலை உள்ளிடவும்',
    'please enter a valid email': 'செல்லுபடியாகும் மின்னஞ்சலை உள்ளிடவும்',
    'please enter refer name': 'தயவுசெய்து பரிந்துரைத்தவர் பெயரை உள்ளிடவும்',
    'please enter refer mobile': 'தயவுசெய்து பரிந்துரைத்தவர் எண்ணை உள்ளிடவும்',
    'please enter address': 'தயவுசெய்து முகவரியை உள்ளிடவும்',
    'please enter postal code': 'தயவுசெய்து அஞ்சல் குறியீட்டை உள்ளிடவும்',
    'please enter age preference': 'தயவுசெய்து வயது விருப்பத்தை உள்ளிடவும்',
    'please enter height preference': 'தயவுசெய்து உயர விருப்பத்தை உள்ளிடவும்',
    'please enter weight preference': 'தயவுசெய்து எடை விருப்பத்தை உள்ளிடவும்',
    'please enter education preference': 'தயவுசெய்து கல்வி விருப்பத்தை உள்ளிடவும்',
    'please enter country preference': 'தயவுசெய்து நாட்டு விருப்பத்தை உள்ளிடவும்',
    'please enter occupation preference': 'தயவுசெய்து தொழில் விருப்பத்தை உள்ளிடவும்',
    'please enter partner income': 'தயவுசெய்து வருமான விருப்பத்தை உள்ளிடவும்',
    'please enter kootam preference': 'தயவுசெய்து கூட்டம் விருப்பத்தை உள்ளிடவும்',
    'please enter kulam preference': 'தயவுசெய்து குல விருப்பத்தை உள்ளிடவும்',
    'please enter star preference': 'தயவுசெய்து நட்சத்திர விருப்பத்தை உள்ளிடவும்',
    'please enter rasi preference': 'தயவுசெய்து ராசி விருப்பத்தை உள்ளிடவும்',
    'please enter marital status preference': 'தயவுசெய்து திருமண நிலை விருப்பத்தை உள்ளிடவும்',
    'please write something about yourself': 'தயவுசெய்து உங்களைப் பற்றி சுருக்கமாக எழுதுங்கள்',
    'please describe your expectations': 'தயவுசெய்து உங்கள் எதிர்பார்ப்புகளை விவரிக்கவும்',

    // Interests Screen & Statuses
    'received': 'பெறப்பட்டவை',
    'sent': 'அனுப்பியவை',
    'decline': 'நிராகரி',
    'declined': 'நிராகரிக்கப்பட்டது',
    'accept': 'ஏற்றுக்கொள்',
    'accepted': 'ஏற்றுக்கொள்ளப்பட்டது',
    'pending': 'நிலுவையில்',
    'delivered': 'அனுப்பப்பட்டது',
    'status': 'நிலை',
    'no requests found': 'கோரிக்கைகள் எதுவும் இல்லை',
    'request declined': 'கோரிக்கை நிராகரிக்கப்பட்டது',
    'request accepted': 'கோரிக்கை ஏற்றுக்கொள்ளப்பட்டது',
    'status: ': 'நிலை: ',

    // Home Page Sections & Buttons
    'men_profiles_section': 'மணமகன்',
    'women_profiles_section': 'மணமகள்',
    'view_all_profiles_button': 'அனைத்து சுயவிவரங்களையும் பார்க்க',
  };
}
