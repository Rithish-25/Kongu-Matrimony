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

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _autoLogin = true;
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingDraft();
  }

  Future<void> _loadExistingDraft() async {
    final details = await RegistrationDraft.loadProfileDetails();
    if (details.isNotEmpty) {
      final nameParts = (details['name'] ?? '').split(' ');
      if (nameParts.isNotEmpty) {
        _firstNameController.text = nameParts.first;
        if (nameParts.length > 1) {
          _lastNameController.text = nameParts.sublist(1).join(' ');
        }
      }
      if (details['mobile'] != null) {
        _phoneController.text = details['mobile']!;
      }
      if (details['email'] != null) {
        _emailController.text = details['email']!;
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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

  void _submitRegisterAndLogin() async {
    if (!_step2FormKey.currentState!.validate()) return;

    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 600));

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final fullName = '$firstName $lastName'.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final profileData = {
      'name': fullName.isNotEmpty ? fullName : 'User',
      'mobile': phone,
      'email': email,
      'password': password,
    };

    await RegistrationDraft.saveProfileDetails(profileData);
    await ProfileDatabase.updateUserProfile(displayName: fullName.isNotEmpty ? fullName : 'User');

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Spacer(flex: 1),
                        // Top Progress Card & Header
                        _buildProgressHeader(),
                        const SizedBox(height: 16),

                        // Form Content Card
                        _currentStep == 1 ? _buildStep1BasicDetails() : _buildStep2LoginAndAccess(),
                        const Spacer(flex: 3),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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

            // First Name & Last Name Side by Side
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First Name',
                        style: GoogleFonts.roboto(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _firstNameController,
                        style: GoogleFonts.roboto(fontSize: 13.5, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'First name',
                          hintStyle: GoogleFonts.roboto(fontSize: 13, color: const Color(0xFF94A3B8)),
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
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'First name required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Name',
                        style: GoogleFonts.roboto(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _lastNameController,
                        style: GoogleFonts.roboto(fontSize: 13.5, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Last name',
                          hintStyle: GoogleFonts.roboto(fontSize: 13, color: const Color(0xFF94A3B8)),
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
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Last name required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Phone Number Field
            Text(
              'Phone Number',
              style: GoogleFonts.roboto(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textPrimary),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                hintText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone_android_rounded, size: 20, color: AppColors.primary),
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
                if (val == null || val.trim().isEmpty) {
                  return 'Phone number required';
                }
                if (val.trim().length != 10) {
                  return 'Must be 10 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Continue Primary Sticky Action Button
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
            Text(
              'Setup Your Account',
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // Choose Email Address
            Text(
              'Choose Email Address',
              style: GoogleFonts.roboto(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Enter email address',
                prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.primary),
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
                if (val == null || val.trim().isEmpty) {
                  return 'Email address required';
                }
                if (!val.contains('@') || !val.contains('.')) {
                  return 'Enter valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Create Password
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

            // Auto-login Option Checkbox
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
}
