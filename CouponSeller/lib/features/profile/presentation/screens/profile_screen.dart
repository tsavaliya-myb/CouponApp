import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/seller_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/upload_seller_media_usecase.dart';
import '../providers/profile_provider.dart';
import 'location_picker_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.onSurface, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Merchant Profile', style: AppTextStyles.headlineSM),
        centerTitle: true,
        actions: [
          profileAsync.whenOrNull(
                data: (_) => IconButton(
                  icon: const Icon(Icons.refresh_rounded,
                      color: AppColors.onSurface, size: 22),
                  onPressed: () =>
                      ref.read(profileNotifierProvider.notifier).refresh(),
                ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: profileAsync.when(
        loading: () => const _ProfileShimmer(),
        error: (err, _) => _ProfileError(
          message: err.toString(),
          onRetry: () => ref.read(profileNotifierProvider.notifier).refresh(),
        ),
        data: (profile) => _ProfileContent(profile: profile),
      ),
    );
  }
}

// ─── Loading skeleton ─────────────────────────────────────────────────────────

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        children: [
          _shimmerBox(100, 100, radius: 30),
          const SizedBox(height: 16),
          _shimmerBox(16, 180),
          const SizedBox(height: 8),
          _shimmerBox(12, 100),
          const SizedBox(height: 32),
          _shimmerBox(64, double.infinity, radius: 12),
          const SizedBox(height: 24),
          _shimmerBox(160, double.infinity, radius: 24),
          const SizedBox(height: 16),
          _shimmerBox(140, double.infinity, radius: 24),
        ],
      ),
    );
  }

  Widget _shimmerBox(double height, double width, {double radius = 8}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─── Error state ──────────────────────────────────────────────────────────────

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text('Could not load profile',
                style: AppTextStyles.headlineSM, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message,
                style: AppTextStyles.bodySM
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Main content ─────────────────────────────────────────────────────────────

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.profile});
  final SellerProfileEntity profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        children: [
          _ProfileHeader(profile: profile),
          const SizedBox(height: 32),
          _StatusCard(profile: profile),
          const SizedBox(height: 24),

          // Business info
          _InfoCard(
            title: 'Business Details',
            icon: Icons.storefront_outlined,
            children: [
              _InfoField('BUSINESS NAME', profile.businessName),
              _InfoField('CATEGORY', profile.category),
              _InfoField('CITY', profile.cityName),
              _InfoField('AREA', profile.areaName),
              if (profile.address != null && profile.address!.isNotEmpty)
                _InfoField('ADDRESS', profile.address!),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Contact details
          _InfoCard(
            title: 'Contact Details',
            icon: Icons.contact_page_outlined,
            children: [
              _InfoField('MOBILE NUMBER', profile.formattedPhone),
              if (profile.email != null && profile.email!.isNotEmpty)
                _InfoField('EMAIL ADDRESS', profile.email!),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Settlement (editable UPI)
          _SettlementCard(profile: profile),
          const SizedBox(height: AppSpacing.xl),

          // Location (editable via map)
          _LocationCard(profile: profile),
          const SizedBox(height: AppSpacing.xl),

          // Content Media
          _MediaCard(profile: profile),
          const SizedBox(height: AppSpacing.xl),

          // Commission
          _CommissionCard(commissionPct: profile.commissionPct),
          const SizedBox(height: AppSpacing.xl),

          // Settings
          _SettingsItem(icon: Icons.security_outlined, title: 'Privacy & Security'),
          _SettingsItem(icon: Icons.description_outlined, title: 'Compliance Docs'),
          _SettingsItem(icon: Icons.help_outline_rounded, title: 'Help & Training'),
          const SizedBox(height: 48),

          // Logout
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text('LOGOUT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEBEE),
                foregroundColor: const Color(0xFFD32F2F),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                textStyle:
                    AppTextStyles.buttonText.copyWith(letterSpacing: 1.2),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

// ─── Profile header ───────────────────────────────────────────────────────────

class _ProfileHeader extends ConsumerWidget {
  const _ProfileHeader({required this.profile});
  final SellerProfileEntity profile;

  Future<void> _pickAndUploadLogo(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    
    final length = await image.length();
    if (length > 2 * 1024 * 1024) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Logo must not be greater than 2 MB'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uploading logo...'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    
    final error = await ref.read(profileNotifierProvider.notifier).uploadLogo(image.path);
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logo updated successfully'),
            backgroundColor: Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickAndUploadLogo(context, ref),
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF14291F),
                  borderRadius: BorderRadius.circular(30),
                  image: profile.logoUrl != null
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(profile.logoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profile.logoUrl == null
                    ? const Center(
                        child: Icon(Icons.storefront_rounded,
                            color: Color(0xFFFFA726), size: 40))
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.edit_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          profile.businessName,
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineMD.copyWith(fontSize: 26, height: 1.2),
        ),
        const SizedBox(height: 8),
        Text(
          '${profile.areaName}, ${profile.cityName}',
          style:
              AppTextStyles.bodySM.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatusBadge(isActive: profile.isActive),
            const SizedBox(width: 8),
            _CategoryChip(category: profile.category),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD1E7DD) : const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.verified_rounded : Icons.hourglass_top_rounded,
            color: isActive
                ? const Color(0xFF0F5132)
                : const Color(0xFF664D03),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'ACTIVE' : 'PENDING',
            style: TextStyle(
              color: isActive
                  ? const Color(0xFF0F5132)
                  : const Color(0xFF664D03),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Status card ──────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.profile});
  final SellerProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final isActive = profile.isActive;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: isActive
                ? const Color(0xFF1B5E20)
                : const Color(0xFFF59E0B),
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'APPROVAL STATUS',
            style:
                AppTextStyles.labelSM.copyWith(fontSize: 9, letterSpacing: 0.5),
          ),
          const SizedBox(height: 4),
          Text(
            isActive ? 'ACTIVE & OPERATIONAL' : profile.status,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFF1B5E20)
                  : const Color(0xFFF59E0B),
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Settlement card (editable UPI) ──────────────────────────────────────────

class _SettlementCard extends ConsumerWidget {
  const _SettlementCard({required this.profile});
  final SellerProfileEntity profile;

  Future<void> _showUpiEditSheet(
      BuildContext context, WidgetRef ref) async {
    final controller =
        TextEditingController(text: profile.upiId ?? '');
    final formKey = GlobalKey<FormState>();
    bool saving = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Edit UPI ID', style: AppTextStyles.headlineSM),
                  const SizedBox(height: 4),
                  Text(
                    'Payouts will be sent to this UPI address',
                    style: AppTextStyles.bodySM
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'UPI ID',
                      hintText: 'yourname@bankname',
                      prefixIcon: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: AppColors.primary),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'UPI ID cannot be empty';
                      }
                      if (!v.contains('@')) {
                        return 'Enter a valid UPI ID (e.g. name@bank)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: saving
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;
                              setSheetState(() => saving = true);
                              final error = await ref
                                  .read(profileNotifierProvider.notifier)
                                  .updateProfile(
                                    UpdateSellerProfileParams(
                                        upiId: controller.text.trim()),
                                  );
                              setSheetState(() => saving = false);
                              if (ctx.mounted) {
                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error == null
                                        ? 'UPI ID updated successfully'
                                        : error),
                                    backgroundColor: error == null
                                        ? const Color(0xFF16A34A)
                                        : AppColors.error,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        textStyle: AppTextStyles.buttonText,
                      ),
                      child: saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save UPI ID'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUpi = profile.upiId != null && profile.upiId!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined,
                  color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                'Settlement Details',
                style: AppTextStyles.headlineSM
                    .copyWith(color: Colors.white, fontSize: 18),
              ),
              const Spacer(),
              // Edit button
              GestureDetector(
                onTap: () => _showUpiEditSheet(context, ref),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_rounded,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: AppTextStyles.bodySM.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'UPI ID for payouts',
            style:
                AppTextStyles.bodySM.copyWith(color: Colors.white.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRIMARY VPA',
                        style: AppTextStyles.labelSM.copyWith(
                            fontSize: 8,
                            color: Colors.white.withOpacity(0.4)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hasUpi ? profile.upiId! : 'Not configured yet',
                        style: AppTextStyles.bodyMD.copyWith(
                          color: hasUpi
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                          fontStyle: hasUpi
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Location card (editable via map) ────────────────────────────────────────

class _LocationCard extends ConsumerWidget {
  const _LocationCard({required this.profile});
  final SellerProfileEntity profile;

  Future<void> _openLocationPicker(
      BuildContext context, WidgetRef ref) async {
    final initialLat = profile.latitude ?? 21.1702;
    final initialLng = profile.longitude ?? 72.8311;

    final result = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialLat: initialLat,
          initialLng: initialLng,
        ),
      ),
    );

    if (result == null || !context.mounted) return;

    final error = await ref
        .read(profileNotifierProvider.notifier)
        .updateProfile(UpdateSellerProfileParams(
          latitude: result.latitude,
          longitude: result.longitude,
        ));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error == null
              ? 'Location updated successfully'
              : error),
          backgroundColor:
              error == null ? const Color(0xFF16A34A) : AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLocation =
        profile.latitude != null && profile.longitude != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Business Location',
                style: AppTextStyles.headlineSM.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (hasLocation)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.my_location_rounded,
                      color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${profile.latitude!.toStringAsFixed(5)}, '
                    '${profile.longitude!.toStringAsFixed(5)}',
                    style: AppTextStyles.bodyMD.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              'No location pinned yet',
              style:
                  AppTextStyles.bodySM.copyWith(color: AppColors.textSecondary),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openLocationPicker(context, ref),
              icon: Icon(
                hasLocation ? Icons.edit_location_alt_rounded : Icons.add_location_alt_rounded,
                size: 18,
              ),
              label: Text(hasLocation ? 'Update Location on Map' : 'Pin Location on Map'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceContainerLow,
                foregroundColor: AppColors.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                textStyle:
                    AppTextStyles.bodyMD.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Commission card ──────────────────────────────────────────────────────────

class _CommissionCard extends StatelessWidget {
  const _CommissionCard({required this.commissionPct});
  final double commissionPct;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.percent_rounded,
                color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Platform Commission',
                    style: AppTextStyles.bodyMD
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Applied on each coupon redemption',
                    style: AppTextStyles.bodySM
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(
            '${commissionPct.toStringAsFixed(0)}%',
            style: AppTextStyles.headlineMD.copyWith(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Info card ────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(title,
                  style: AppTextStyles.headlineSM.copyWith(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

// ─── Info field ───────────────────────────────────────────────────────────────

class _InfoField extends StatelessWidget {
  const _InfoField(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSM.copyWith(
                fontSize: 9,
                color: AppColors.textSecondary.withOpacity(0.5)),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.bodyMD
                .copyWith(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// ─── Settings item ────────────────────────────────────────────────────────────

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(title,
            style: AppTextStyles.bodyMD.copyWith(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 14, color: AppColors.textSecondary),
        onTap: () {},
      ),
    );
  }
}

// ─── Media card ──────────────────────────────────────────────────────────────

class _MediaCard extends ConsumerStatefulWidget {
  const _MediaCard({required this.profile});
  final SellerProfileEntity profile;

  @override
  ConsumerState<_MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends ConsumerState<_MediaCard> {
  Future<void> _pickAndUploadImage(int index) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final length = await file.length();
    if (length > 3 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Photo must be less than 3 MB'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error));
      }
      return;
    }

    final decoded = await decodeImageFromList(await file.readAsBytes());
    if (decoded.width < decoded.height) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Photo must be horizontal (landscape)'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error));
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Uploading photo...'), behavior: SnackBarBehavior.floating,));
    }

    final params = index == 1
        ? UploadSellerMediaParams(photo1Path: file.path)
        : UploadSellerMediaParams(photo2Path: file.path);

    final error = await ref.read(profileNotifierProvider.notifier).uploadMedia(params);
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.error));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Photo updated successfully'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF16A34A)));
      }
    }
  }

  Future<void> _pickAndUploadVideo() async {
    final picker = ImagePicker();
    final file = await picker.pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 30));
    if (file == null) return;

    final length = await file.length();
    if (length > 10 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Video must be less than 10 MB'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error));
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Checking video format...'), behavior: SnackBarBehavior.floating,));
    }

    try {
      final controller = VideoPlayerController.file(File(file.path));
      await controller.initialize();
      final size = controller.value.size;
      final duration = controller.value.duration;
      await controller.dispose();

      if (duration.inSeconds > 30) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Video must be less than 30 seconds'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.error));
        }
        return;
      }
      if (size.width < size.height) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Video must be horizontal (landscape)'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.error));
        }
        return;
      }
    } catch (_) {
      // Ignored if video player fails to load formatting
    }

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Uploading video...'), behavior: SnackBarBehavior.floating,));
    }

    final params = UploadSellerMediaParams(videoPath: file.path);
    final error = await ref.read(profileNotifierProvider.notifier).uploadMedia(params);
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.error));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Video updated successfully'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF16A34A)));
      }
    }
  }

  Widget _buildMediaItem(String label, String? url, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          image: url != null
              ? DecorationImage(
                  image: CachedNetworkImageProvider(url),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: url == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: AppColors.textSecondary.withOpacity(0.5), size: 32),
                    const SizedBox(height: 8),
                    Text(label,
                        style: AppTextStyles.labelSM
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: AppColors.surface, shape: BoxShape.circle),
                  child: const Icon(Icons.edit_rounded,
                      color: AppColors.primary, size: 14),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.perm_media_outlined,
                  color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Store & Content Media',
                style: AppTextStyles.headlineSM.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Upload horizontal format only. Max size: 3MB (Photo), 10MB (Video up to 30s).',
            style: AppTextStyles.bodySM.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildMediaItem(
                  'Photo 1',
                  widget.profile.photoUrl1,
                  Icons.add_photo_alternate_outlined,
                  () => _pickAndUploadImage(1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMediaItem(
                  'Photo 2',
                  widget.profile.photoUrl2,
                  Icons.add_photo_alternate_outlined,
                  () => _pickAndUploadImage(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.profile.videoUrl != null)
            _VideoThumbnailWidget(
              videoUrl: widget.profile.videoUrl!,
              onEditTap: _pickAndUploadVideo,
            )
          else
            _buildMediaItem(
              'Video',
              null,
              Icons.video_call_outlined,
              _pickAndUploadVideo,
            ),
        ],
      ),
    );
  }
}

class _VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final VoidCallback onEditTap;

  const _VideoThumbnailWidget({required this.videoUrl, required this.onEditTap});

  @override
  State<_VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<_VideoThumbnailWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _initialized = true;
          });
          // Ensuring the first frame is visible
          _controller.seekTo(Duration.zero);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Taller horizontally for video
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_initialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            else
              Center(
                child: Icon(Icons.video_call_outlined, color: AppColors.textSecondary.withOpacity(0.5), size: 32),
              ),
            // Play Button Area (Full cover except the edit button)
            if (_initialized)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => _VideoPlayerDialog(videoUrl: widget.videoUrl),
                    );
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.3), // Dark overlay
                    child: const Center(
                      child: Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 42),
                    ),
                  ),
                ),
              ),
            // Edit Button Area
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: widget.onEditTap,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: AppColors.surface, shape: BoxShape.circle),
                  child: const Icon(Icons.edit_rounded,
                      color: AppColors.primary, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoPlayerDialog extends StatefulWidget {
  final String videoUrl;
  const _VideoPlayerDialog({required this.videoUrl});

  @override
  State<_VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<_VideoPlayerDialog> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _initialized = true;
          });
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_initialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: VideoPlayer(_controller),
              ),
            )
          else
            const CircularProgressIndicator(color: Colors.white),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              style: IconButton.styleFrom(backgroundColor: Colors.black45),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          if (_initialized && !_controller.value.isPlaying)
            IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 48),
              ),
            ),
        ],
      ),
    );
  }
}
