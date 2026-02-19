import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'glowing_ball.dart';

/// Dynamic metallic ball that swings as a pendulum.
/// Uses ContactCallbacks to detect collisions with GlowingBall targets.
class MetallicBall extends BodyComponent with ContactCallbacks {
  final Vector2 initialPosition;
  static const double radius = 0.8;

  MetallicBall({required this.initialPosition});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: initialPosition,
      userData: this,
      angularDamping: 0.3,
      linearDamping: 0.1,
    );

    final body = world.createBody(bodyDef);

    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape)
      ..density = 5.0
      ..friction = 0.3
      ..restitution = 0.4;

    body.createFixture(fixtureDef);
    return body;
  }

  /// Apply a swing impulse to the metallic ball (called from tap handler).
  void applySwingImpulse(Vector2 impulse) {
    body.applyLinearImpulse(impulse);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is GlowingBall) {
      // When the metallic ball hits a glowing ball, make it dynamic (fall).
      other.activateGravity();
    }
  }

  @override
  void render(Canvas canvas) {
    // --- Main metallic ball with gradient ---
    // TODO: Replace with sprite: canvas.drawImage(metallicBallSprite, ...)
    final metallicPaint = Paint()
      ..shader = Gradient.radial(
        const Offset(-0.2, -0.25), // Light source top-left
        radius * 2.2,
        [
          const Color(0xFFE2E8F0), // Bright highlight
          const Color(0xFFA0AEC0), // Mid metallic
          const Color(0xFF64748B), // Slate
          const Color(0xFF475569), // Dark edge
        ],
        [0.0, 0.3, 0.7, 1.0],
      );
    canvas.drawCircle(Offset.zero, radius, metallicPaint);

    // --- Specular highlight (top-left) ---
    final highlightPaint = Paint()
      ..shader = Gradient.radial(
        const Offset(-0.25, -0.3),
        radius * 0.5,
        [
          const Color(0x99FFFFFF), // Bright white
          const Color(0x00FFFFFF), // Fade out
        ],
      );
    canvas.drawCircle(const Offset(-0.25, -0.3), radius * 0.45, highlightPaint);

    // --- Shadow/depth at bottom-right ---
    final shadowPaint = Paint()
      ..shader = Gradient.radial(
        const Offset(0.2, 0.25),
        radius * 0.7,
        [
          const Color(0x33000000),
          const Color(0x00000000),
        ],
      );
    canvas.drawCircle(const Offset(0.2, 0.25), radius * 0.6, shadowPaint);

    // --- Inner circle detail (concentric ring) ---
    final innerRingPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.05;
    canvas.drawCircle(Offset.zero, radius * 0.5, innerRingPaint);
  }
}
