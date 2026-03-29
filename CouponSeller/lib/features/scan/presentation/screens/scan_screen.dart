import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final MobileScannerController controller = MobileScannerController();
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isNavigating) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _isNavigating = true;
                  debugPrint('Barcode detected: ${barcode.rawValue}');

                  context.push('/redemption', extra: barcode.rawValue).then((
                    _,
                  ) {
                    if (mounted) {
                      setState(() {
                        _isNavigating = false;
                      });
                    }
                  });
                  break; // Process one barcode per scan
                }
              }
            },
          ),

          // Custom Architectural Overlay
          _buildScannerOverlay(context),

          // Central Scan Frame & Animated Line
          _buildScanFrame(),

          // UI Elements (Header, Title, Footer)
          _buildUI(context),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        AppColors.primary.withOpacity(0.95), // Deep dark navy for high contrast
        BlendMode.srcOut,
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors
                  .black, // Must be black for BlendMode.dstOut to create the transparency hole
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          Center(
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                color: Colors.white, // The 'hole' color
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanFrame() {
    return Center(
      child: SizedBox(
        width: 340,
        height: 340,
        child: Stack(
          children: [
            // Corners Brackets
            CustomPaint(
              size: const Size(340, 340),
              painter: _ScannerFramePainter(
                color: const Color(0xFFAACCFF), // Luminous light blue
              ),
            ),

            // Animated Scanning Line
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Positioned(
                  top: 340 * _animationController.value,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFAACCFF).withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFAACCFF).withOpacity(0.05),
                          const Color(0xFFAACCFF),
                          const Color(0xFFAACCFF).withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),

            // Top Header Row
            const Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Scan User Profile QR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Manrope',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Align the user\'s QR code within the frame.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),
            const SizedBox(height: 120), // Bottom navbar clearance
          ],
        ),
      ),
    );
  }
}

class _ScannerFramePainter extends CustomPainter {
  final Color color;

  _ScannerFramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Subtle Grid
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final cellWidth = size.width / 3;
    final cellHeight = size.height / 3;

    for (int i = 1; i <= 2; i++) {
      // Vertical lines
      canvas.drawLine(
        Offset(cellWidth * i, 0),
        Offset(cellWidth * i, size.height),
        gridPaint,
      );
      // Horizontal lines
      canvas.drawLine(
        Offset(0, cellHeight * i),
        Offset(size.width, cellHeight * i),
        gridPaint,
      );
    }

    // 2. Draw Center QR Icon Placeholder
    final iconPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round;

    const iconSize = 48.0;
    final iconRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: iconSize,
      height: iconSize,
    );

    // Outer Border
    canvas.drawRRect(
      RRect.fromRectAndRadius(iconRect, const Radius.circular(8)),
      iconPaint,
    );

    // Inner Square dots
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromLTRBR(
        iconRect.left + 8,
        iconRect.top + 8,
        iconRect.left + 16,
        iconRect.top + 16,
        const Radius.circular(2),
      ),
      dotPaint,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
        iconRect.right - 16,
        iconRect.top + 8,
        iconRect.right - 8,
        iconRect.top + 16,
        const Radius.circular(2),
      ),
      dotPaint,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
        iconRect.left + 8,
        iconRect.bottom - 16,
        iconRect.left + 16,
        iconRect.bottom - 8,
        const Radius.circular(2),
      ),
      dotPaint,
    );

    // Abstract bottom right shapes
    canvas.drawRect(
      Rect.fromLTRB(
        iconRect.right - 16,
        iconRect.bottom - 16,
        iconRect.right - 12,
        iconRect.bottom - 12,
      ),
      dotPaint,
    );
    canvas.drawRect(
      Rect.fromLTRB(
        iconRect.right - 12,
        iconRect.bottom - 12,
        iconRect.right - 8,
        iconRect.bottom - 8,
      ),
      dotPaint,
    );

    // 3. Draw Corner Brackets with Glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6); // Glow effect

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    const cornerLength = 48.0;
    const radius = 40.0; // Matched with cutout radius

    final path = Path();

    // Top Left
    path.moveTo(0, cornerLength);
    path.lineTo(0, radius);
    path.arcToPoint(
      const Offset(radius, 0),
      radius: const Radius.circular(radius),
    );
    path.lineTo(cornerLength, 0);

    // Top Right
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: const Radius.circular(radius),
    );
    path.lineTo(size.width, cornerLength);

    // Bottom Right
    path.moveTo(size.width, size.height - cornerLength);
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: const Radius.circular(radius),
    );
    path.lineTo(size.width - cornerLength, size.height);

    // Bottom Left
    path.moveTo(cornerLength, size.height);
    path.lineTo(radius, size.height);
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: const Radius.circular(radius),
    );
    path.lineTo(0, size.height - cornerLength);

    // Draw Glow
    canvas.drawPath(path, glowPaint);
    // Draw Sharp Stroke
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
