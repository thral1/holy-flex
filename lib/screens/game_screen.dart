import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../services/question_service.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import 'results_screen.dart';

class GameScreen extends StatefulWidget {
  final String? questionsJsonPath;
  final String? levelTitle;

  const GameScreen({
    super.key,
    this.questionsJsonPath,
    this.levelTitle,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final QuestionService _questionService = QuestionService();
  bool _isLoading = true;
  int? _selectedIndex;
  bool _showingFeedback = false;
  Question? _currentQuestion;

  @override
  void initState() {
    super.initState();
    _loadAndStartGame();
  }

  Future<void> _loadAndStartGame() async {
    final gameService = Provider.of<GameService>(context, listen: false);

    try {
      // Use custom path if provided, otherwise default to genesis
      final levelKey = widget.questionsJsonPath ?? 'genesis';
      final levelName = widget.levelTitle ?? 'genesis';

      final questions = await _questionService.loadQuestions(levelKey);
      final shuffled = _questionService.shuffleQuestions(questions);

      gameService.startGame(
        shuffled,
        'player_1',
        levelKey,
        levelName,
      );

      setState(() {
        _isLoading = false;
        _currentQuestion = gameService.currentQuestion;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading questions: $e')),
        );
      }
    }
  }

  void _handleAnswer(int selectedIndex, GameService gameService) {
    if (_showingFeedback) return;

    // Single delay constant for feedback display - controls how long answer is highlighted
    const feedbackDelayMs = 1400;

    setState(() {
      _selectedIndex = selectedIndex;
      _showingFeedback = true;
    });

    gameService.answerQuestion(selectedIndex);
    final isGameComplete = gameService.isGameComplete;

    // Hold the current question screen for feedbackDelayMs, then transition
    Future.delayed(const Duration(milliseconds: feedbackDelayMs), () {
      if (!mounted) return;

      if (isGameComplete) {
        // Game is complete, end the game and navigate to results
        gameService.endGame();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultsScreen(),
          ),
        );
      } else {
        // CRITICAL: Advance to next question in gameService (doesn't update UI yet)
        gameService.nextQuestion();

        // Now reset UI state and update to show new question
        setState(() {
          _selectedIndex = null;
          _showingFeedback = false;
          _currentQuestion = gameService.currentQuestion;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.cyanAccent),
              )
            : Consumer<GameService>(
                builder: (context, gameService, child) {
                  final question = gameService.currentQuestion;

                  // Always update to the latest question if it exists
                  if (question != null) {
                    _currentQuestion = question;
                  }

                  // Always use _currentQuestion - never show null/empty state
                  final displayQuestion = _currentQuestion;

                  // Safety check - should never be null if game loaded properly
                  if (displayQuestion == null) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppTheme.cyanAccent),
                    );
                  }

                  return Column(
                    children: [
                      _buildHeader(gameService),
                      _buildProgressBar(gameService),
                      const SizedBox(height: 40),
                      _buildQuestionCard(displayQuestion),
                      const SizedBox(height: 40),
                      _buildAnswerButtons(displayQuestion, gameService),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildHeader(GameService gameService) {
    final totalQuestions = gameService.questions?.length ?? 0;
    int currentIndex =
        (gameService.currentSession?.currentQuestionIndex ?? 0) + 1;

    if (_showingFeedback && gameService.isGameComplete) {
      currentIndex = totalQuestions;
    }

    if (totalQuestions > 0) {
      if (currentIndex < 1) {
        currentIndex = 1;
      } else if (currentIndex > totalQuestions) {
        currentIndex = totalQuestions;
      }
    } else {
      currentIndex = 0;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Question $currentIndex of $totalQuestions',
            style: const TextStyle(
              fontSize: 18,
              color: AppTheme.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.cyanAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.cyanAccent,
                width: 1,
              ),
            ),
            child: Text(
              '${gameService.currentSession!.totalScore} pts',
              style: const TextStyle(
                fontSize: 18,
                color: AppTheme.cyanAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(GameService gameService) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 12,
      decoration: BoxDecoration(
        color: AppTheme.progressBarInactive,
        borderRadius: BorderRadius.circular(6),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: gameService.progressPercentage,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.cyanAccent,
                AppTheme.cyanAccent.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: AppTheme.cyanAccent.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.cyanAccent.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Text(
        question.text,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppTheme.white,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnswerButtons(Question question, GameService gameService) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: question.choices.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildAnswerButton(
              question.choices[index],
              index,
              question.correctIndex,
              gameService,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnswerButton(
    String text,
    int index,
    int correctIndex,
    GameService gameService,
  ) {
    Color buttonColor = AppTheme.darkBackground;
    Color textColor = AppTheme.white;
    Color borderColor = AppTheme.mediumGray;
    Color letterBgColor = AppTheme.cyanAccent;

    if (_showingFeedback && _selectedIndex == index) {
      // User selected this answer
      if (index == correctIndex) {
        buttonColor = AppTheme.correctAnswer.withOpacity(0.2);
        borderColor = AppTheme.correctAnswer;
        letterBgColor = AppTheme.correctAnswer;
      } else {
        buttonColor = AppTheme.wrongAnswer.withOpacity(0.2);
        borderColor = AppTheme.wrongAnswer;
        letterBgColor = AppTheme.wrongAnswer;
      }
    } else if (_showingFeedback && index == correctIndex) {
      // Show correct answer
      buttonColor = AppTheme.correctAnswer.withOpacity(0.1);
      borderColor = AppTheme.correctAnswer;
      letterBgColor = AppTheme.correctAnswer;
    }

    return MouseRegion(
      cursor: (_showingFeedback || gameService.isAnswered)
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _showingFeedback || gameService.isAnswered
            ? null
            : () => _handleAnswer(index, gameService),
        child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: letterBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: const TextStyle(
                    color: AppTheme.darkBackground,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
