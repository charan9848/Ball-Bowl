import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'anchor_point.dart';
import 'metallic_ball.dart';

/// Visual-only component that renders the pendulum rope/rod
/// between the AnchorPoint and the MetallicBall each frame.
/// This is NOT a physics body — purely cosmetic.
class PendulumRope extends Component with HasWorldReference<Forge2DWorld> {
  final AnchorPoint anchor;
  final MetallicBall ball;

  PendulumRope({required this.anchor, required this.ball});

  @override
  void render(Canvas canvas) {
    final anchorPos = anchor.body.position;
    final ballPos = ball.body.position;

    // --- Main rope/rod ---
    // Metallic gradient rod matching the Stitch design's gradient wire
    final rodPaint = Paint()
      ..shader = Gradient.linear(
        Offset(anchorPos.x - 0.05, anchorPos.y),
        Offset(anchorPos.x + 0.05, anchorPos.y),
        [
          const Color(0xFF94A3B8), // slate-400
          const Color(0xFFCBD5E1), // slate-300 (center highlight)
          const Color(0xFF64748B), // slate-500
        ],
        [0.0, 0.4, 1.0],
      )
      ..strokeWidth = 0.1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(anchorPos.x, anchorPos.y),
      Offset(ballPos.x, ballPos.y),
      rodPaint,
    );

    // --- Thin shadow line for depth ---
    final shadowPaint = Paint()
      ..color = const Color(0x40000000)
      ..strokeWidth = 0.14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(anchorPos.x + 0.03, anchorPos.y + 0.03),
      Offset(ballPos.x + 0.03, ballPos.y + 0.03),
      shadowPaint,
    );
  }
}
