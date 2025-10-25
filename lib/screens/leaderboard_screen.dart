import 'package:flutter/material.dart';
import '../services/leaderboard_service.dart';
import '../models/leaderboard_entry.dart';
import '../theme/app_theme.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();
  List<LeaderboardEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    try {
      final entries = await _leaderboardService.getLeaderboard('genesis');
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading leaderboard: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
        backgroundColor: AppTheme.darkBackground,
        foregroundColor: AppTheme.cyanAccent,
        elevation: 0,
      ),
      backgroundColor: AppTheme.darkBackground,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.cyanAccent),
            )
          : _entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.leaderboard_outlined,
                        size: 80,
                        color: AppTheme.cyanAccent.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No scores yet!',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppTheme.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Play the game to see your score here',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'GENESIS LEVEL',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.cyanAccent,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Top ${_entries.length} Players',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Podium for top 3
                    if (_entries.length >= 3) _buildPodium(),

                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _entries.length > 3 ? _entries.length - 3 : 0,
                        itemBuilder: (context, index) {
                          return _buildLeaderboardEntry(
                            _entries[index + 3],
                            index + 4,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildPodium() {
    if (_entries.length < 3) return const SizedBox();

    final first = _entries[0];
    final second = _entries.length > 1 ? _entries[1] : null;
    final third = _entries.length > 2 ? _entries[2] : null;

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 2nd place
          if (second != null)
            Expanded(
              child: _buildPodiumPlace(
                entry: second,
                rank: 2,
                color: Colors.grey,
                height: 120,
              ),
            ),
          const SizedBox(width: 8),
          // 1st place
          Expanded(
            child: _buildPodiumPlace(
              entry: first,
              rank: 1,
              color: Colors.amber,
              height: 160,
            ),
          ),
          const SizedBox(width: 8),
          // 3rd place
          if (third != null)
            Expanded(
              child: _buildPodiumPlace(
                entry: third,
                rank: 3,
                color: Colors.brown.shade300,
                height: 100,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace({
    required LeaderboardEntry entry,
    required int rank,
    required Color color,
    required double height,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar circle with rank
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: AppTheme.cyanAccent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBackground,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          entry.username,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppTheme.white,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        Text(
          '${entry.score}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        // Podium block
        Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color,
                color.withOpacity(0.6),
              ],
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            border: Border.all(
              color: AppTheme.cyanAccent.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.emoji_events,
              color: AppTheme.darkBackground.withOpacity(0.3),
              size: 32,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardEntry(LeaderboardEntry entry, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.mediumGray.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 50,
            child: Text(
              '#$rank',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.cyanAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 16),

          // Username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(entry.completedAt),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),

          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.cyanAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.cyanAccent,
                width: 1,
              ),
            ),
            child: Text(
              '${entry.score}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.cyanAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
