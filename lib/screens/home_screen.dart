import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Container(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title with glow effect from Figma
                Text(
                  'HOLY FLEX',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    shadows: [
                      Shadow(
                        blurRadius: 20,
                        color: AppTheme.cyanAccent.withOpacity(0.5),
                        offset: const Offset(0, 0),
                      ),
                      const Shadow(
                        blurRadius: 40,
                        color: AppTheme.cyanAccent,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bible Trivia Challenge',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 80),

                // Play Button
                _buildMenuButton(
                  context,
                  icon: Icons.play_arrow_rounded,
                  label: 'Play Genesis Level',
                  color: AppTheme.cyanAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Leaderboard Button
                _buildMenuButton(
                  context,
                  icon: Icons.leaderboard,
                  label: 'Leaderboard',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeaderboardScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Challenge Friend Button (Coming Soon)
                _buildMenuButton(
                  context,
                  icon: Icons.people,
                  label: 'Challenge Friend',
                  color: Colors.blue.shade300,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  isDisabled: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.shade600 : color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
