import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';

class GameDashboardScreen extends StatelessWidget {
  const GameDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with HOLY FLEX title and profile icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'HOLY FLEX',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.white.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppTheme.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Stats cards row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.local_offer,
                        value: '5600 pts',
                        color: AppTheme.cyanAccent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.bolt,
                        value: '20 days',
                        color: const Color(0xFFFFD700), // Gold/yellow
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.emoji_events,
                        value: '6 Wins',
                        color: const Color(0xFF90EE90), // Light green
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Level selection area
                Center(
                  child: Column(
                    children: [
                      // Genesis level button (enabled)
                      _buildLevelButton(
                        context: context,
                        label: 'Genesis',
                        isEnabled: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GameScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Dotted line connector
                      _buildDottedLine(),
                      const SizedBox(height: 32),

                      // 1 Samuel 17 button (locked)
                      _buildLevelButton(
                        context: context,
                        label: '1 Samuel 17',
                        isEnabled: false,
                      ),
                      const SizedBox(height: 32),

                      // Another dotted line
                      _buildDottedLine(),
                      const SizedBox(height: 32),

                      // More levels coming soon
                      _buildLevelButton(
                        context: context,
                        label: 'More Levels',
                        subtitle: 'Coming Soon',
                        isEnabled: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black87, size: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton({
    required BuildContext context,
    required String label,
    String? subtitle,
    required bool isEnabled,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isEnabled
                ? [
                    AppTheme.cyanAccent,
                    AppTheme.cyanAccent.withOpacity(0.7),
                  ]
                : [
                    AppTheme.mediumGray.withOpacity(0.3),
                    AppTheme.mediumGray.withOpacity(0.1),
                  ],
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppTheme.cyanAccent.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isEnabled
                          ? AppTheme.darkBackground
                          : AppTheme.mediumGray,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isEnabled
                            ? AppTheme.darkBackground.withOpacity(0.7)
                            : AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!isEnabled)
              Positioned(
                top: 20,
                right: 20,
                child: Icon(
                  Icons.lock,
                  color: AppTheme.mediumGray,
                  size: 32,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDottedLine() {
    return SizedBox(
      height: 40,
      child: Column(
        children: List.generate(
          5,
          (index) => Expanded(
            child: Container(
              width: 2,
              margin: const EdgeInsets.symmetric(vertical: 2),
              color: AppTheme.mediumGray.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
