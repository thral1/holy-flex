import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../services/question_service.dart';
import '../models/question.dart';
import 'results_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final QuestionService _questionService = QuestionService();
  bool _isLoading = true;
  int? _selectedIndex;
  bool _showingFeedback = false;

  @override
  void initState() {
    super.initState();
    _loadAndStartGame();
  }

  Future<void> _loadAndStartGame() async {
    final gameService = Provider.of<GameService>(context, listen: false);

    try {
      final questions = await _questionService.loadQuestions('genesis');
      final shuffled = _questionService.shuffleQuestions(questions);

      gameService.startGame(shuffled, 'player_1', 'genesis');

      setState(() {
        _isLoading = false;
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

    setState(() {
      _selectedIndex = selectedIndex;
      _showingFeedback = true;
    });

    gameService.answerQuestion(selectedIndex);

    // Wait 1.5 seconds then move to next question or results
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      if (gameService.isGameComplete) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultsScreen(),
          ),
        );
      } else {
        gameService.nextQuestion();
        setState(() {
          _selectedIndex = null;
          _showingFeedback = false;
        });
      }
    });
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
              Colors.indigo.shade700,
              Colors.deepPurple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Consumer<GameService>(
                  builder: (context, gameService, child) {
                    final question = gameService.currentQuestion;
                    if (question == null) {
                      return const Center(
                        child: Text(
                          'No questions available',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        _buildHeader(gameService),
                        _buildTimerBar(gameService),
                        const SizedBox(height: 40),
                        _buildQuestionCard(question),
                        const SizedBox(height: 40),
                        _buildAnswerButtons(question, gameService),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(GameService gameService) {
    final currentIndex = gameService.currentSession!.currentQuestionIndex + 1;
    final totalQuestions = gameService.questions!.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Question $currentIndex of $totalQuestions',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${gameService.currentSession!.totalScore} pts',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBar(GameService gameService) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: gameService.progressPercentage,
        child: Container(
          decoration: BoxDecoration(
            color: gameService.remainingSeconds <= 5
                ? Colors.red
                : Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        question.text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          height: 1.4,
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
    Color buttonColor = Colors.white;
    Color textColor = Colors.black87;

    if (_showingFeedback && _selectedIndex == index) {
      // User selected this answer
      if (index == correctIndex) {
        buttonColor = Colors.green;
        textColor = Colors.white;
      } else {
        buttonColor = Colors.red;
        textColor = Colors.white;
      }
    } else if (_showingFeedback && index == correctIndex) {
      // Show correct answer
      buttonColor = Colors.green.shade100;
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
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.indigo.shade700,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: const TextStyle(
                    color: Colors.white,
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
