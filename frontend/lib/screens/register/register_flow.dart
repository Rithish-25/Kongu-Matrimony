import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/registration_draft.dart';
import '../../core/assets/mock_data.dart';
import '../../core/localization/app_language.dart';
import '../main_layout.dart';

import '../auth/login_screen.dart';

// Import the 4 consolidated modular pages
import 'page_1_astrology_family.dart';
import 'page_2_education_communication.dart';
import 'page_3_partner_expectations.dart';
import 'page_4_about_physical.dart';

class RegisterFlow extends StatefulWidget {
  final int initialStep;
  final Map<String, String> initialData;
  final bool isEditing;

  const RegisterFlow({
    super.key,
    required this.initialStep,
    required this.initialData,
    this.isEditing = false,
  });

  @override
  State<RegisterFlow> createState() => _RegisterFlowState();
}

class _RegisterFlowState extends State<RegisterFlow> {
  late int _currentStep;
  late Map<String, String> _formData;
  late PageController _pageController;
  final List<GlobalKey<FormState>> _formKeys = List.generate(4, (index) => GlobalKey<FormState>());

  final List<String> _pageTitles = const [
    'Astrological Profile & Family Details',
    'Education, Occupation & Communication',
    'Partner Details & Expectations',
    'About Myself & Physical Details',
  ];

  @override
  void initState() {
    super.initState();
    // Clamp initialStep between 0 and 3
    _currentStep = widget.initialStep.clamp(0, 3);
    _formData = Map<String, String>.from(widget.initialData);
    _pageController = PageController(initialPage: _currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onFieldChanged(String key, String value) async {
    setState(() {
      _formData[key] = value;
    });
    if (widget.isEditing) {
      await RegistrationDraft.saveProfileDetails(_formData);
      if (key == 'name' && value.trim().isNotEmpty) {
        await ProfileDatabase.updateUserProfile(displayName: value.trim());
      }
    } else {
      await RegistrationDraft.saveDraft(_formData, _currentStep);
    }
  }

  Future<void> _saveAsDraft() async {
    if (widget.isEditing) {
      await RegistrationDraft.saveProfileDetails(_formData);
      final registeredName = _formData['name']?.trim();
      if (registeredName != null && registeredName.isNotEmpty) {
        await ProfileDatabase.updateUserProfile(
          displayName: registeredName,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile details saved successfully!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    } else {
      await RegistrationDraft.saveDraft(_formData, _currentStep);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Draft saved successfully! You can resume later.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _submitRegistration() async {
    if (widget.isEditing) {
      await RegistrationDraft.saveProfileDetails(_formData);
      final registeredName = _formData['name']?.trim() ?? 'User';
      await ProfileDatabase.updateUserProfile(
        displayName: registeredName,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.of(context).pop();
      }
    } else {
      await RegistrationDraft.clearDraft();
      await RegistrationDraft.saveProfileDetails(_formData);

      final registeredName = _formData['name']?.trim() ?? 'New Member';
      await ProfileDatabase.updateUserProfile(
        displayName: registeredName,
        plan: 'Free',
        downloadedCount: 0,
      );
      await ProfileDatabase.login();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome to Kongu Matrimony, $registeredName!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainLayout()),
        );
      }
    }
  }

  void _nextStep() async {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (widget.isEditing) {
        await RegistrationDraft.saveProfileDetails(_formData);
      } else {
        await RegistrationDraft.saveDraft(_formData, _currentStep);
      }

      if (_currentStep < 3) {
        setState(() {
          _currentStep++;
        });
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _submitRegistration();
      }
    }
  }

  void _skipAndContinue() async {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _submitRegistration();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (_currentStep + 1) / 4;
    final int progressPercent = ((_currentStep + 1) * 25);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          widget.isEditing ? 'Edit Profile' : 'Profile Registration',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: _currentStep > 0 ? _prevStep : () => Navigator.of(context).pop(),
        ),
        actions: [
          if (!widget.isEditing)
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(
                'Already a member? Login',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.primary,
                ),
              ),
            ),
          TextButton.icon(
            onPressed: _saveAsDraft,
            icon: const Icon(
              Icons.save_outlined,
              size: 18,
              color: AppColors.primary,
            ),
            label: Text(
              AppLanguageController.text('Save Draft'),
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress Card Header (Matching Login Page Style)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x08000000),
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
                        Text(
                          'STEP ${_currentStep + 1} OF 4',
                          style: GoogleFonts.roboto(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          '$progressPercent% (${_currentStep + 1}/4)',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLanguageController.text(_pageTitles[_currentStep]),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Form Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // PAGE 1: Astrological Profile & Family Details
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[0],
                      child: Page1AstrologyFamily(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 0,
                      ),
                    ),
                  ),

                  // PAGE 2: Education, Occupation & Communication Details
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[1],
                      child: Page2EducationCommunication(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 1,
                      ),
                    ),
                  ),

                  // PAGE 3: Partner Details & Expectations (Skippable)
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[2],
                      child: Page3PartnerExpectations(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 2,
                        onSkipExpectation: _skipAndContinue,
                      ),
                    ),
                  ),

                  // PAGE 4: About Myself & Physical Details (Skippable)
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[3],
                      child: Page4AboutPhysical(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 3,
                        onSkipSection: _skipAndContinue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final bool isLastStep = _currentStep == 3;
    final bool hasSkipOptions = _currentStep >= 2;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(color: AppColors.border, width: 1.2),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      AppLanguageController.text('Back'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (hasSkipOptions) ...[
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: _skipAndContinue,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.2),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      AppLanguageController.text(isLastStep ? 'Skip & Finish' : 'Skip Step'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 4,
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1F000000),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    AppLanguageController.text(isLastStep ? 'Submit & Finish' : 'Next Step'),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
