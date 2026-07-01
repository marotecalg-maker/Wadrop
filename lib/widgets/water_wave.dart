import 'dart:math' as math;
import 'package:flutter/material.dart';

/// دائرة فيها ماء متموّج يرتفع حسب نسبة التقدّم. كتدعم الوضع الداكن.
class WaterWave extends StatefulWidget {
  final double progress; // 0.0 - 1.0
  final int currentMl;
  final int goalMl;
  final double size;
  final bool dark;
  final String unit;

  const WaterWave({
    super.key,
    required this.progress,
    required this.currentMl,
    required this.goalMl,
    this.size = 240,
    this.dark = false,
    this.unit = 'ml',
  });

  @override
  State<WaterWave> createState() => _WaterWaveState();
}

class _WaterWaveState extends State<WaterWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emptyColor =
        widget.dark ? const Color(0xFF1B2A38) : const Color(0xFFE1F5FE);
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: widget.progress),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, animatedProgress, _) {
          return AnimatedBuilder(
            animation: _waveController,
            builder: (context, _) {
              final textOnWater = animatedProgress > 0.5;
              final mainText = textOnWater
                  ? Colors.white
                  : (widget.dark
                      ? const Color(0xFF4FC3F7)
                      : const Color(0xFF0277BD));
              return CustomPaint(
                painter: _WavePainter(
                  progress: animatedProgress,
                  wavePhase: _waveController.value * 2 * math.pi,
                  emptyColor: emptyColor,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(animatedProgress * 100).round()}%',
                        style: TextStyle(
                          fontSize: widget.size * 0.16,
                          fontWeight: FontWeight.bold,
                          color: mainText,
                        ),
                      ),
                      Text(
                        '${widget.currentMl} / ${widget.goalMl} ${widget.unit}',
                        style: TextStyle(
                          fontSize: widget.size * 0.06,
                          fontWeight: FontWeight.w600,
                          color: textOnWater ? Colors.white70 : mainText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  final double wavePhase;
  final Color emptyColor;

  _WavePainter({
    required this.progress,
    required this.wavePhase,
    required this.emptyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    canvas.save();
    canvas.clipPath(
        Path()..addOval(Rect.fromCircle(center: center, radius: radius)));

    canvas.drawCircle(center, radius, Paint()..color = emptyColor);

    final waterLevel = size.height * (1 - progress);
    const waveHeight = 10.0;

    _drawWave(canvas, size, waterLevel, wavePhase, waveHeight,
        const Color(0xFF4FC3F7).withValues(alpha: 0.55));
    _drawWave(canvas, size, waterLevel, wavePhase + math.pi / 2,
        waveHeight * 0.7, const Color(0xFF0288D1).withValues(alpha: 0.9));

    canvas.restore();

    canvas.drawCircle(
      center,
      radius - 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = const Color(0xFF81D4FA),
    );
  }

  void _drawWave(Canvas canvas, Size size, double level, double phase,
      double amplitude, Color color) {
    final path = Path()..moveTo(0, level);
    for (double x = 0; x <= size.width; x++) {
      final y = level +
          amplitude * math.sin((x / size.width * 2 * math.pi) + phase);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) =>
      old.progress != progress ||
      old.wavePhase != wavePhase ||
      old.emptyColor != emptyColor;
}
