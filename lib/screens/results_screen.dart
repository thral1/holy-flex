import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../services/game_service.dart';
import '../services/leaderboard_service.dart';
import '../theme/app_theme.dart';
import 'leaderboard_screen.dart';
import 'main_navigation.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  final LeaderboardService _leaderboardService = LeaderboardService();
  bool _isSaving = false;
  late final VideoPlayerController _videoController;
  bool _videoReady = false;
  bool _showCelebration = true;
  late final AnimationController _textController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/elijah_ko.mp4')
      ..setLooping(false);
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.9,
      upperBound: 1.1,
    );
    _videoController.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _videoReady = true;
      });
      _videoController.play();
      _textController.repeat(reverse: true);
      _videoController.addListener(() {
        final value = _videoController.value;
        if (!value.isPlaying &&
            value.position >= value.duration &&
            _showCelebration) {
          setState(() {
            _showCelebration = false;
          });
          _textController.stop();
        }
      });
    }).catchError((error) {
      debugPrint('Failed to load celebration video: $error');
      if (mounted) {
        setState(() {
          _showCelebration = false;
        });
      }
      _textController.stop();
    });
    _saveScore();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _textController.dispose();
    super.dispose();
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
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: _showCelebration
            ? _buildCelebration()
            : Consumer<GameService>(
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
            final levelTitle = session.levelName;

            // Calculate speed bonus
            final basePoints = correctAnswers * 1000;
            final speedBonus = totalScore - basePoints;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  // Header with close button and level title
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            gameService.resetGame();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainNavigation(),
                              ),
                              (route) => false,
                            );
                          },
                          icon: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          levelTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress bar (full)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.cyanAccent,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Circular avatar placeholder
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.85),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.cyanAccent.withOpacity(0.35),
                          blurRadius: 24,
                          spreadRadius: 4,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/game_complete_avatar.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // "GAME COMPLETE!" text
                  Text(
                    'GAME\nCOMPLETE!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.cyanAccent,
                      letterSpacing: 2,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        _buildStatRow(
                          label: 'Correct Answers',
                          value: '$correctAnswers/$totalQuestions',
                          chipColor: const Color(0xFFE1F6D0),
                        ),
                        const SizedBox(height: 20),
                        _buildStatRow(
                          label: 'Base Points',
                          value: '$basePoints pts',
                          chipColor: const Color(0xFFCBFDFF),
                          chipIcon: Icons.local_offer_outlined,
                          chipIconColor: const Color(0xFF0E2E30),
                        ),
                        const SizedBox(height: 20),
                        _buildStatRow(
                          label: 'Speed Bonus',
                          value: '$speedBonus pts',
                          chipColor: const Color(0xFFF3E7B0),
                          chipIcon: Icons.bolt,
                          chipIconColor: const Color(0xFF7A6410),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // "Read 1 Samuel 17" text
                  Text(
                    'Read $levelTitle',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Challenge a Friend button (outlined)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: Implement challenge friend functionality
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              side: BorderSide(
                                color: AppTheme.cyanAccent,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'CHALLENGE A FRIEND',
                              style: TextStyle(
                                color: AppTheme.cyanAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // View Leaderboard button (filled)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LeaderboardScreen(
                                    levelId: session.levelId,
                                    levelTitle: session.levelName,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: AppTheme.cyanAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'VIEW LEADERBOARD',
                              style: TextStyle(
                                color: AppTheme.darkBackground,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required String label,
    required String value,
    required Color chipColor,
    IconData? chipIcon,
    Color chipIconColor = Colors.black87,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: chipColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (chipIcon != null) ...[
                  Icon(
                    chipIcon,
                    size: 16,
                    color: chipIconColor,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111111),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebration() {
    return GestureDetector(
      onTap: () {
        if (_showCelebration) {
          setState(() {
            _showCelebration = false;
          });
          _textController.stop();
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        alignment: Alignment.center,
        child: _videoReady
            ? Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: _videoController.value.size.width,
                        height: _videoController.value.size.height,
                        child: VideoPlayer(_videoController),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _videoController.value.isPlaying ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: ScaleTransition(
                      scale: _textController,
                      child: Text(
                        'HOLY FLEX!',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 6,
                          color: AppTheme.cyanAccent.withOpacity(0.95),
                          shadows: const [
                            Shadow(
                              blurRadius: 12,
                              color: Colors.black54,
                              offset: Offset(0, 4),
                            ),
                            Shadow(
                              blurRadius: 24,
                              color: Colors.black38,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(color: AppTheme.cyanAccent),
      ),
    );
  }
}
