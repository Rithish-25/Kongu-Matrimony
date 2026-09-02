import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/registration_draft.dart';
import '../../core/assets/mock_data.dart';
import '../main_layout.dart';

// Import all 10 modular pages
import 'page_1_personal.dart';
import 'page_2_physical.dart';
import 'page_3_astrology.dart';
import 'page_4_lifestyle.dart';
import 'page_5_family.dart';
import 'page_6_education_occupation.dart';
import 'page_7_communication.dart';
import 'page_8_partner.dart';
import 'page_9_about.dart';
import 'page_10_expectation.dart';

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
  final List<GlobalKey<FormState>> _formKeys = List.generate(10, (index) => GlobalKey<FormState>());

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
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
      // Save completed profile details
      await RegistrationDraft.saveProfileDetails(_formData);

      // Update the user display name in the database/notifiers
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
      // Clear draft on successful completion
      await RegistrationDraft.clearDraft();

      // Also save to profile details so edit profile has them
      await RegistrationDraft.saveProfileDetails(_formData);

      // Log the user in with the registered name
      final registeredName = _formData['name']?.trim() ?? 'New User';
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
        final registeredName = _formData['name']?.trim();
        if (registeredName != null && registeredName.isNotEmpty) {
          await ProfileDatabase.updateUserProfile(displayName: registeredName);
        }
      } else {
        await RegistrationDraft.saveDraft(_formData, _currentStep);
      }

      if (!widget.isEditing && _currentStep == 0) {
        _submitRegistration();
      } else if (_currentStep < 9) {
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
    final progress = (_currentStep + 1) / 10;

    return Scaffold(
      appBar: (_currentStep == 0 && !widget.isEditing)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.appBarPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppConstants.softShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'KONGU',
                      style: GoogleFonts.cinzel(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.appBarPrimary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      ' MATRIMONY',
                      style: GoogleFonts.cinzel(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.appBarSecondaryDark,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            )
          : AppBar(
              title: Text(
                widget.isEditing ? 'Edit Profile (${_currentStep + 1}/10)' : 'Step ${_currentStep + 1} of 10',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _currentStep > 0 ? _prevStep : () => Navigator.of(context).pop(),
              ),
              actions: [
                TextButton.icon(
                  onPressed: _saveAsDraft,
                  icon: const Icon(
                    Icons.save_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    'Save Draft',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.border,
                  color: AppColors.primary,
                ),
              ),
            ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[0],
                      child: Page1Personal(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 0,
                        isEditing: widget.isEditing,
                        onNext: _nextStep,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[1],
                      child: Page2Physical(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 1,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[2],
                      child: Page3Astrology(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 2,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[3],
                      child: Page4Lifestyle(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 3,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[4],
                      child: Page5Family(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 4,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[5],
                      child: Page6EducationOccupation(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 5,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[6],
                      child: Page7Communication(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 6,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[7],
                      child: Page8Partner(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 7,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[8],
                      child: Page9About(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 8,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Form(
                      key: _formKeys[9],
                      child: Page10Expectation(
                        formData: _formData,
                        onChanged: _onFieldChanged,
                        currentStep: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_currentStep > 0) _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final isLastStep = _currentStep == 9;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Back',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
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
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  isLastStep ? 'Submit' : 'Next',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
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
