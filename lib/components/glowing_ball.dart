import 'dart:math';
import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

/// Static glowing target ball. Starts as static; switches to dynamic
/// when hit by the MetallicBall so it falls under gravity.
class GlowingBall extends BodyComponent with ContactCallbacks {
  final Vector2 initialPosition;
  final double radius;
  final Color glowColor;
  bool _activated = false;
  double _pulsePhase = 0;

  GlowingBall({
    required this.initialPosition,
    this.radius = 0.5,
    this.glowColor = const Color(0xFF84CC16), // Lime green from Stitch design
  });

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: initialPosition,
      userData: this,
    );

    final body = world.createBody(bodyDef);

    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape)
      ..density = 2.0
      ..friction = 0.5
      ..restitution = 0.3;

    body.createFixture(fixtureDef);
    return body;
  }

  /// Called by MetallicBall on collision — switches this ball to dynamic.
  void activateGravity() {
    if (!_activated) {
      _activated = true;
      body.setType(BodyType.dynamic);
    }
  }

  bool get isActivated => _activated;

  @override
  void update(double dt) {
    super.update(dt);
    // Pulsing animation for the glow effect
    if (!_activated) {
      _pulsePhase += dt * 2.5;
    }
  }

  @override
  void render(Canvas canvas) {
    // TODO: Replace with sprite: canvas.drawImage(glowingBallSprite, ...)

    final pulseScale = _activated ? 1.0 : 1.0 + 0.15 * sin(_pulsePhase);
    final currentRadius = radius * pulseScale;

    // --- Outer glow aura ---
    final glowPaint = Paint()
      ..shader = Gradient.radial(
        Offset.zero,
        currentRadius * 2.5,
        [
          glowColor.withValues(alpha: 0.4),
          glowColor.withValues(alpha: 0.15),
          glowColor.withValues(alpha: 0.0),
        ],
        [0.0, 0.5, 1.0],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset.zero, currentRadius * 2.0, glowPaint);

    // --- Main ball body ---
    final ballPaint = Paint()
      ..shader = Gradient.radial(
        Offset(-currentRadius * 0.2, -currentRadius * 0.2),
        currentRadius * 1.2,
        [
          const Color(0xFFD9F99D), // Light lime
          glowColor,               // Primary lime
          const Color(0xFF65A30D), // Darker lime
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawCircle(Offset.zero, currentRadius, ballPaint);

    // --- Glass-like highlight ---
    final highlightPaint = Paint()
      ..shader = Gradient.radial(
        Offset(-currentRadius * 0.3, -currentRadius * 0.35),
        currentRadius * 0.5,
        [
          const Color(0x80FFFFFF),
          const Color(0x00FFFFFF),
        ],
      );
    canvas.drawCircle(
      Offset(-currentRadius * 0.2, -currentRadius * 0.25),
      currentRadius * 0.4,
      highlightPaint,
    );

    // --- Border ring ---
    final borderPaint = Paint()
      ..color = glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.06;
    canvas.drawCircle(Offset.zero, currentRadius, borderPaint);
  }
}
