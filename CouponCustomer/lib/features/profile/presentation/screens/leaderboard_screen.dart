import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/leaderboard_section.dart';
import 'dart:math';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    // Play the animation automatically when screen opens
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dsSurfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: AppColors.dsSurfaceContainerLowest,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.dsOnSurface),
        title: Text(
          'Leaderboard',
          style: AppTextStyles.dsTitleLg,
        ),
      ),
      body: Stack(
        children: [
          const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: LeaderboardSection(),
            ),
          ),
          
          // Left side luxurious confetti
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 4, // Down and Right
              maxBlastForce: 20,
              minBlastForce: 5,
              emissionFrequency: 0.02,
              numberOfParticles: 15,
              gravity: 0.05, // Slower, more elegant fall
              createParticlePath: drawStar,
              colors: const [
                Color(0xFFFFD700), // Gold
                Color(0xFFC0C0C0), // Silver
                Color(0xFFE5E4E2), // Platinum
                Color(0xFFB76E79), // Rose Gold
                Colors.white,
              ],
            ),
          ),
          
          // Right side luxurious confetti
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3 * pi / 4, // Down and Left
              maxBlastForce: 20,
              minBlastForce: 5,
              emissionFrequency: 0.02,
              numberOfParticles: 15,
              gravity: 0.05,
              createParticlePath: drawStar,
              colors: const [
                Color(0xFFFFD700),
                Color(0xFFC0C0C0),
                Color(0xFFE5E4E2),
                Color(0xFFB76E79),
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
