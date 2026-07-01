import 'dart:math' as math;
import 'package:flutter/material.dart';

/// يعرض احتفال (confetti) متطاير لثوانٍ معدودة فوق الشاشة.
void showCelebration(BuildContext context) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _ConfettiLayer(onDone: () => entry.remove()),
  );
  overlay.insert(entry);
}

class _ConfettiLayer extends StatefulWidget {
  final VoidCallback onDone;
  const _ConfettiLayer({required this.onDone});

  @override
  State<_ConfettiLayer> createState() => _ConfettiLayerState();
}

class _ConfettiLayerState extends State<_ConfettiLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  final _rng = math.Random();
  late final List<_Particle> _particles;

  static const _colors = [
    Color(0xFF0288D1),
    Color(0xFF4FC3F7),
    Color(0xFF43A047),
    Color(0xFFFB8C00),
    Color(0xFFE53935),
    Color(0xFFFFD600),
  ];

  @override
  void initState() {
    super.initState();
    _particles = List.generate(60, (_) {
      return _Particle(
        x: _rng.nextDouble(),
        startY: -0.1 - _rng.nextDouble() * 0.3,
        size: 6 + _rng.nextDouble() * 8,
        color: _colors[_rng.nextInt(_colors.length)],
        drift: (_rng.nextDouble() - 0.5) * 0.3,
        rotationSpeed: (_rng.nextDouble() - 0.5) * 12,
        fallSpeed: 0.8 + _rng.nextDouble() * 0.6,
      );
    });
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
      ..forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(_particles, _c.value),
          );
        },
      ),
    );
  }
}

class _Particle {
  final double x, startY, size, drift, rotationSpeed, fallSpeed;
  final Color color;
  _Particle({
    required this.x,
    required this.startY,
    required this.size,
    required this.color,
    required this.drift,
    required this.rotationSpeed,
    required this.fallSpeed,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double t; // 0..1

  _ConfettiPainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final y = (p.startY + t * p.fallSpeed) * size.height;
      final x = (p.x + math.sin(t * 6 + p.x * 10) * p.drift) * size.width;
      if (y < -20 || y > size.height + 20) continue;
      paint.color = p.color.withValues(alpha: (1 - t).clamp(0.0, 1.0));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * p.rotationSpeed);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.t != t;
}
