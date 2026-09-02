import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';

class Page1Personal extends StatefulWidget {
  final Map<String, String> formData;
  final Function(String, String) onChanged;
  final int currentStep;
  final VoidCallback onNext;

  final bool isEditing;

  const Page1Personal({
    super.key,
    required this.formData,
    required this.onChanged,
    required this.currentStep,
    required this.onNext,
    this.isEditing = false,
  });

  @override
  State<Page1Personal> createState() => _Page1PersonalState();
}

class _Page1PersonalState extends State<Page1Personal> {
  late TextEditingController _dobController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Pre-populate dropdown defaults if not already present
    if (widget.formData['gender'] == null || widget.formData['gender']!.trim().isEmpty) {
      widget.formData['gender'] = 'Male';
    }
    if (widget.formData['maritalStatus'] == null || widget.formData['maritalStatus']!.trim().isEmpty) {
      widget.formData['maritalStatus'] = 'Single';
    }
    if (widget.formData['profileCreatedBy'] == null || widget.formData['profileCreatedBy']!.trim().isEmpty) {
      widget.formData['profileCreatedBy'] = 'Self';
    }
    _dobController = TextEditingController(text: widget.formData['dob'] ?? '');
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    // Parse existing date or fallback to default
    DateTime initialDate = DateTime(1996, 8, 28);
    if (_dobController.text.trim().isNotEmpty) {
      try {
        final text = _dobController.text.trim();
        final parts = text.contains('-') ? text.split('-') : text.split('/');
        if (parts.length == 3) {
          if (parts[0].length == 4) {
            initialDate = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
          } else {
            initialDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
          }
        }
      } catch (_) {}
    }

    final maxDate = DateTime(
      DateTime.now().year - 18,
      DateTime.now().month,
      DateTime.now().day,
    );
    final minDate = DateTime(1950, 1, 1);

    if (initialDate.isAfter(maxDate)) {
      initialDate = maxDate;
    } else if (initialDate.isBefore(minDate)) {
      initialDate = minDate;
    }

    DateTime tempSelectedDate = initialDate;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Container(
            height: 330,
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top drag indicator
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 10, bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header with title and Done button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Date of Birth',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final dateStr =
                              "${tempSelectedDate.day.toString().padLeft(2, '0')}-${tempSelectedDate.month.toString().padLeft(2, '0')}-${tempSelectedDate.year}";
                          setState(() {
                            widget.formData['dob'] = dateStr;
                          });
                          _dobController.text = dateStr;
                          widget.onChanged('dob', dateStr);
                          Navigator.of(sheetContext).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Done',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Thin divider
                const Divider(height: 1, color: Color(0xFFF1F5F9), thickness: 1),
                const SizedBox(height: 6),
                // Cupertino Wheel Date Picker
                Expanded(
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.light,
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                          fontSize: 21,
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      dateOrder: DatePickerDateOrder.mdy,
                      initialDateTime: tempSelectedDate,
                      minimumDate: minDate,
                      maximumDate: maxDate,
                      onDateTimeChanged: (DateTime newDate) {
                        tempSelectedDate = newDate;
                      },
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

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.textLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.error,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE8E5E0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Create Your Account',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Find your perfect match from Erode and surrounding areas',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        // Form Fields Card
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          margin: const EdgeInsets.only(bottom: AppConstants.spacingL),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFECE5DD), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0A7A102A),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Full Name
              _buildFieldLabel('Full Name *'),
              TextFormField(
                initialValue: widget.formData['name'] ?? '',
                onChanged: (val) => widget.onChanged('name', val),
                textCapitalization: TextCapitalization.words,
                decoration: _buildInputDecoration(hintText: 'Enter your full name'),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 2. Gender
              _buildFieldLabel('Gender *'),
              DropdownButtonFormField<String>(
                initialValue: widget.formData['gender'],
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => widget.formData['gender'] = val);
                    widget.onChanged('gender', val);
                  }
                },
                decoration: _buildInputDecoration(hintText: ''),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 24),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please select your gender';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 3. Marital Status
              _buildFieldLabel('Marital Status *'),
              DropdownButtonFormField<String>(
                initialValue: widget.formData['maritalStatus'],
                items: const [
                  DropdownMenuItem(value: 'Single', child: Text('Single')),
                  DropdownMenuItem(value: 'Divorced', child: Text('Divorced')),
                  DropdownMenuItem(value: 'Widowed', child: Text('Widowed')),
                  DropdownMenuItem(value: 'Awaiting Divorce', child: Text('Awaiting Divorce')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => widget.formData['maritalStatus'] = val);
                    widget.onChanged('maritalStatus', val);
                  }
                },
                decoration: _buildInputDecoration(hintText: ''),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 24),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please select marital status';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 4. Date of Birth
              _buildFieldLabel('Date of Birth *'),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    enableInteractiveSelection: false,
                    showCursor: false,
                    canRequestFocus: false,
                    decoration: _buildInputDecoration(
                      hintText: 'Select your Date of Birth',
                      suffixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.textLight, size: 20),
                    ),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please select your Date of Birth';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 5. Phone Number
              _buildFieldLabel('Phone Number *'),
              TextFormField(
                initialValue: widget.formData['mobile'] ?? '',
                onChanged: (val) => widget.onChanged('mobile', val),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.startsWith('0')) {
                      return oldValue;
                    }
                    return newValue;
                  }),
                ],
                decoration: _buildInputDecoration(hintText: 'Enter your phone number'),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter phone number';
                  }
                  final trimmed = val.trim();
                  if (trimmed.startsWith('0')) {
                    return 'Phone number cannot start with 0';
                  }
                  if (trimmed.length != 10) {
                    return 'Phone number must be exactly 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 6. Profile Created By
              _buildFieldLabel('Profile Created By *'),
              DropdownButtonFormField<String>(
                initialValue: widget.formData['profileCreatedBy'],
                items: const [
                  DropdownMenuItem(value: 'Self', child: Text('Self')),
                  DropdownMenuItem(value: 'Parents', child: Text('Parents')),
                  DropdownMenuItem(value: 'Sibling', child: Text('Sibling')),
                  DropdownMenuItem(value: 'Relative', child: Text('Relative')),
                  DropdownMenuItem(value: 'Friend', child: Text('Friend')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => widget.formData['profileCreatedBy'] = val);
                    widget.onChanged('profileCreatedBy', val);
                  }
                },
                decoration: _buildInputDecoration(hintText: ''),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 24),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please select who created the profile';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 7. Email Address
              _buildFieldLabel('Email Address *'),
              TextFormField(
                initialValue: widget.formData['email'] ?? '',
                onChanged: (val) => widget.onChanged('email', val),
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration(hintText: 'Enter your email address'),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 8. Password
              _buildFieldLabel('Password *'),
              TextFormField(
                initialValue: widget.formData['password'] ?? '',
                onChanged: (val) => widget.onChanged('password', val),
                obscureText: _obscurePassword,
                decoration: _buildInputDecoration(
                  hintText: 'Create a password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textLight,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (val.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),

        // Action Buttons
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0x337A102A),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: widget.onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              widget.isEditing ? 'Save & Continue' : 'Register & Continue',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        if (!widget.isEditing) ...[
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Login',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}
