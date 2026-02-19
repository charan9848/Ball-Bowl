import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

/// Static bowl/catcher at the bottom of the screen.
/// Built from 3 polygon fixtures (left wall, floor, right wall) to form
/// a concave U-shape that can catch falling balls.
class Bowl extends BodyComponent {
  final Vector2 initialPosition;
  final double width;
  final double height;
  final double wallThickness;

  Bowl({
    required this.initialPosition,
    this.width = 4.0,
    this.height = 2.8,
    this.wallThickness = 0.3,
  });

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: initialPosition,
      userData: this,
    );

    final body = world.createBody(bodyDef);
    final halfW = width / 2;

    // --- Left wall ---
    final leftWall = PolygonShape()
      ..setAsBox(
        wallThickness / 2,
        height / 2,
        Vector2(-halfW + wallThickness / 2, -height / 2),
        0,
      );
    body.createFixture(FixtureDef(leftWall)
      ..density = 0
      ..friction = 0.8
      ..restitution = 0.1);

    // --- Floor ---
    final floor = PolygonShape()
      ..setAsBox(
        halfW,
        wallThickness / 2,
        Vector2(0, 0),
        0,
      );
    body.createFixture(FixtureDef(floor)
      ..density = 0
      ..friction = 0.8
      ..restitution = 0.1);

    // --- Right wall ---
    final rightWall = PolygonShape()
      ..setAsBox(
        wallThickness / 2,
        height / 2,
        Vector2(halfW - wallThickness / 2, -height / 2),
        0,
      );
    body.createFixture(FixtureDef(rightWall)
      ..density = 0
      ..friction = 0.8
      ..restitution = 0.1);

    return body;
  }

  @override
  void render(Canvas canvas) {
    final halfW = width / 2;

    // --- Rust-textured bowl body ---
    // TODO: Replace with sprite: canvas.drawImage(bowlSprite, ...)

    // Main bowl fill (rusty brown gradient)
    final bowlPath = Path()
      ..moveTo(-halfW, -height)
      ..lineTo(-halfW, 0)
      ..lineTo(halfW, 0)
      ..lineTo(halfW, -height)
      ..close();

    final fillPaint = Paint()
      ..shader = Gradient.linear(
        Offset(0, -height),
        Offset(0, 0),
        [
          const Color(0xFF5D4037), // Brown from Stitch design
          const Color(0xFF3E2723), // Darker brown
        ],
      );
    canvas.drawPath(bowlPath, fillPaint);

    // --- Rust texture overlay (subtle cross-hatch lines) ---
    final rustPaint = Paint()
      ..color = const Color(0x20000000)
      ..strokeWidth = 0.08
      ..style = PaintingStyle.stroke;
    for (double y = -height; y < 0; y += 0.4) {
      canvas.drawLine(Offset(-halfW, y), Offset(halfW, y + 0.3), rustPaint);
    }

    // --- Bowl rim (elliptical top edge) ---
    final rimPaint = Paint()
      ..shader = Gradient.linear(
        Offset(-halfW, -height),
        Offset(halfW, -height),
        [
          const Color(0xFF5D4037),
          const Color(0xFF795548),
          const Color(0xFF5D4037),
        ],
        [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.2;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, -height),
        width: width,
        height: 0.6,
      ),
      rimPaint,
    );

    // Rim fill (dark inside)
    final rimFillPaint = Paint()
      ..color = const Color(0xFF2E1D15);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, -height),
        width: width - 0.2,
        height: 0.4,
      ),
      rimFillPaint,
    );

    // --- Side highlights for 3D depth ---
    final highlightPaint = Paint()
      ..shader = Gradient.linear(
        Offset(-halfW, -height / 2),
        Offset(-halfW + 0.5, -height / 2),
        [
          const Color(0x30FFFFFF),
          const Color(0x00FFFFFF),
        ],
      );
    canvas.drawRect(
      Rect.fromLTRB(-halfW, -height, -halfW + 0.4, 0),
      highlightPaint,
    );
  }
}
