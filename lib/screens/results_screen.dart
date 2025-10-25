import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../services/leaderboard_service.dart';
import 'leaderboard_screen.dart';
import 'home_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _saveScore();
  }

  Future<void> _saveScore() async {
    final gameService = Provider.of<GameService>(context, listen: false);
    final session = gameService.currentSession;

    if (session == null || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _leaderboardService.saveScore(session, 'Player');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving score: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade700,
              Colors.deepPurple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<GameService>(
            builder: (context, gameService, child) {
              final session = gameService.currentSession;
              if (session == null) {
                return const Center(
                  child: Text(
                    'No game session found',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final totalQuestions = gameService.questions?.length ?? 0;
              final correctAnswers = session.correctAnswers;
              final totalScore = session.totalScore;
              final accuracy = totalQuestions > 0
                  ? (correctAnswers / totalQuestions * 100).round()
                  : 0;

              // Calculate speed bonus
              final basePoints = correctAnswers * 1000;
              final speedBonus = totalScore - basePoints;

              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'GAME COMPLETE!',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 60),

                      // Total Score Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'TOTAL SCORE',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$totalScore',
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade700,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Divider(color: Colors.grey.shade300),
                            const SizedBox(height: 24),

                            // Stats
                            _buildStatRow(
                              'Correct Answers',
                              '$correctAnswers / $totalQuestions',
                              Colors.green,
                            ),
                            const SizedBox(height: 16),
                            _buildStatRow(
                              'Accuracy',
                              '$accuracy%',
                              Colors.blue,
                            ),
                            const SizedBox(height: 16),
                            _buildStatRow(
                              'Base Points',
                              '$basePoints',
                              Colors.orange,
                            ),
                            const SizedBox(height: 16),
                            _buildStatRow(
                              'Speed Bonus',
                              '+$speedBonus',
                              Colors.amber,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Play Again Button
                      _buildActionButton(
                        icon: Icons.replay,
                        label: 'Play Again',
                        color: Colors.green,
                        onTap: () {
                          gameService.resetGame();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // View Leaderboard Button
                      _buildActionButton(
                        icon: Icons.leaderboard,
                        label: 'View Leaderboard',
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

                      const SizedBox(height: 16),

                      // Home Button
                      _buildActionButton(
                        icon: Icons.home,
                        label: 'Home',
                        color: Colors.blue,
                        onTap: () {
                          gameService.resetGame();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
