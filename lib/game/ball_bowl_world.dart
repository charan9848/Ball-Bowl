import 'package:flame_forge2d/flame_forge2d.dart';
import '../components/anchor_point.dart';
import '../components/metallic_ball.dart';
import '../components/glowing_ball.dart';
import '../components/bowl.dart';
import '../components/boundaries.dart';
import '../components/pendulum_rope.dart';

/// The Forge2D physics world that spawns and manages all game entities.
class BallBowlWorld extends Forge2DWorld {
  late MetallicBall metallicBall;

  // World size in Forge2D units (with default zoom of 10, this spans the screen)
  static const double worldWidth = 28.0;
  static const double worldHeight = 48.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // --- Screen boundaries ---
    final boundaries = Boundaries(
      screenSize: Vector2(worldWidth, worldHeight),
    );
    add(boundaries);

    // --- Anchor point at top center ---
    final anchorPosition = Vector2(0, -worldHeight / 2 + 4);
    final anchorPoint = AnchorPoint(initialPosition: anchorPosition);
    add(anchorPoint);

    // --- Metallic ball (pendulum bob) ---
    // Positioned below the anchor by the rope length
    const ropeLength = 12.0;
    final ballPosition = Vector2(0, anchorPosition.y + ropeLength);
    metallicBall = MetallicBall(initialPosition: ballPosition);
    add(metallicBall);

    // --- Pendulum rope (visual only) ---
    final rope = PendulumRope(anchor: anchorPoint, ball: metallicBall);
    add(rope);

    // --- RevoluteJoint connecting anchor to ball ---
    // Uses Future.delayed to let physics bodies initialize first
    await Future.delayed(Duration.zero);
    _createPendulumJoint(anchorPoint, metallicBall);

    // --- Glowing target balls (scattered mid-screen) ---
    final glowingPositions = [
      Vector2(-6, -4),
      Vector2(5, -2),
      Vector2(2, 3),
      Vector2(-4, 6),
    ];

    for (final pos in glowingPositions) {
      add(GlowingBall(
        initialPosition: pos,
        radius: 0.5 + (pos.x.abs() % 3) * 0.1, // Slightly varied sizes
      ));
    }

    // --- Three bowls at the bottom ---
    const bowlY = 20.0; // Near the bottom
    final bowlPositions = [
      Vector2(-8, bowlY),
      Vector2(0, bowlY),
      Vector2(8, bowlY),
    ];

    for (final pos in bowlPositions) {
      add(Bowl(initialPosition: pos));
    }
  }

  void _createPendulumJoint(AnchorPoint anchor, MetallicBall ball) {
    final jointDef = RevoluteJointDef()
      ..initialize(anchor.body, ball.body, anchor.body.position);
    createJoint(RevoluteJoint(jointDef));
  }
}
