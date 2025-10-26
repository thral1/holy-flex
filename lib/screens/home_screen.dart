import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildUserInfo(),
                  const SizedBox(height: 20),
                  _buildStatsRow(),
                ],
              ),
            ),
            Expanded(
              child: _buildLeaderboard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'HOLY FLEX',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: AppTheme.white,
            letterSpacing: 1.2,
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return const Text(
      'Harris, #12',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        color: AppTheme.white,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: const [
        Expanded(
          child: _StatChip(
            icon: Icons.local_offer_outlined,
            label: '5600 pts',
            background: Color(0xFFCBFDFF),
            foreground: Color(0xFF05211F),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            icon: Icons.bolt,
            label: '20 days',
            background: Color(0xFFF4F0D3),
            foreground: Color(0xFF846D07),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            icon: Icons.emoji_events_outlined,
            label: '6 Wins',
            background: Color(0xFFE1F6D0),
            foreground: Color(0xFF38763D),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboard() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildPodium(),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _buildLeaderboardEntry(4, 'Anna', 5600, 'assets/images/profile_4.png'),
              const SizedBox(height: 12),
              _buildLeaderboardEntry(5, 'Kacey', 4500, 'assets/images/profile_5.png'),
              const SizedBox(height: 12),
              _buildLeaderboardEntry(6, 'Michael', 3400, 'assets/images/profile_6.png'),
              const SizedBox(height: 12),
              _buildLeaderboardEntry(7, 'Jeremiah', 3200, 'assets/images/profile_7.png'),
              const SizedBox(height: 12),
              _buildLeaderboardEntry(8, 'June', 3100, 'assets/images/profile_8.png'),
              const SizedBox(height: 12),
              _buildLeaderboardEntry(9, 'Christopher', 2300, 'assets/images/profile_9.png'),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPodium() {
    return SizedBox(
      height: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodiumPlace(
            rank: 2,
            size: 70,
            imagePath: 'assets/images/profile_2.png',
          ),
          const SizedBox(width: 16),
          _buildPodiumPlace(
            rank: 1,
            size: 90,
            imagePath: 'assets/images/profile_1.png',
          ),
          const SizedBox(width: 16),
          _buildPodiumPlace(
            rank: 3,
            size: 70,
            imagePath: 'assets/images/profile_3.png',
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace({
    required int rank,
    required double size,
    required String imagePath,
  }) {
    Color getBorderColor() {
      switch (rank) {
        case 1:
          return const Color(0xFF9CB0B7);
        case 2:
          return Colors.white70;
        case 3:
          return Colors.white70;
        default:
          return Colors.white70;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Profile image
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: getBorderColor(),
                  width: 3,
                ),
                boxShadow: rank == 1
                    ? [
                        BoxShadow(
                          color: AppTheme.cyanAccent.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Rank badge
            Positioned(
              bottom: -4,
              left: size / 2 - 16,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: rank == 1
                      ? const Color(0xFFCBFDFF)
                      : Colors.white,
                  border: Border.all(
                    color: AppTheme.darkBackground,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: rank == 1
                          ? const Color(0xFF1C1C1C)
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaderboardEntry(int rank, String name, int points, String imageUrl) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Rank number
          Container(
            width: 24,
            child: Text(
              '$rank',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.white,
              ),
            ),
          ),
          // Points
          Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                color: Colors.white54,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '$points pts',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static List<Color> _getAvatarGradient(int rank) {
    final gradients = [
      [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],  // Purple gradient
      [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],  // Blue gradient
      [const Color(0xFF10B981), const Color(0xFF059669)],  // Green gradient
    ];
    return gradients[(rank - 1) % gradients.length];
  }

  static List<Color> _getAvatarGradientByRank(int rank) {
    final gradients = [
      [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],  // Purple
      [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],  // Blue
      [const Color(0xFF10B981), const Color(0xFF059669)],  // Green
      [const Color(0xFFEF4444), const Color(0xFFDC2626)],  // Red
      [const Color(0xFFF59E0B), const Color(0xFFD97706)],  // Orange
      [const Color(0xFF06B6D4), const Color(0xFF0891B2)],  // Cyan
    ];
    return gradients[(rank - 1) % gradients.length];
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: foreground, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
