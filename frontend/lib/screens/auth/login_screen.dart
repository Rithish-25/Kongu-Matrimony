import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/assets/mock_data.dart';
import '../../core/assets/registration_draft.dart';
import '../main_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _autoLogin = true;
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
      if (details['gender'] != null) _gender = details['gender'];
      if (details['dob'] != null) _dobController.text = details['dob']!;
      if (details['kootam'] != null) _kootam = details['kootam'];
      if (details['rasi'] != null) _rasi = details['rasi'];
      if (details['star'] != null) _star = details['star'];
      if (details['mobile'] != null) _phoneController.text = details['mobile']!;
      if (details['email'] != null) _emailController.text = details['email']!;
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
                  // Drag Handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Modal Header
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
                  // Scroll Pickers Container
                  Expanded(
                    child: Stack(
                      children: [
                        // Center Highlight Box
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
                        // 3 Columns: Day, Month, Year
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              // Day Column
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
                              // Month Column
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
                              // Year Column
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

    await Future.delayed(const Duration(milliseconds: 600));

    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final profileData = {
      'name': fullName.isNotEmpty ? fullName : 'User',
      'profileCreatedBy': _profileCreatedBy ?? 'Self',
      'gender': _gender ?? 'Male',
      'dob': _dobController.text.trim(),
      'kootam': _kootam ?? '',
      'rasi': _rasi ?? '',
      'star': _star ?? '',
      'mobile': phone,
      'email': email,
      'password': password,
    };

    await RegistrationDraft.saveProfileDetails(profileData);
    await ProfileDatabase.updateUserProfile(
      displayName: fullName.isNotEmpty ? fullName : 'User',
      gender: _gender,
    );

    if (_autoLogin) {
      await ProfileDatabase.login();
    }

    if (mounted) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_autoLogin ? 'Account created and logged in successfully!' : 'Account setup completed!'),
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
              // Top Progress Card & Header
              _buildProgressHeader(),
              const SizedBox(height: 16),

              // Form Content Card
              _currentStep == 1 ? _buildStep1BasicDetails() : _buildStep2LoginAndAccess(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- TOP PROGRESS HEADER ---
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
                'PROGRESS BAR $progressText',
                style: GoogleFonts.roboto(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
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

            // Row 1: Profile For * & Full Name *
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Profile For *',
                    hint: '* Select Profile',
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

            // Row 2: Gender * & DOB
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Gender *',
                    hint: 'Select Gender',
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
                        hint: 'DD/MM/YYYY',
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

            // Row 3: Kulam *
            _buildDropdown(
              label: 'Kulam *',
              hint: '* Select Kulam',
              value: _kootam,
              items: kootamOptions,
              onChanged: (val) => setState(() => _kootam = val),
              validator: (val) => val == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Row 4: Rasi & Star
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
            const SizedBox(height: 32),

            // Continue Primary Action Button
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

  // --- STEP 2: SETUP YOUR ACCOUNT ---
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
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Phone Number
            _buildTextField(
              label: 'Phone Number',
              hint: 'Phone Number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.smartphone_outlined, size: 20, color: AppColors.primary),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Phone number required';
                }
                if (val.trim().length != 10) {
                  return 'Must be 10 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email Address
            _buildTextField(
              label: 'Email Address',
              hint: 'Enter email address',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.primary),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Email address required';
                }
                if (!val.contains('@') || !val.contains('.')) {
                  return 'Enter valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password
            Text(
              'Create Password',
              style: GoogleFonts.roboto(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Create password',
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Password required';
                }
                if (val.length < 4) {
                  return 'Password must be at least 4 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Auto-login Checkbox
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _autoLogin,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _autoLogin = val ?? true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Log me in immediately after registration',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Primary CTA: REGISTER & LOGIN
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
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'REGISTER & LOGIN',
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),

            // Secondary CTA: BACK
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: _goToStep1,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'BACK',
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

  // --- HELPER WIDGET: TEXT FIELD WITH TOP LABEL ---
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: GoogleFonts.roboto(fontSize: 12.5, color: AppColors.textPrimary),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: GoogleFonts.roboto(fontSize: 12.5, color: const Color(0xFF94A3B8)),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  // --- HELPER WIDGET: DROPDOWN FIELD WITH TOP LABEL ---
  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    final selected = items.contains(value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: selected,
          isExpanded: true,
          onChanged: onChanged,
          validator: validator,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 22),
          style: GoogleFonts.roboto(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          hint: Text(
            hint,
            style: GoogleFonts.roboto(
              fontSize: 12.5,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF94A3B8),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
          selectedItemBuilder: (context) {
            return items.map((item) {
              return Text(
                item,
                style: GoogleFonts.roboto(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              );
            }).toList();
          },
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.roboto(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
