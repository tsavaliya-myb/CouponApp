// lib/features/qr/presentation/screens/qr_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true, // Needed for floating authentic glass bottom nav
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // ── Active Subscription Pill ──────────────────────────────────
              Center(
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
                        'SUBSCRIPTION ACTIVE - SURAT BOOK',
                        style: AppTextStyles.dsLabelMd.copyWith(
                          color: AppColors.dsSecondaryMint,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── QR Identity Card ────────────────────────────────────────
              Padding(
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
                      // User Info Row
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.dsSurfaceContainerLow,
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image: NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder Avatar
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Aarav Mehta', style: AppTextStyles.dsTitleLg),
                              const SizedBox(height: 2),
                              Text(
                                'Verified Diamond Tier',
                                style: AppTextStyles.dsBodyMd.copyWith(
                                  color: AppColors.dsOnSurface.withOpacity(0.6),
                                  fontFamily: 'Be Vietnam Pro', // Serif styling approximated
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // QR Code Frame
                      SizedBox(
                        width: 240,
                        height: 240,
                        child: CustomPaint(
                          painter: _QrCornersPainter(
                            color: AppColors.dsPrimary,
                            strokeWidth: 4,
                            cornerLength: 24,
                            borderRadius: 24,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.dsSurfaceContainerLow.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.qr_code_2_rounded,
                                  size: 160,
                                  color: AppColors.dsOnSurface.withOpacity(0.8),
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
                      const SizedBox(height: 16),

                      // Refresh Timer
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.dsSurfaceContainerLow,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.refresh_rounded, color: AppColors.dsPrimary, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Refreshes in 1:45',
                              style: AppTextStyles.dsLabelMd.copyWith(color: AppColors.dsPrimary, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // ── Redemption Guide ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('Redemption Guide', style: AppTextStyles.dsTitleLg.copyWith(fontSize: 20)),
              ),
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _GuideStep(
                      number: '01',
                      text: 'Ensure the merchant is ready to scan before revealing this screen.',
                    ),
                    const SizedBox(height: 16),
                    _GuideStep(
                      number: '02',
                      text: 'For high-security vouchers, you may be asked for a one-time verification pin.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 140), // Buffer for the glassmorphic bottom nav
            ],
          ),
        ),
      ),
    );
  }
}


class _GuideStep extends StatelessWidget {
  final String number;
  final String text;

  const _GuideStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.dsPrimary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.dsTitleLg.copyWith(
                  color: AppColors.dsPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.dsBodyMd.copyWith(
                color: AppColors.dsOnSurface.withOpacity(0.7),
                height: 1.4,
              ),
            ),
          ),
        ],
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
    path.arcToPoint(Offset(borderRadius, 0), radius: Radius.circular(borderRadius));
    path.lineTo(cornerLength, 0);

    // Top-right
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width - borderRadius, 0);
    path.arcToPoint(Offset(size.width, borderRadius), radius: Radius.circular(borderRadius));
    path.lineTo(size.width, cornerLength);

    // Bottom-right
    path.moveTo(size.width, size.height - cornerLength);
    path.lineTo(size.width, size.height - borderRadius);
    path.arcToPoint(Offset(size.width - borderRadius, size.height), radius: Radius.circular(borderRadius));
    path.lineTo(size.width - cornerLength, size.height);

    // Bottom-left
    path.moveTo(cornerLength, size.height);
    path.lineTo(borderRadius, size.height);
    path.arcToPoint(Offset(0, size.height - borderRadius), radius: Radius.circular(borderRadius));
    path.lineTo(0, size.height - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


