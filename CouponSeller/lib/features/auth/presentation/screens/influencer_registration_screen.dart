import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/map_picker.dart';
import '../../../../core/models/niche_item.dart';
import '../../../../core/providers/niches_provider.dart';
import '../../../../core/network/api_client.dart';
import '../providers/auth_provider.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../../../core/storage/secure_storage_service.dart';

class InfluencerRegistrationScreen extends ConsumerStatefulWidget {
  final String registrationToken;
  final String phone;
  const InfluencerRegistrationScreen({
    super.key,
    required this.registrationToken,
    required this.phone,
  });

  @override
  ConsumerState<InfluencerRegistrationScreen> createState() => _InfluencerRegistrationScreenState();
}

class _InfluencerRegistrationScreenState extends ConsumerState<InfluencerRegistrationScreen> {
  NicheItem? _selectedNiche;
  String? _selectedCity;
  LatLng? _selectedLocation;
  bool _isLoading = false;

  final _fullNameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _followersController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _upiIdController = TextEditingController();

  final List<String> _platforms = ['INSTAGRAM', 'YOUTUBE', 'TWITTER', 'FACEBOOK', 'SNAPCHAT', 'TIKTOK', 'LINKEDIN'];
  final Set<String> _selectedPlatforms = {};

  final _instaController = TextEditingController();
  final _youtubeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phone;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _displayNameController.dispose();
    _bioController.dispose();
    _followersController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _upiIdController.dispose();
    _instaController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (_fullNameController.text.isEmpty ||
        _displayNameController.text.isEmpty ||
        _selectedNiche == null ||
        _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiClient = GetIt.I<ApiClient>();
      
      final socialLinks = <String, String>{};
      if (_instaController.text.isNotEmpty) socialLinks['instagram'] = _instaController.text.trim();
      if (_youtubeController.text.isNotEmpty) socialLinks['youtube'] = _youtubeController.text.trim();

      final payload = {
        'fullName': _fullNameController.text.trim(),
        'displayName': _displayNameController.text.trim(),
        'nicheId': _selectedNiche!.id,
        'cityId': _selectedCity,
        'email': _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        'bio': _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
        'totalFollowers': int.tryParse(_followersController.text.trim()) ?? 0,
        'upiId': _upiIdController.text.trim().isEmpty ? null : _upiIdController.text.trim(),
        'platforms': _selectedPlatforms.toList(),
        'socialLinks': socialLinks,
      };

      // Ensure the registration token is used for this request
      final response = await apiClient.client.post(
        '/influencers/register',
        data: payload,
        options: Options(
          headers: {'Authorization': 'Bearer ${widget.registrationToken}'},
        ),
      );

      if (response.data['success'] == true) {
        // Save new tokens
        final data = response.data['data'];
        final secureStorage = GetIt.I<SecureStorageService>();
        await secureStorage.write(key: 'access_token', value: data['accessToken']);
        await secureStorage.write(key: 'refresh_token', value: data['refreshToken']);
        
        if (mounted) {
          context.go('/approval-pending', extra: 'PENDING');
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        final msg = e.response?.data['error'] ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.labelLG.copyWith(
        color: AppColors.primary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMD),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          style: AppTextStyles.bodyMD,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMD.copyWith(color: AppColors.textSecondary),
            filled: true,
            fillColor: enabled ? AppColors.surfaceContainerLow : AppColors.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.outlineVariant),
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
    required List<DropdownMenuItem<String>>? items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMD),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMD.copyWith(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      Text(
                        'Creator Profile',
                        style: AppTextStyles.headlineLG.copyWith(
                          color: AppColors.primary,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Register as an influencer to offer promotional services to users.',
                        style: AppTextStyles.bodySM.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 48),

                      _buildSectionTitle('CORE IDENTITY'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Full Name *',
                        hint: 'e.g. Ramesh Kumar',
                        controller: _fullNameController,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Display Name / Handle *',
                        hint: 'e.g. @ramesh_foodie',
                        controller: _displayNameController,
                      ),
                      const SizedBox(height: 16),
                      Consumer(
                        builder: (context, ref, child) {
                          final nichesAsync = ref.watch(nichesProvider);
                          return nichesAsync.when(
                            data: (niches) => _buildDropdownField(
                              label: 'Influencer Niche *',
                              hint: 'Select Niche',
                              value: _selectedNiche?.id,
                              items: niches
                                  .map((n) => DropdownMenuItem(value: n.id, child: Text(n.name)))
                                  .toList(),
                              onChanged: (val) => setState(() {
                                _selectedNiche = val == null ? null : niches.firstWhere((n) => n.id == val);
                              }),
                            ),
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => const Text('Error loading niches'),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Short Bio',
                        hint: 'Tell users what you do...',
                        controller: _bioController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 40),

                      _buildSectionTitle('SOCIAL REACH'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Total Followers (approx) *',
                        hint: 'e.g. 50000',
                        controller: _followersController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      Text('Active Platforms', style: AppTextStyles.labelMD),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _platforms.map((p) {
                          final isSelected = _selectedPlatforms.contains(p);
                          return FilterChip(
                            label: Text(p),
                            selected: isSelected,
                            onSelected: (val) {
                              setState(() {
                                if (val) _selectedPlatforms.add(p);
                                else _selectedPlatforms.remove(p);
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Instagram Profile URL',
                        hint: 'https://instagram.com/...',
                        controller: _instaController,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'YouTube Channel URL',
                        hint: 'https://youtube.com/...',
                        controller: _youtubeController,
                      ),
                      const SizedBox(height: 40),

                      _buildSectionTitle('LOCATION & PAYMENTS'),
                      const SizedBox(height: 16),
                      Consumer(
                        builder: (context, ref, child) {
                          final citiesAsync = ref.watch(citiesProvider);
                          return citiesAsync.when(
                            data: (cities) => _buildDropdownField(
                              label: 'City *',
                              hint: 'Select your city',
                              value: _selectedCity,
                              items: cities
                                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                                  .toList(),
                              onChanged: (val) => setState(() {
                                _selectedCity = val;
                              }),
                            ),
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => const Text('Error loading cities'),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Phone Number (Verified)',
                        hint: '',
                        controller: _phoneController,
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Email (Optional)',
                        hint: 'For notifications',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'UPI ID (For payouts)',
                        hint: 'e.g. 9876543210@ybl',
                        controller: _upiIdController,
                      ),
                      
                      const SizedBox(height: 80), // Padding for button
                    ],
                  ),
                ),
              ),
              // Bottom Action Bar
              Container(
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Submit Profile', style: AppTextStyles.titleMD),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
