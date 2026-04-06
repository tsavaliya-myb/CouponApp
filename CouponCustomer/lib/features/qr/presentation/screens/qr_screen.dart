// lib/features/qr/presentation/screens/qr_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/security/qr_token_service.dart';
import '../../../../core/security/token_service.dart';
import '../../../../core/widgets/subscribe_gate_screen.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class QrScreen extends ConsumerStatefulWidget {
  const QrScreen({super.key});

  @override
  ConsumerState<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends ConsumerState<QrScreen> {
  Timer? _refreshTimer;
  String? _qrPayloadBase64;

  @override
  void initState() {
    super.initState();
    _startTimers();
    _generateQrPayload();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startTimers() {
    // Timer to trigger the actual payload refresh
    _refreshTimer = Timer.periodic(AppConstants.qrRefreshInterval, (_) {
      _generateQrPayload();
    });
  }

  Future<void> _generateQrPayload() async {
    final userState = ref.read(profileProvider);
    if (userState is! AsyncData) return;

    final user = userState.value;
    if (user == null || user.status != 'ACTIVE') return;

    final tokenService = GetIt.I<TokenService>();
    final accessToken = await tokenService.getAccessToken();

    if (accessToken != null) {
      final qrService = GetIt.I<QrTokenService>();
      final payload = qrService.generateUserQrPayload(
        userId: user.id,
        subscriptionToken: accessToken,
      );
      if (mounted) {
        setState(() {
          _qrPayloadBase64 = payload;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(profileProvider);

    // ── Subscription gate ──────────────────────────────────────────────────
    final isSubscribed = ref.watch(isSubscribedProvider);
    if (!isSubscribed) {
      return const SubscribeGateScreen(featureName: 'Identity QR');
    }

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        userState.when(
                          data: (user) {
                            final isActive = user.status == 'ACTIVE';
                            final city = user.city?.name ?? 'UNKNOWN CITY';

                            if (!isActive) {
                              return _buildExpiredState();
                            }

                            return Column(
                              children: [
                                _buildActiveSubscriptionPill(city),
                                const SizedBox(height: 24),
                                _buildQrCard(
                                    user.name ?? 'Valued Customer', city),
                              ],
                            );
                          },
                          loading: () => const Center(
                              child: Padding(
                            padding: EdgeInsets.all(48.0),
                            child: CircularProgressIndicator(),
                          )),
                          error: (err, stack) => Center(
                            child: Text(
                              'Error loading profile',
                              style: AppTextStyles.dsBodyMd
                                  .copyWith(color: AppColors.error),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpiredState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.dsSurfaceContainerLowest,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.error.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 64),
            const SizedBox(height: 16),
            Text(
              'Subscription Expired',
              style: AppTextStyles.dsTitleLg.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 8),
            Text(
              'Please renew your subscription to access your QR code and continue redeeming coupons.',
              textAlign: TextAlign.center,
              style: AppTextStyles.dsBodyMd
                  .copyWith(color: AppColors.dsOnSurface.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSubscriptionPill(String cityName) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.dsSecondaryMint.withOpacity(0.15),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.dsSecondaryMint,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'SUBSCRIPTION ACTIVE - ${cityName.toUpperCase()}',
              style: AppTextStyles.dsLabelMd.copyWith(
                color: AppColors.dsSecondaryMint,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCard(String userName, String city) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.dsSurfaceContainerLowest,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.dsOnSurface.withOpacity(0.04), // Ambient shadow
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // QR Code Frame
            SizedBox(
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: _QrCornersPainter(
                  color: AppColors.dsPrimary,
                  strokeWidth: 4,
                  cornerLength: 32,
                  borderRadius: 32,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.dsSurfaceContainerLow.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: _qrPayloadBase64 == null
                          ? const CircularProgressIndicator()
                          : QrImageView(
                              data: _qrPayloadBase64!,
                              version: QrVersions.auto,
                              size: 240,
                              backgroundColor: Colors.transparent,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: AppColors.dsOnSurface,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: AppColors.dsOnSurface,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Show this to the seller for\nredemption',
              textAlign: TextAlign.center,
              style: AppTextStyles.dsTitleLg.copyWith(
                fontSize: 16,
                color: AppColors.dsOnSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter to draw the top-left, top-right, bottom-left, bottom-right arc corners
class _QrCornersPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;
  final double borderRadius;

  _QrCornersPainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Top-left
    path.moveTo(0, cornerLength);
    path.arcToPoint(Offset(borderRadius, 0),
        radius: Radius.circular(borderRadius));
    path.lineTo(cornerLength, 0);

    // Top-right
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width - borderRadius, 0);
    path.arcToPoint(Offset(size.width, borderRadius),
        radius: Radius.circular(borderRadius));
    path.lineTo(size.width, cornerLength);

    // Bottom-right
    path.moveTo(size.width, size.height - cornerLength);
    path.lineTo(size.width, size.height - borderRadius);
    path.arcToPoint(Offset(size.width - borderRadius, size.height),
        radius: Radius.circular(borderRadius));
    path.lineTo(size.width - cornerLength, size.height);

    // Bottom-left
    path.moveTo(cornerLength, size.height);
    path.lineTo(borderRadius, size.height);
    path.arcToPoint(Offset(0, size.height - borderRadius),
        radius: Radius.circular(borderRadius));
    path.lineTo(0, size.height - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
