import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

/// Static anchor point at the top center of the screen.
/// This is the pivot/hinge from which the pendulum hangs.
class AnchorPoint extends BodyComponent {
  final Vector2 initialPosition;

  AnchorPoint({required this.initialPosition});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: initialPosition,
      userData: this,
    );

    final body = world.createBody(bodyDef);

    // Small circle fixture for the anchor bolt
    final shape = CircleShape()..radius = 0.3;
    final fixtureDef = FixtureDef(shape)
      ..density = 0.0
      ..friction = 0.0
      ..restitution = 0.0;

    body.createFixture(fixtureDef);
    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // --- Anchor bracket (metallic rectangular mounting plate) ---
    final bracketPaint = Paint()
      ..shader = Gradient.linear(
        Offset(-0.8, -0.2),
        Offset(0.8, 0.2),
        [
          const Color(0xFFD4D4D8), // metal-light
          const Color(0xFF94A3B8),
          const Color(0xFF52525B), // metal-dark
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: 1.6, height: 0.4),
      bracketPaint,
    );

    // --- Anchor bolt (center circle) ---
    final boltPaint = Paint()
      ..shader = Gradient.radial(
        const Offset(-0.05, -0.05),
        0.3,
        [
          const Color(0xFFE2E8F0), // bright highlight
          const Color(0xFF94A3B8),
          const Color(0xFF475569), // dark edge
        ],
        [0.0, 0.4, 1.0],
      );
    canvas.drawCircle(Offset.zero, 0.3, boltPaint);

    // Bolt cross detail
    final crossPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 0.06
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(-0.15, 0), const Offset(0.15, 0), crossPaint);
    canvas.drawLine(const Offset(0, -0.15), const Offset(0, 0.15), crossPaint);
  }
}
