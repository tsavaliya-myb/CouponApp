import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/profile_provider.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedAreaId;
  bool _isInit = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initFields(user) {
    if (_isInit) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _nameController.text = user.name ?? '';
          _emailController.text = user.email ?? '';
          _selectedAreaId = user.areaId;
          _isInit = true;
        });
      }
    });
  }

  Future<void> _handleSave(String cityId) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(profileProvider.notifier).updateUser({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'cityId': cityId,
        if (_selectedAreaId != null) 'areaId': _selectedAreaId,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: AppColors.dsSecondaryMint,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.dsPrimary)),
        error: (err, _) => Center(child: Text('Error: $err', style: AppTextStyles.dsBodyMd.copyWith(color: AppColors.error))),
        data: (user) {
          _initFields(user);
          
          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // ── Header ───────────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: AppColors.dsSurface,
                surfaceTintColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.dsSurfaceContainerLow.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          size: 20, color: AppColors.dsOnSurface),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.dsPrimary.withOpacity(0.18),
                          AppColors.dsPrimary.withOpacity(0.04),
                          AppColors.dsSurface,
                        ],
                        stops: const [0, 0.55, 1],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 48),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.dsPrimary.withOpacity(0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.dsPrimary.withOpacity(0.3), width: 2.5),
                          ),
                          child: const Center(
                            child: Icon(Icons.manage_accounts_rounded,
                                color: AppColors.dsPrimary, size: 28),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Account Settings',
                          style: AppTextStyles.dsDisplayLg.copyWith(fontSize: 26),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Form ─────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        _Label('Full Name'),
                        TextFormField(
                          controller: _nameController,
                          decoration: _inputDecoration(Icons.person_outline),
                          style: AppTextStyles.dsBodyMd,
                          validator: (val) =>
                              val == null || val.trim().isEmpty ? 'Name is required' : null,
                        ),
                        const SizedBox(height: 20),

                        // Email
                        _Label('Email Address'),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(Icons.email_outlined),
                          style: AppTextStyles.dsBodyMd,
                        ),
                        const SizedBox(height: 20),

                        // Phone (Read-Only)
                        _Label('Mobile Number'),
                        TextFormField(
                          initialValue: '+91 ${user.phone}',
                          readOnly: true,
                          decoration: _inputDecoration(Icons.phone_outlined, isReadOnly: true),
                          style: AppTextStyles.dsBodyMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.5)),
                        ),
                        const SizedBox(height: 20),

                        // City (Read-Only)
                        _Label('City'),
                        TextFormField(
                          initialValue: user.city?.name ?? 'Unknown',
                          readOnly: true,
                          decoration: _inputDecoration(Icons.location_city_outlined, isReadOnly: true),
                          style: AppTextStyles.dsBodyMd.copyWith(color: AppColors.dsOnSurface.withOpacity(0.5)),
                        ),
                        const SizedBox(height: 20),

                        // Area Dropdown
                        _Label('Area'),
                        if (user.cityId != null)
                          Consumer(
                            builder: (context, ref, child) {
                              final areasAsync = ref.watch(areasProvider(user.cityId!));
                              return areasAsync.when(
                                loading: () => const LinearProgressIndicator(color: AppColors.dsPrimary),
                                error: (e, _) => Text('Error loading areas', style: AppTextStyles.dsBodyMd.copyWith(color: AppColors.error)),
                                data: (areas) {
                                  if (areas.isEmpty) return const Text('No areas available.');
                                  // Ensure selected area is within valid options
                                  if (_selectedAreaId != null && !areas.any((a) => a.id == _selectedAreaId)) {
                                    _selectedAreaId = null;
                                  }
                                  
                                  return DropdownButtonFormField<String>(
                                    value: _selectedAreaId,
                                    decoration: _inputDecoration(Icons.map_outlined),
                                    dropdownColor: AppColors.dsSurfaceContainerLowest,
                                    items: areas
                                        .map((area) => DropdownMenuItem(
                                              value: area.id,
                                              child: Text(area.name, style: AppTextStyles.dsBodyMd),
                                            ))
                                        .toList(),
                                    onChanged: (val) => setState(() => _selectedAreaId = val),
                                    validator: (val) => val == null ? 'Area is required' : null,
                                  );
                                },
                              );
                            },
                          ),

                        const SizedBox(height: 48),

                        // Save Button
                        AnimatedOpacity(
                          opacity: _isSaving ? 0.7 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: InkWell(
                            onTap: _isSaving ? null : () => _handleSave(user.cityId!),
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.dsPrimary, AppColors.dsPrimaryContainer],
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: _isSaving
                                    ? const SizedBox(
                                        width: 24, height: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : Text(
                                        'Save Changes',
                                        style: AppTextStyles.dsButton.copyWith(color: AppColors.dsSurfaceContainerLowest),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon, {bool isReadOnly = false}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: isReadOnly ? AppColors.dsOnSurface.withOpacity(0.3) : AppColors.dsPrimary, size: 20),
      filled: true,
      fillColor: isReadOnly ? AppColors.dsSurfaceContainerLow.withOpacity(0.5) : AppColors.dsSurfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.dsOnSurface.withOpacity(0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.dsOnSurface.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.dsPrimary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: AppTextStyles.dsLabelMd.copyWith(
          color: AppColors.dsPrimary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
