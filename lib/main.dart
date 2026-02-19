import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/ball_bowl_game.dart';

void main() {
  runApp(const BallBowlApp());
}

class BallBowlApp extends StatelessWidget {
  const BallBowlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ball & Bowl',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF262626), // background-dark
        fontFamily: 'Orbitron',
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- Concrete pattern background ---
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF303030),
                  Color(0xFF1A1A1A),
                  Color(0xFF0D0D0D),
                ],
              ),
            ),
          ),

          // --- Game Canvas ---
          GameWidget<BallBowlGame>(
            game: BallBowlGame(),
            backgroundBuilder: (context) => Container(
              color: Colors.transparent,
            ),
          ),

          // --- HUD Overlay ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            color: Color(0xFFCBD5E1), // slate-300
                            fontFamily: 'Orbitron',
                          ),
                          children: [
                            TextSpan(text: 'LEVEL '),
                            TextSpan(
                              text: '0',
                              style: TextStyle(
                                color: Color(0xFF84CC16), // primary lime
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'INDUSTRIAL SECTOR A',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 3,
                          color: Color(0xFF64748B), // slate-500
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ],
                  ),

                  // Control buttons
                  Row(
                    children: [
                      _buildControlButton(Icons.refresh),
                      const SizedBox(width: 12),
                      _buildControlButton(Icons.pause),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // --- Bottom hint text ---
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x80000000),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFF475569),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'TAP TO SWING PENDULUM',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2,
                    color: Color(0xFF94A3B8),
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildControlButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF334155), // slate-700
        boxShadow: [
          // Metallic shadow from Stitch design
          const BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0x66FFFFFF),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 18,
        color: const Color(0xFFCBD5E1), // slate-300
      ),
    );
  }
}
