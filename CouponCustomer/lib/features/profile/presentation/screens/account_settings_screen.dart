import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../../services/location_service.dart';
import '../providers/profile_provider.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedCityId;
  String? _selectedAreaId;

  bool _isInit = false;
  bool _isSaving = false;

  // GPS detection state
  bool _isDetectingLocation = false;
  String? _detectedCityName; // matched city name from API
  bool _gpsAttempted = false; // guard so we don't re-trigger on rebuilds

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
          _selectedCityId = user.cityId;
          _selectedAreaId = user.areaId;
          _isInit = true;
        });
      }
    });
  }

  // ── GPS detection ──────────────────────────────────────────────────────────

  Future<void> _attemptGpsDetection(List cities) async {
    if (_gpsAttempted || !mounted || _selectedCityId != null) return;
    _gpsAttempted = true;

    setState(() => _isDetectingLocation = true);

    try {
      final result = await LocationService.detectCity();
      if (!mounted) return;

      if (result.hasCity) {
        final apiNames = cities.map((c) => c.name as String);
        final matched = LocationService.matchCity(result.cityName!, apiNames);
        if (matched != null) {
          final matches = cities.where((c) => c.name == matched);
          final matchedCity = matches.isEmpty ? null : matches.first;
          if (matchedCity != null && _selectedCityId == null) {
            setState(() {
              _selectedCityId = matchedCity.id;
              _selectedAreaId = null;
              _detectedCityName = matched;
            });
            // Show a brief success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Auto-detected city: $matched'),
                duration: const Duration(seconds: 2),
                backgroundColor: AppColors.dsSecondaryMint,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        }
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isDetectingLocation = false);
    }
  }

  void _dismissDetectionBanner() {
    setState(() {
      _detectedCityName = null;
    });
  }

  // ── Save ───────────────────────────────────────────────────────────────────

  Future<void> _handleSave(user) async {
    if (!_formKey.currentState!.validate()) return;

    if (user.cityId == null && _selectedCityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select your city'),
          backgroundColor: AppColors.warning,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref.read(profileProvider.notifier).updateUser({
        'name': _nameController.text.trim(),
        if (_emailController.text.trim().isNotEmpty)
          'email': _emailController.text.trim(),
        if (user.cityId == null && _selectedCityId != null)
          'cityId': _selectedCityId,
        if (_selectedAreaId != null) 'areaId': _selectedAreaId,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: AppColors.dsSecondaryMint,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: profileAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.dsPrimary)),
        error: (err, _) => Center(
            child: Text('Error: $err',
                style:
                    AppTextStyles.dsBodyMd.copyWith(color: AppColors.error))),
        data: (user) {
          _initFields(user);
          final effectiveCityId = user.cityId ?? _selectedCityId;

          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // ── App Bar ─────────────────────────────────────────────
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
                                color: AppColors.dsPrimary.withOpacity(0.3),
                                width: 2.5),
                          ),
                          child: const Center(
                            child: Icon(Icons.manage_accounts_rounded,
                                color: AppColors.dsPrimary, size: 28),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Account Settings',
                          style:
                              AppTextStyles.dsDisplayLg.copyWith(fontSize: 26),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Form ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Name ────────────────────────────────────
                        _Label('Full Name'),
                        TextFormField(
                          controller: _nameController,
                          decoration: _inputDecoration(Icons.person_outline),
                          style: AppTextStyles.dsBodyMd,
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Name is required'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // ── Email ────────────────────────────────────
                        _Label('Email Address'),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(Icons.email_outlined),
                          style: AppTextStyles.dsBodyMd,
                        ),
                        const SizedBox(height: 20),

                        // ── Phone (read-only) ────────────────────────
                        _Label('Mobile Number'),
                        TextFormField(
                          initialValue: '+91 ${user.phone}',
                          readOnly: true,
                          decoration: _inputDecoration(Icons.phone_outlined,
                              isReadOnly: true),
                          style: AppTextStyles.dsBodyMd.copyWith(
                              color: AppColors.dsOnSurface.withOpacity(0.5)),
                        ),
                        const SizedBox(height: 20),

                        // ── City ─────────────────────────────────────
                        _Label('City'),
                        if (user.cityId != null)
                          // Locked once saved
                          _LockedField(
                            icon: Icons.location_city_outlined,
                            value: user.city?.name ?? 'Unknown',
                          )
                        else
                          // No city yet → load city list, try GPS
                          Consumer(builder: (context, ref, _) {
                            final citiesAsync = ref.watch(citiesProvider);
                            return citiesAsync.when(
                              loading: () => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: LinearProgressIndicator(
                                    color: AppColors.dsPrimary),
                              ),
                              error: (e, _) => Text(
                                'Could not load cities',
                                style: AppTextStyles.dsBodyMd
                                    .copyWith(color: AppColors.error),
                              ),
                              data: (cities) {
                                // Trigger GPS detection once, after cities load
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _attemptGpsDetection(cities);
                                });

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // GPS detection banner
                                    if (_isDetectingLocation)
                                      _GpsStatusBanner(
                                        message: 'Detecting your location…',
                                        isLoading: true,
                                      ).animate().fadeIn()
                                    else if (_detectedCityName != null)
                                      _GpsDetectedBanner(
                                        cityName: _detectedCityName!,
                                        onDismiss: _dismissDetectionBanner,
                                      )
                                          .animate()
                                          .fadeIn()
                                          .slideY(begin: -0.2, end: 0),

                                    if (_isDetectingLocation ||
                                        _detectedCityName != null)
                                      const SizedBox(height: 12),

                                    // City dropdown
                                    if (cities.isEmpty)
                                      Text('No active cities available.',
                                          style: AppTextStyles.dsBodyMd)
                                    else
                                      DropdownButtonFormField<String>(
                                        value: _selectedCityId,
                                        hint: Text(
                                          'Select your city',
                                          style: AppTextStyles.dsBodyMd
                                              .copyWith(
                                                  color: AppColors.dsOnSurface
                                                      .withOpacity(0.4)),
                                        ),
                                        decoration: _inputDecoration(
                                            Icons.location_city_outlined),
                                        dropdownColor:
                                            AppColors.dsSurfaceContainerLowest,
                                        isExpanded: true,
                                        items: cities
                                            .map((city) => DropdownMenuItem(
                                                  value: city.id,
                                                  child: Text(city.name,
                                                      style: AppTextStyles
                                                          .dsBodyMd),
                                                ))
                                            .toList(),
                                        onChanged: (val) => setState(() {
                                          _selectedCityId = val;
                                          _selectedAreaId = null;
                                          // Dismiss any pending banner
                                          _detectedCityName = null;
                                        }),
                                        validator: (val) => val == null
                                            ? 'Please select a city'
                                            : null,
                                      ),
                                  ],
                                );
                              },
                            );
                          }),
                        const SizedBox(height: 20),

                        // ── Area ─────────────────────────────────────
                        _Label('Area'),
                        if (effectiveCityId != null)
                          Consumer(builder: (context, ref, _) {
                            final areasAsync =
                                ref.watch(areasProvider(effectiveCityId));
                            return areasAsync.when(
                              loading: () => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: LinearProgressIndicator(
                                    color: AppColors.dsPrimary),
                              ),
                              error: (e, _) => Text('Error loading areas',
                                  style: AppTextStyles.dsBodyMd
                                      .copyWith(color: AppColors.error)),
                              data: (areas) {
                                if (areas.isEmpty) {
                                  return Text('No areas available.',
                                      style: AppTextStyles.dsBodyMd);
                                }
                                if (_selectedAreaId != null &&
                                    !areas
                                        .any((a) => a.id == _selectedAreaId)) {
                                  _selectedAreaId = null;
                                }
                                return DropdownButtonFormField<String>(
                                  value: _selectedAreaId,
                                  hint: Text('Select your area',
                                      style: AppTextStyles.dsBodyMd.copyWith(
                                          color: AppColors.dsOnSurface
                                              .withOpacity(0.4))),
                                  decoration:
                                      _inputDecoration(Icons.map_outlined),
                                  dropdownColor:
                                      AppColors.dsSurfaceContainerLowest,
                                  isExpanded: true,
                                  items: areas
                                      .map((area) => DropdownMenuItem(
                                            value: area.id,
                                            child: Text(area.name,
                                                style: AppTextStyles.dsBodyMd),
                                          ))
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedAreaId = val),
                                  validator: (val) => val == null
                                      ? 'Please select an area'
                                      : null,
                                );
                              },
                            );
                          })
                        else
                          _HintBox(
                              icon: Icons.info_outline_rounded,
                              message: 'Select a city first to see areas'),

                        const SizedBox(height: 48),

                        // ── Save Button ──────────────────────────────
                        AnimatedOpacity(
                          opacity: _isSaving ? 0.7 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: InkWell(
                            onTap: _isSaving ? null : () => _handleSave(user),
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.dsPrimary,
                                    AppColors.dsPrimaryContainer,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: _isSaving
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2),
                                      )
                                    : Text(
                                        'Save Changes',
                                        style: AppTextStyles.dsButton.copyWith(
                                            color: AppColors
                                                .dsSurfaceContainerLowest),
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
      prefixIcon: Icon(icon,
          color: isReadOnly
              ? AppColors.dsOnSurface.withOpacity(0.3)
              : AppColors.dsPrimary,
          size: 20),
      filled: true,
      fillColor: isReadOnly
          ? AppColors.dsSurfaceContainerLow.withOpacity(0.5)
          : AppColors.dsSurfaceContainerLowest,
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

// ── GPS status widgets ─────────────────────────────────────────────────────

class _GpsStatusBanner extends StatelessWidget {
  final String message;
  final bool isLoading;

  const _GpsStatusBanner({required this.message, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.dsPrimary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dsPrimary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          if (isLoading)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.dsPrimary),
            )
          else
            const Icon(Icons.location_on_rounded,
                size: 16, color: AppColors.dsPrimary),
          const SizedBox(width: 8),
          Text(message,
              style: AppTextStyles.dsBodyMd
                  .copyWith(color: AppColors.dsPrimary, fontSize: 13)),
        ],
      ),
    );
  }
}

class _GpsDetectedBanner extends StatelessWidget {
  final String cityName;
  final VoidCallback onDismiss;

  const _GpsDetectedBanner({
    required this.cityName,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.dsSecondaryMint.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dsSecondaryMint.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded,
              size: 16, color: AppColors.dsSecondaryMint),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.dsBodyMd.copyWith(fontSize: 13),
                children: [
                  const TextSpan(
                    text: 'Detected: ',
                    style: TextStyle(color: Color(0xFF4B5563)),
                  ),
                  TextSpan(
                    text: cityName,
                    style: const TextStyle(
                      color: AppColors.dsSecondaryMint,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Success indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.dsSecondaryMint.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    size: 14, color: AppColors.dsSecondaryMint),
                const SizedBox(width: 4),
                Text(
                  'Auto-selected',
                  style: AppTextStyles.dsLabelMd.copyWith(
                    color: AppColors.dsSecondaryMint,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Dismiss
          GestureDetector(
            onTap: onDismiss,
            child: Icon(
              Icons.close_rounded,
              size: 16,
              color: AppColors.dsOnSurface.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared small widgets ────────────────────────────────────────────────────

class _LockedField extends StatelessWidget {
  final IconData icon;
  final String value;

  const _LockedField({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dsOnSurface.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.dsOnSurface.withOpacity(0.3)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.dsBodyMd
                  .copyWith(color: AppColors.dsOnSurface.withOpacity(0.5)),
            ),
          ),
          Icon(Icons.lock_outline_rounded,
              size: 14, color: AppColors.dsOnSurface.withOpacity(0.25)),
        ],
      ),
    );
  }
}

class _HintBox extends StatelessWidget {
  final IconData icon;
  final String message;

  const _HintBox({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dsOnSurface.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.dsOnSurface.withOpacity(0.35)),
          const SizedBox(width: 8),
          Text(message,
              style: AppTextStyles.dsBodyMd
                  .copyWith(color: AppColors.dsOnSurface.withOpacity(0.4))),
        ],
      ),
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
