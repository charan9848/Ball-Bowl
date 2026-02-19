import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

/// Screen boundary walls — thin static rectangles on all 4 edges.
/// The bottom edge also acts as the industrial "floor plate" with
/// screw/bolt details matching the Stitch design.
class Boundaries extends BodyComponent {
  final Vector2 screenSize; // In world coordinates

  Boundaries({required this.screenSize});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: Vector2.zero(),
      userData: this,
    );

    final body = world.createBody(bodyDef);
    final halfW = screenSize.x / 2;
    final halfH = screenSize.y / 2;
    const thickness = 0.5;

    // Left wall
    body.createFixture(FixtureDef(
      PolygonShape()
        ..setAsBox(thickness / 2, halfH, Vector2(-halfW - thickness / 2, 0), 0),
    )..friction = 0.3);

    // Right wall
    body.createFixture(FixtureDef(
      PolygonShape()
        ..setAsBox(thickness / 2, halfH, Vector2(halfW + thickness / 2, 0), 0),
    )..friction = 0.3);

    // Floor
    body.createFixture(FixtureDef(
      PolygonShape()
        ..setAsBox(halfW + thickness, thickness / 2, Vector2(0, halfH + thickness / 2), 0),
    )..friction = 0.8);

    // Ceiling
    body.createFixture(FixtureDef(
      PolygonShape()
        ..setAsBox(halfW + thickness, thickness / 2, Vector2(0, -halfH - thickness / 2), 0),
    )..friction = 0.3);

    return body;
  }

  @override
  void render(Canvas canvas) {
    final halfW = screenSize.x / 2;
    final halfH = screenSize.y / 2;

    // --- Industrial floor plate ---
    final floorPaint = Paint()
      ..shader = Gradient.linear(
        Offset(-halfW, halfH - 0.5),
        Offset(-halfW, halfH + 0.5),
        [
          const Color(0xFF94A3B8), // slate-400
          const Color(0xFF64748B), // slate-500
          const Color(0xFF475569), // slate-600
        ],
        [0.0, 0.3, 1.0],
      );
    canvas.drawRect(
      Rect.fromLTRB(-halfW, halfH - 0.3, halfW, halfH + 0.5),
      floorPaint,
    );

    // Floor top edge line (bolt line)
    final edgePaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 0.1;
    canvas.drawLine(
      Offset(-halfW, halfH - 0.3),
      Offset(halfW, halfH - 0.3),
      edgePaint,
    );

    // Screw bolts on the floor
    final screwPaint = Paint()..color = const Color(0xFF64748B);
    final screwHighlight = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 0.04
      ..style = PaintingStyle.stroke;

    for (double x = -halfW + 2; x < halfW; x += 4) {
      canvas.drawCircle(Offset(x, halfH + 0.1), 0.15, screwPaint);
      canvas.drawCircle(Offset(x, halfH + 0.1), 0.15, screwHighlight);
      // Cross pattern on screws
      final crossPaint = Paint()
        ..color = const Color(0xFF334155)
        ..strokeWidth = 0.03;
      canvas.drawLine(
        Offset(x - 0.08, halfH + 0.1),
        Offset(x + 0.08, halfH + 0.1),
        crossPaint,
      );
      canvas.drawLine(
        Offset(x, halfH + 0.02),
        Offset(x, halfH + 0.18),
        crossPaint,
      );
    }
  }
}
