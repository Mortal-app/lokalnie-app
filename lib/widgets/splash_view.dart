import 'package:flutter/material.dart';

import '../app_info.dart';
import '../theme/widzew_colors.dart';
import 'announcement_card_skeleton.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: WidzewColors.red,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidzewLMark(),
              SizedBox(height: 24),
              Text(
                AppInfo.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(height: 8),
              Text(
                AppInfo.tagline,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 32),
              AnnouncementListSkeleton(),
            ],
          ),
        ),
      ),
    );
  }
}

class WidzewLMark extends StatelessWidget {
  final double size;

  const WidzewLMark({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(painter: _LLogoPainter()),
    );
  }
}

class _LLogoPainter extends CustomPainter {
  const _LLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = WidzewColors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    const thicknessRatio = 0.18;
    const barWidthRatio = 0.44;
    const barHeightRatio = 0.58;
    final thickness = size.width * thicknessRatio;
    final barWidth = size.width * barWidthRatio;
    final barHeight = size.height * barHeightRatio;
    final left = (size.width - barWidth) / 2 + size.width * 0.04;
    final top = (size.height - barHeight) / 2 + size.height * 0.03;
    final radius = Radius.circular(size.width * 0.045);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, thickness, barHeight),
        radius,
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top + barHeight - thickness, barWidth, thickness),
        radius,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
