// lib/features/auth/presentation/screens/registration_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Mock data for dropdowns
  final List<String> _categories = [
    'Restaurant',
    'Grocery',
    'Electronics',
    'Fashion',
    'Pharmacy',
  ];
  final List<String> _cities = [
    'Surat',
    'Mumbai',
    'Ahmedabad',
    'Delhi',
    'Bangalore',
  ];
  final List<String> _areas = [
    'Adajan',
    'Vesu',
    'Varachha',
    'Katargam',
    'Piplod',
  ];

  String? _selectedCategory;
  String? _selectedCity;
  String? _selectedArea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxxl,
                  vertical: AppSpacing.xxxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Editorial Header
                    Text(
                      'Business Profile',
                      style: AppTextStyles.headlineLG.copyWith(
                        color: AppColors.primary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Register your outlet to start managing\ncoupons and settlements.',
                      style: AppTextStyles.bodySM.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Core Identity Section
                    _buildSectionTitle('CORE IDENTITY'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Business Name',
                      hint: 'e.g. LaPinoz Pizza',
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Business Category',
                      hint: 'Select Category',
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (val) =>
                          setState(() => _selectedCategory = val),
                    ),
                    const SizedBox(height: 40),

                    // Location Section
                    _buildSectionTitle('LOCATION'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            label: 'City',
                            hint: 'Select City',
                            value: _selectedCity,
                            items: _cities,
                            onChanged: (val) =>
                                setState(() => _selectedCity = val),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Area',
                            hint: 'Select Area',
                            value: _selectedArea,
                            items: _areas,
                            onChanged: (val) =>
                                setState(() => _selectedArea = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Full Business Address',
                      hint: 'Street name, Building, Landmark...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 40),

                    // Contact & Finance Section
                    _buildSectionTitle('CONTACT & FINANCE'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Phone Number',
                      hint: '+91 00000 00000',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Email Address',
                      hint: 'business@example.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(label: 'UPI ID', hint: 'merchant@upi'),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onSurface.withOpacity(0.03),
                    offset: const Offset(0, -10),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {}, // Do nothing on click as per request
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Confirm Registration',
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.labelSM.copyWith(
        color: AppColors.primary.withOpacity(0.6),
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSM.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: AppTextStyles.bodyMD,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyMD.copyWith(
                color: AppColors.outlineVariant,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              // Focus state with Ghost Border logic could be added here if needed
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSM.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: AppTextStyles.bodyMD.copyWith(
                  color: AppColors.outlineVariant,
                ),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: AppTextStyles.bodyMD),
                );
              }).toList(),
              onChanged: onChanged,
              dropdownColor: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
