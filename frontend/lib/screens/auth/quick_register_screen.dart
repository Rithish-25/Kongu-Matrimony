// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/assets/mock_data.dart';
import '../../core/assets/registration_draft.dart';
import '../../widgets/app_profile_image.dart';
import '../main_layout.dart';
import 'login_screen.dart';

class QuickRegisterScreen extends StatefulWidget {
  const QuickRegisterScreen({super.key});

  @override
  State<QuickRegisterScreen> createState() => _QuickRegisterScreenState();
}

class _QuickRegisterScreenState extends State<QuickRegisterScreen> {
  int _currentStep = 1; // 1: BASIC DETAILS, 2: LOGIN & ACCESS

  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();

  String? _profileCreatedBy;
  final TextEditingController _fullNameController = TextEditingController();
  String? _gender = 'Male';
  final TextEditingController _dobController = TextEditingController();
  String? _kootam;
  String? _rasi;
  String? _star;

  // 1st Registration Page Upload State
  String? _communityCertificateName;

  String? _horoscopeFileName;

  // 2nd Registration Page Upload State (Portrait 4:5 Profile Photo)
  String? _profilePhotoPath;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;

  static const List<String> profileForOptions = [
    'Self',
    'Parents',
    'Sibling',
    'Relative',
    'Friend',
  ];

  static const List<String> genderOptions = [
    'Male',
    'Female',
  ];

  static const List<String> kootamOptions = [
    'Sempoothan',
    'Kannandhai',
    'Pavalan',
    'Pullan',
    'Porulanthai',
    'Othalan',
    'Aadai',
    'Aavanai',
    'Aandhai',
    'Adhira',
    'Aayiravan',
    'Eesan',
    'Ennai',
    'Kadai',
    'Kari',
    'Kilai',
    'Kollan',
    'Korai',
    'Kovan',
    'Moolan',
    'Mutthan',
    'Neelan',
    'Pannai',
    'Paandian',
    'Periandi',
    'Pillan',
    'Poosan',
    'Sengaani',
    'Sengunthar',
    'Servai',
    'Thazhan',
    'Thoratan',
    'Vandikan',
    'Velli',
    'Vilayan',
    'Other',
  ];

  static const List<String> starOptions = [
    'Ashwini',
    'Bharani',
    'Krittika',
    'Rohini',
    'Mrigashirsha',
    'Ardra',
    'Punarvasu',
    'Pushya',
    'Ashlesha',
    'Magha',
    'Purva Phalguni',
    'Uttara Phalguni',
    'Hasta',
    'Chitra',
    'Swati',
    'Vishakha',
    'Anuradha',
    'Jyeshtha',
    'Moola',
    'Purva Ashadha',
    'Uttara Ashadha',
    'Shravana',
    'Dhanishta',
    'Shatabhisha',
    'Purva Bhadrapada',
    'Uttara Bhadrapada',
    'Revati',
  ];

  static const List<String> rasiOptions = [
    'Mesham (Aries)',
    'Rishabam (Taurus)',
    'Mithunam (Gemini)',
    'Kadagam (Cancer)',
    'Simmam (Leo)',
    'Kanni (Virgo)',
    'Thulaam (Libra)',
    'Vrichigam (Scorpio)',
    'Dhanusu (Sagittarius)',
    'Magaram (Capricorn)',
    'Kumbam (Aquarius)',
    'Meenam (Pisces)',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingDraft();
  }

  Future<void> _loadExistingDraft() async {
    final details = await RegistrationDraft.loadProfileDetails();
    if (details.isNotEmpty) {
      if (details['name'] != null) _fullNameController.text = details['name']!;
      if (details['profileCreatedBy'] != null) _profileCreatedBy = details['profileCreatedBy'];
      if (details['gender'] != null) {
        final g = details['gender']!;
        if (g.toLowerCase().contains('female')) {
          _gender = 'Female';
        } else {
          _gender = 'Male';
        }
      }
      if (details['dob'] != null) _dobController.text = details['dob']!;
      if (details['kootam'] != null) _kootam = details['kootam'];
      if (details['rasi'] != null) _rasi = details['rasi'];
      if (details['star'] != null) _star = details['star'];
      if (details['mobile'] != null) _phoneController.text = details['mobile']!;
      if (details['email'] != null) _emailController.text = details['email']!;
      if (details['communityCertificate'] != null) _communityCertificateName = details['communityCertificate'];
      if (details['horoscopeFile'] != null) _horoscopeFileName = details['horoscopeFile'];
      if (details['profilePhoto'] != null) _profilePhotoPath = details['profilePhoto'];
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToStep2() {
    if (_step1FormKey.currentState!.validate()) {
      setState(() {
        _currentStep = 2;
      });
    }
  }

  void _goToStep1() {
    setState(() {
      _currentStep = 1;
    });
  }

  // --- DEVICE FILE PICKERS ---
  void _pickProfilePhotoFromDevice() {
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((e) {
            setState(() {
              _profilePhotoPath = reader.result as String;
            });
          });
        }
      });
    }
  }

  void _pickCertificateFromDevice({String accept = '.pdf,image/*,.jpg,.jpeg,.png'}) {
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = accept;
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          setState(() {
            _communityCertificateName = file.name;
          });
        }
      });
    }
  }

  void _pickHoroscopeFromDevice({String accept = '.pdf,image/*,.jpg,.jpeg,.png'}) {
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = accept;
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          setState(() {
            _horoscopeFileName = file.name;
          });
        }
      });
    }
  }

  // --- 1st Page Upload Pickers (Device PDF & Photo Uploads Only) ---
  void _showCertificatePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Community Certificate',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upload your own PDF document or photo image from device:',
                  style: GoogleFonts.roboto(fontSize: 12.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _pickCertificateFromDevice();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.file_upload_outlined, size: 20),
                    label: Text(
                      'Choose File from Device / Gallery',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHoroscopePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Horoscope Document',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upload your own PDF document or horoscope photo from device:',
                  style: GoogleFonts.roboto(fontSize: 12.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _pickHoroscopeFromDevice();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.file_upload_outlined, size: 20),
                    label: Text(
                      'Choose File from Device / Gallery',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- 2nd Page Upload Profile Photo Picker (Device Upload Only) ---
  void _showProfilePhotoPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Portrait Profile Photo (4:5 Ratio)',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Upload your own image from your device gallery:',
                  style: GoogleFonts.roboto(fontSize: 12.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),

                // Button: Choose Photo from Device / Gallery
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _pickProfilePhotoFromDevice();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.photo_library_rounded, size: 20),
                    label: Text(
                      'Choose Photo from Device / Gallery',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDob(BuildContext context) async {
    int selectedDay = 28;
    int selectedMonth = 8;
    int selectedYear = 1996;

    if (_dobController.text.isNotEmpty) {
      final parts = _dobController.text.split('/');
      if (parts.length == 3) {
        selectedDay = int.tryParse(parts[0]) ?? 28;
        selectedMonth = int.tryParse(parts[1]) ?? 8;
        selectedYear = int.tryParse(parts[2]) ?? 1996;
      }
    }

    final days = List.generate(31, (index) => index + 1);
    final months = List.generate(12, (index) => index + 1);
    final currentYear = DateTime.now().year;
    final years = List.generate(currentYear - 1950 + 1, (index) => 1950 + index);

    final dayController = FixedExtentScrollController(initialItem: (selectedDay - 1).clamp(0, 30));
    final monthController = FixedExtentScrollController(initialItem: (selectedMonth - 1).clamp(0, 11));
    final yearIndex = years.indexOf(selectedYear);
    final yearController = FixedExtentScrollController(initialItem: yearIndex >= 0 ? yearIndex : (years.length - 25));

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 340,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Date of Birth',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final d = days[dayController.selectedItem].toString().padLeft(2, '0');
                            final m = months[monthController.selectedItem].toString().padLeft(2, '0');
                            final y = years[yearController.selectedItem].toString();
                            setState(() {
                              _dobController.text = '$d/$m/$y';
                            });
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          ),
                          child: Text(
                            'Done',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 44,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListWheelScrollView.useDelegate(
                                  controller: dayController,
                                  itemExtent: 44,
                                  perspective: 0.003,
                                  diameterRatio: 1.5,
                                  physics: const FixedExtentScrollPhysics(),
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    childCount: days.length,
                                    builder: (context, index) {
                                      final dayVal = days[index].toString().padLeft(2, '0');
                                      return Center(
                                        child: Text(
                                          dayVal,
                                          style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ListWheelScrollView.useDelegate(
                                  controller: monthController,
                                  itemExtent: 44,
                                  perspective: 0.003,
                                  diameterRatio: 1.5,
                                  physics: const FixedExtentScrollPhysics(),
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    childCount: months.length,
                                    builder: (context, index) {
                                      final monthVal = months[index].toString().padLeft(2, '0');
                                      return Center(
                                        child: Text(
                                          monthVal,
                                          style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ListWheelScrollView.useDelegate(
                                  controller: yearController,
                                  itemExtent: 44,
                                  perspective: 0.003,
                                  diameterRatio: 1.5,
                                  physics: const FixedExtentScrollPhysics(),
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    childCount: years.length,
                                    builder: (context, index) {
                                      final yearVal = years[index].toString();
                                      return Center(
                                        child: Text(
                                          yearVal,
                                          style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _submitRegisterAndLogin() async {
    if (!_step2FormKey.currentState!.validate()) return;

    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final String selectedGenderClean = (_gender != null && _gender!.contains('Female')) ? 'Female' : 'Male';

    final profileData = {
      'name': fullName.isNotEmpty ? fullName : 'User',
      'profileCreatedBy': _profileCreatedBy ?? 'Self',
      'gender': selectedGenderClean,
      'dob': _dobController.text.trim(),
      'kootam': _kootam ?? '',
      'rasi': _rasi ?? '',
      'star': _star ?? '',
      'mobile': phone,
      'email': email,
      'password': password,
      if (_communityCertificateName != null) 'communityCertificate': _communityCertificateName!,
      if (_horoscopeFileName != null) 'horoscopeFile': _horoscopeFileName!,
      if (_profilePhotoPath != null) 'profilePhoto': _profilePhotoPath!,
    };

    await RegistrationDraft.saveProfileDetails(profileData);

    if (_profilePhotoPath != null && _profilePhotoPath!.isNotEmpty) {
      await ProfileDatabase.updateUserProfile(
        displayName: fullName.isNotEmpty ? fullName : 'User',
        imageUrl: _profilePhotoPath,
        gender: selectedGenderClean,
      );
    } else {
      await ProfileDatabase.updateUserProfile(
        displayName: fullName.isNotEmpty ? fullName : 'User',
        gender: selectedGenderClean,
      );
    }

    await ProfileDatabase.login();

    if (mounted) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created and logged in successfully!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainLayout()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              _buildProgressHeader(),
              const SizedBox(height: 16),
              _currentStep == 1 ? _buildStep1BasicDetails() : _buildStep2LoginAndAccess(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    final double progressPercent = _currentStep == 1 ? 0.5 : 1.0;
    final String progressText = _currentStep == 1 ? '50% (1/2)' : '100% (2/2)';
    final String stepTitle = _currentStep == 1 ? 'STEP 1: BASIC DETAILS' : 'STEP 2: LOGIN & ACCESS';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stepTitle,
                  style: GoogleFonts.roboto(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                progressText,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressPercent,
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (_currentStep == 2) {
                    _goToStep1();
                  } else {
                    Navigator.of(context).maybePop();
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'BACK',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(
                  'Already a member? Login',
                  style: GoogleFonts.roboto(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- STEP 1: BASIC DETAILS ---
  Widget _buildStep1BasicDetails() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _step1FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Basic Details',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Profile For * & Full Name *
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Profile For *',
                    hint: 'Select',
                    value: _profileCreatedBy,
                    items: profileForOptions,
                    onChanged: (val) => setState(() => _profileCreatedBy = val),
                    validator: (val) => val == null ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    label: 'Full Name *',
                    hint: 'Full Name',
                    controller: _fullNameController,
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Gender * & DOB
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Gender *',
                    hint: 'Select',
                    value: _gender,
                    items: genderOptions,
                    onChanged: (val) => setState(() => _gender = val),
                    validator: (val) => val == null ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDob(context),
                    behavior: HitTestBehavior.opaque,
                    child: AbsorbPointer(
                      child: _buildTextField(
                        label: 'DOB',
                        hint: 'mm/dd/yyyy',
                        controller: _dobController,
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF64748B)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Kulam *
            _buildDropdown(
              label: 'Kulam *',
              hint: 'Select Kulam',
              value: _kootam,
              items: kootamOptions,
              onChanged: (val) => setState(() => _kootam = val),
              validator: (val) => val == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Rasi & Star
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Rasi',
                    hint: 'Select Rasi',
                    value: _rasi,
                    items: rasiOptions,
                    onChanged: (val) => setState(() => _rasi = val),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDropdown(
                    label: 'Star',
                    hint: 'Select Star',
                    value: _star,
                    items: starOptions,
                    onChanged: (val) => setState(() => _star = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 1ST REGISTRATION PAGE UPLOADS ---
            Text(
              'Document Uploads (Optional)',
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // 1. Upload Community Certificate
            _buildUploadCard(
              title: 'Upload Community Certificate',
              subtitle: 'Community proof document (Optional)',
              icon: Icons.card_membership_rounded,
              fileName: _communityCertificateName,
              onUpload: _showCertificatePicker,
              onRemove: () {
                setState(() {
                  _communityCertificateName = null;
                });
              },
            ),
            const SizedBox(height: 12),

            // 2. Upload Horoscope
            _buildUploadCard(
              title: 'Upload Horoscope',
              subtitle: 'Horoscope chart document (Optional)',
              icon: Icons.auto_awesome_rounded,
              fileName: _horoscopeFileName,
              onUpload: _showHoroscopePicker,
              onRemove: () {
                setState(() {
                  _horoscopeFileName = null;
                });
              },
            ),
            const SizedBox(height: 32),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _goToStep2,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'CONTINUE',
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- STEP 2: SETUP YOUR ACCOUNT & PORTRAIT PROFILE PHOTO ---
  Widget _buildStep2LoginAndAccess() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _step2FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Setup Your Account',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 2ND REGISTRATION PAGE: UPLOAD PROFILE PHOTO (PORTRAIT 4:5 RATIO) ---
            Text(
              'Upload Profile Photo (Optional)',
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Portrait aspect ratio: 4:5',
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),

            Center(
              child: _buildProfilePhotoBox(),
            ),
            const SizedBox(height: 24),

            _buildTextField(
              label: 'Phone Number *',
              hint: 'Phone Number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Email Address *',
              hint: 'Email Address',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Password *',
              hint: 'Password',
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 18,
                  color: const Color(0xFF64748B),
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _submitRegisterAndLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text(
                        'CREATE ACCOUNT & LOGIN',
                        style: GoogleFonts.roboto(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- PORTRAIT PHOTO UPLOAD BOX (4:5 RATIO) ---
  Widget _buildProfilePhotoBox() {
    return Column(
      children: [
        Container(
          width: 160,
          height: 200, // 4:5 aspect ratio (160 x 200)
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _profilePhotoPath != null ? AppColors.primary : const Color(0xFFCBD5E1),
              width: _profilePhotoPath != null ? 2.0 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: _profilePhotoPath != null && _profilePhotoPath!.isNotEmpty
                  ? AppProfileImage(
                      imageUrl: _profilePhotoPath!,
                      fit: BoxFit.cover,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Portrait Photo (4:5)',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _showProfilePhotoPicker,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          icon: const Icon(Icons.upload_file_rounded, size: 16),
          label: Text(
            _profilePhotoPath != null ? 'Change Photo' : 'Upload Photo',
            style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // --- DOCUMENT UPLOAD CARD (1ST PAGE) ---
  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String? fileName,
    required VoidCallback onUpload,
    required VoidCallback onRemove,
  }) {
    final bool hasFile = fileName != null && fileName.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasFile ? AppColors.success : const Color(0xFFCBD5E1),
          width: hasFile ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasFile ? AppColors.successSoft : AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasFile ? Icons.check_circle_rounded : icon,
                  color: hasFile ? AppColors.success : AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasFile ? 'Uploaded: $fileName' : subtitle,
                      style: GoogleFonts.roboto(
                        fontSize: 11.5,
                        color: hasFile ? AppColors.success : AppColors.textSecondary,
                        fontWeight: hasFile ? FontWeight.bold : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (hasFile)
                TextButton.icon(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.error),
                  label: Text(
                    'Remove',
                    style: GoogleFonts.roboto(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.bold),
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: onUpload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(Icons.upload_file_rounded, size: 16),
                  label: Text('Upload', style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: 1,
          style: GoogleFonts.roboto(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: GoogleFonts.roboto(
              color: const Color(0xFF94A3B8),
              fontSize: 13,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: items.contains(value) ? value : null,
          isExpanded: true,
          onChanged: onChanged,
          validator: validator,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 22),
          style: GoogleFonts.roboto(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          selectedItemBuilder: (context) {
            return items.map((item) {
              return Text(
                item,
                style: GoogleFonts.roboto(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              );
            }).toList();
          },
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: GoogleFonts.roboto(
              color: const Color(0xFF94A3B8),
              fontSize: 13,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.roboto(
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
