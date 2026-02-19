import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'ball_bowl_world.dart';

/// Main game class extending Forge2DGame.
/// Sets up the physics world with gravity, zoom, and camera.
class BallBowlGame extends Forge2DGame {
  BallBowlGame()
      : super(
          gravity: Vector2(0, 10.0), // Positive Y = downward in Forge2DGame
          zoom: 10.0,
          world: BallBowlWorld(),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Center the camera on the world origin
    camera.viewfinder.anchor = Anchor.center;

    // Add a full-screen tap handler overlay to the camera viewport
    camera.viewport.add(TapHandler(ballBowlWorld: world as BallBowlWorld));
  }
}

/// Full-screen tap handler component added to the camera viewport.
/// Detects left/right screen taps and applies impulses to the pendulum ball.
class TapHandler extends Component with TapCallbacks, HasGameReference<BallBowlGame> {
  final BallBowlWorld ballBowlWorld;

  TapHandler({required this.ballBowlWorld});

  @override
  bool containsLocalPoint(Vector2 point) => true; // Captures all taps

  @override
  void onTapDown(TapDownEvent event) {
    final screenWidth = game.size.x;
    const impulseStrength = 30.0;

    if (event.localPosition.x < screenWidth / 2) {
      // Tapped on the left side
      ballBowlWorld.metallicBall
          .applySwingImpulse(Vector2(-impulseStrength, 0));
    } else {
      // Tapped on the right side
      ballBowlWorld.metallicBall
          .applySwingImpulse(Vector2(impulseStrength, 0));
    }
  }
}
