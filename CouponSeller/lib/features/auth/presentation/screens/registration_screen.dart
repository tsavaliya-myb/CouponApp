// lib/features/auth/presentation/screens/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/map_picker.dart';
import '../../../../core/models/category_item.dart';
import '../../../../core/providers/categories_provider.dart';
import '../../domain/entities/seller_entity.dart';
import '../providers/auth_provider.dart';
import '../../../location/presentation/providers/location_provider.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  final String registrationToken;
  final String phone;
  const RegistrationScreen({
    super.key,
    required this.registrationToken,
    required this.phone,
  });

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  CategoryItem? _selectedCategoryItem;
  String? _selectedCity;
  String? _selectedArea;
  LatLng? _selectedLocation;

  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _upiIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phone;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
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
                        controller: _businessNameController,
                      ),
                      const SizedBox(height: 16),
                      Consumer(
                        builder: (context, ref, child) {
                          final categoriesAsync =
                              ref.watch(categoriesProvider);
                          return categoriesAsync.when(
                            data: (categories) => _buildDropdownField(
                              label: 'Business Category',
                              hint: 'Select Category',
                              value: _selectedCategoryItem?.id,
                              items: categories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c.id,
                                      child: Text(
                                        c.name,
                                        style: AppTextStyles.bodyMD,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) => setState(() {
                                _selectedCategoryItem = val == null
                                    ? null
                                    : categories.firstWhere(
                                        (c) => c.id == val);
                              }),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (e, _) =>
                                const Text('Error loading categories'),
                          );
                        },
                      ),
                      const SizedBox(height: 40),

                      // Location Section
                      _buildSectionTitle('LOCATION'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
                                final citiesAsync = ref.watch(
                                  citiesNotifierProvider,
                                );
                                return citiesAsync.when(
                                  data: (cities) {
                                    return _buildDropdownField(
                                      label: 'City',
                                      hint: 'Select City',
                                      value: _selectedCity,
                                      items: cities
                                          .map(
                                            (c) => DropdownMenuItem(
                                              value: c.id,
                                              child: Text(
                                                c.name,
                                                style: AppTextStyles.bodyMD,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          _selectedCity = val;
                                          _selectedArea = null;
                                        });
                                      },
                                    );
                                  },
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  error: (e, st) =>
                                      Text('Error loading cities'),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
                                if (_selectedCity == null) {
                                  return _buildDropdownField(
                                    label: 'Area',
                                    hint: 'Select Area',
                                    value: null,
                                    items: [],
                                    onChanged: (val) {},
                                  );
                                }

                                final areasAsync = ref.watch(
                                  areasNotifierProvider(_selectedCity!),
                                );
                                return areasAsync.when(
                                  data: (areas) {
                                    return _buildDropdownField(
                                      label: 'Area',
                                      hint: 'Select Area',
                                      value: _selectedArea,
                                      items: areas
                                          .map(
                                            (a) => DropdownMenuItem(
                                              value: a.id,
                                              child: Text(
                                                a.name,
                                                style: AppTextStyles.bodyMD,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) =>
                                          setState(() => _selectedArea = val),
                                    );
                                  },
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  error: (e, st) => Text('Error loading areas'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Full Business Address',
                        hint: 'Street name, Building, Landmark...',
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
                        controller: _addressController,
                      ),
                      const SizedBox(height: 16),
                      _buildLocationPinButton(),
                      const SizedBox(height: 40),

                      // Contact & Finance Section
                      _buildSectionTitle('CONTACT & FINANCE'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Phone Number',
                        hint: '+91 00000 00000',
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Email Address',
                        hint: 'business@example.com',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'UPI ID',
                        hint: 'merchant@upi',
                        controller: _upiIdController,
                      ),
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
                      gradient: authState is AsyncLoading
                          ? null
                          : AppColors.primaryGradient,
                      color: authState is AsyncLoading
                          ? AppColors.surfaceContainerHighest
                          : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: authState is AsyncLoading
                          ? null
                          : _submitRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: authState is AsyncLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
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
      ),
    );
  }

  void _submitRegistration() async {
    // Collect data
    final businessName = _businessNameController.text.trim();
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final upiId = _upiIdController.text.trim();

    if (businessName.isEmpty ||
        address.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        upiId.isEmpty ||
        _selectedCategoryItem == null ||
        _selectedCity == null ||
        _selectedArea == null ||
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (address.length < 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address must be at least 15 characters long'),
        ),
      );
      return;
    }

    final params = RegisterSellerParams(
      registrationToken: widget.registrationToken,
      businessName: businessName,
      categoryId: _selectedCategoryItem!.id,
      cityId: _selectedCity!,
      areaId: _selectedArea!,
      address: address,
      email: email,
      upiId: upiId,
      lat: _selectedLocation!.latitude,
      lng: _selectedLocation!.longitude,
    );

    final success = await ref
        .read(authNotifierProvider.notifier)
        .registerSeller(params);

    if (success && mounted) {
      context.go('/approval-pending');
    } else if (mounted) {
      final errorStream = ref.read(authNotifierProvider).error;
      if (errorStream != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorStream.toString())));
      }
    }
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

  Widget _buildLocationPinButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exact Map Pin',
          style: AppTextStyles.labelSM.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final result = await Navigator.of(context).push<LatLng>(
              MaterialPageRoute(
                builder: (_) => MapPicker(initialLocation: _selectedLocation),
              ),
            );
            if (result != null) {
              setState(() {
                _selectedLocation = result;
              });
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: _selectedLocation == null
                  ? AppColors.surfaceContainerHighest.withOpacity(0.4)
                  : AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: _selectedLocation != null
                  ? Border.all(color: AppColors.primary.withOpacity(0.2))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  _selectedLocation == null
                      ? Icons.location_on_outlined
                      : Icons.location_on,
                  color: _selectedLocation == null
                      ? AppColors.textSecondary
                      : AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedLocation == null
                            ? 'Pin Exact Location'
                            : 'Location Pinned',
                        style: AppTextStyles.bodyMD.copyWith(
                          color: _selectedLocation == null
                              ? AppColors.textSecondary
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_selectedLocation != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedLocation!.latitude.toStringAsFixed(5)}, ${_selectedLocation!.longitude.toStringAsFixed(5)}',
                          style: AppTextStyles.labelSM.copyWith(
                            color: AppColors.primary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.map_outlined,
                  color: _selectedLocation == null
                      ? AppColors.textSecondary
                      : AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    TextEditingController? controller,
    bool readOnly = false,
    TextInputAction? textInputAction,
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
            color: readOnly
                ? AppColors.surfaceContainerLowest
                : AppColors.surfaceContainerHighest.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            maxLines: maxLines,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            style: AppTextStyles.bodyMD.copyWith(
              color: readOnly ? AppColors.textSecondary : AppColors.onSurface,
            ),
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
    required List<DropdownMenuItem<String>> items,
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
              items: items,
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
