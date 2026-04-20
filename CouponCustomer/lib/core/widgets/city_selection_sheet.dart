import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../services/location_service.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Non-dismissable bottom sheet shown when the user has no city set.
/// User must either allow location or manually pick a city before proceeding.
class CitySelectionSheet extends ConsumerStatefulWidget {
  const CitySelectionSheet({super.key});

  @override
  ConsumerState<CitySelectionSheet> createState() => _CitySelectionSheetState();
}

class _CitySelectionSheetState extends ConsumerState<CitySelectionSheet> {
  String? _selectedCityId;
  bool _isDetectingLocation = false;
  bool _isSaving = false;
  bool _gpsAttempted = false;
  String? _detectedCityName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryGps());
  }

  Future<void> _tryGps() async {
    if (_gpsAttempted) return;
    _gpsAttempted = true;

    final cities = ref.read(citiesProvider).valueOrNull;
    if (cities == null || cities.isEmpty) return;

    setState(() => _isDetectingLocation = true);
    try {
      final result = await LocationService.detectCity();
      if (!mounted) return;
      if (result.hasCity) {
        final matched = LocationService.matchCity(
          result.cityName!,
          cities.map((c) => c.name),
        );
        if (matched != null) {
          final city = cities.firstWhere(
            (c) => c.name == matched,
            orElse: () => cities.first,
          );
          setState(() {
            _selectedCityId = city.id;
            _detectedCityName = matched;
          });
        }
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isDetectingLocation = false);
    }
  }

  Future<void> _requestLocationManually(List cities) async {
    _gpsAttempted = false;
    setState(() {
      _isDetectingLocation = true;
      _detectedCityName = null;
    });

    try {
      final result = await LocationService.detectCity();
      if (!mounted) return;
      if (result.hasCity) {
        final matched = LocationService.matchCity(
          result.cityName!,
          cities.map((c) => c.name as String),
        );
        if (matched != null) {
          final city = cities.firstWhere(
            (c) => c.name == matched,
            orElse: () => cities.first,
          );
          setState(() {
            _selectedCityId = city.id;
            _detectedCityName = matched;
          });
        } else {
          _showSnack('City not found in our list. Please select manually.');
        }
      } else if (result.permissionDenied) {
        _showSnack('Location permission denied. Please select your city manually.');
      } else if (result.serviceDisabled) {
        _showSnack('Location services are off. Please select your city manually.');
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isDetectingLocation = false);
    }
  }

  Future<void> _save() async {
    if (_selectedCityId == null) {
      _showSnack('Please select your city to continue.');
      return;
    }
    setState(() => _isSaving = true);
    try {
      await ref.read(profileProvider.notifier).updateUser({
        'cityId': _selectedCityId,
      });
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final citiesAsync = ref.watch(citiesProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return PopScope(
      canPop: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
        decoration: const BoxDecoration(
          color: AppColors.dsSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 24),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dsOnSurface.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            // Icon + Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.dsPrimary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_city_rounded,
                      color: AppColors.dsPrimary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Your City',
                          style: AppTextStyles.dsTitleLg.copyWith(fontSize: 20)),
                      Text(
                        'We need your city to show relevant deals',
                        style: AppTextStyles.dsBodyMd.copyWith(
                          color: AppColors.dsOnSurface.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 24),

            // GPS detection status
            if (_isDetectingLocation)
              const _StatusBanner(
                icon: null,
                message: 'Detecting your location…',
                isLoading: true,
              ).animate().fadeIn()
            else if (_detectedCityName != null)
              _StatusBanner(
                icon: Icons.check_circle_outline_rounded,
                message: 'Auto-detected: $_detectedCityName',
                color: AppColors.dsSecondaryMint,
              ).animate().fadeIn(),

            if (_isDetectingLocation || _detectedCityName != null)
              const SizedBox(height: 12),

            // City dropdown
            citiesAsync.when(
              loading: () => const LinearProgressIndicator(
                  color: AppColors.dsPrimary),
              error: (_, __) => Text('Could not load cities',
                  style:
                      AppTextStyles.dsBodyMd.copyWith(color: AppColors.error)),
              data: (cities) {
                // Auto-trigger GPS once cities are available
                if (!_gpsAttempted && _selectedCityId == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => _tryGps());
                }
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedCityId,
                      hint: Text(
                        'Select your city',
                        style: AppTextStyles.dsBodyMd.copyWith(
                            color: AppColors.dsOnSurface.withValues(alpha: 0.4)),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_city_outlined,
                            color: AppColors.dsPrimary, size: 20),
                        filled: true,
                        fillColor: AppColors.dsSurfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: AppColors.dsOnSurface.withValues(alpha: 0.08)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: AppColors.dsOnSurface.withValues(alpha: 0.08)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: AppColors.dsPrimary),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                      dropdownColor: AppColors.dsSurfaceContainerLowest,
                      isExpanded: true,
                      items: cities
                          .map((city) => DropdownMenuItem(
                                value: city.id,
                                child: Text(city.name,
                                    style: AppTextStyles.dsBodyMd),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() {
                        _selectedCityId = val;
                        _detectedCityName = null;
                      }),
                    ),
                    const SizedBox(height: 12),

                    // Use My Location button
                    if (!_isDetectingLocation)
                      GestureDetector(
                        onTap: () => _requestLocationManually(cities),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.dsPrimary.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.dsPrimary.withValues(alpha: 0.15)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.my_location_rounded,
                                  size: 16, color: AppColors.dsPrimary),
                              const SizedBox(width: 8),
                              Text(
                                'Use My Location',
                                style: AppTextStyles.dsBodyMd.copyWith(
                                    color: AppColors.dsPrimary, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            const SizedBox(height: 28),

            // Confirm button
            AnimatedOpacity(
              opacity: _isSaving ? 0.7 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: InkWell(
                onTap: _isSaving ? null : _save,
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
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Continue',
                            style: AppTextStyles.dsButton
                                .copyWith(color: AppColors.dsSurfaceContainerLowest),
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
}

class _StatusBanner extends StatelessWidget {
  final IconData? icon;
  final String message;
  final bool isLoading;
  final Color color;

  const _StatusBanner({
    this.icon,
    required this.message,
    this.isLoading = false,
    this.color = AppColors.dsPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          if (isLoading)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            )
          else if (icon != null)
            Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(message,
              style: AppTextStyles.dsBodyMd.copyWith(color: color, fontSize: 13)),
        ],
      ),
    );
  }
}
