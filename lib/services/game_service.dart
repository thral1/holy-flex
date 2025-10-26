import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/question.dart';
import '../models/game_session.dart';
import '../models/question_result.dart';

class GameService extends ChangeNotifier with WidgetsBindingObserver {
  static const int questionTimeSeconds = 20;
  static const int basePoints = 1000;
  static const int maxSpeedBonus = 500;

  GameSession? _currentSession;
  List<Question>? _questions;
  Timer? _timer;
  int _remainingSeconds = questionTimeSeconds;
  DateTime? _questionStartTime;
  bool _isAnswered = false;
  Question? _overrideQuestion;
  DateTime? _pausedAt;
  int? _pausedRemainingSeconds;

  GameService() {
    WidgetsBinding.instance.addObserver(this);
  }

  GameSession? get currentSession => _currentSession;
  List<Question>? get questions => _questions;
  int get remainingSeconds => _remainingSeconds;
  double get progressPercentage => _remainingSeconds / questionTimeSeconds;
  bool get isAnswered => _isAnswered;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_currentSession == null || _isAnswered) return;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App going to background - pause timer
        _pauseTimer();
        break;
      case AppLifecycleState.resumed:
        // App returning to foreground - resume timer
        _resumeTimer();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      _pausedAt = DateTime.now();
      _pausedRemainingSeconds = _remainingSeconds;
      _timer?.cancel();
    }
  }

  void _resumeTimer() {
    if (_pausedAt != null && _pausedRemainingSeconds != null) {
      // Resume with the paused remaining time
      _remainingSeconds = _pausedRemainingSeconds!;
      _pausedAt = null;
      _pausedRemainingSeconds = null;

      // Restart timer from where we left off
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          notifyListeners();
        } else {
          timer.cancel();
          _handleTimeout();
        }
      });
      notifyListeners();
    }
  }

  Question? get currentQuestion {
    if (_overrideQuestion != null) {
      return _overrideQuestion;
    }

    if (_currentSession == null ||
        _questions == null ||
        _currentSession!.currentQuestionIndex >= _questions!.length) {
      return null;
    }
    return _questions![_currentSession!.currentQuestionIndex];
  }

  bool get isGameComplete {
    if (_currentSession == null || _questions == null) return false;
    return _currentSession!.currentQuestionIndex >= _questions!.length;
  }

  void startGame(
    List<Question> questions,
    String userId,
    String levelId,
    String levelName,
  ) {
    _questions = questions;
    _currentSession = GameSession(
      sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      levelId: levelId,
      levelName: levelName,
      startTime: DateTime.now(),
    );
    _overrideQuestion = null;
    _startQuestionTimer();
    notifyListeners();
  }

  void _startQuestionTimer() {
    _remainingSeconds = questionTimeSeconds;
    _questionStartTime = DateTime.now();
    _isAnswered = false;
    _overrideQuestion = null;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        // Time's up - auto-submit with no answer
        timer.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    if (_isAnswered) return;

    // Mark as answered with -1 (no answer selected)
    answerQuestion(-1);
  }

  void answerQuestion(int selectedIndex) {
    if (_currentSession == null ||
        currentQuestion == null ||
        _isAnswered) {
      return;
    }

    final Question current = currentQuestion!;

    _isAnswered = true;
    _timer?.cancel();

    final timeSpentMs = DateTime.now()
        .difference(_questionStartTime ?? DateTime.now())
        .inMilliseconds;

    final isCorrect = selectedIndex == current.correctIndex;
    final points = isCorrect ? _calculatePoints(timeSpentMs) : 0;

    final result = QuestionResult(
      questionId: current.id,
      selectedIndex: selectedIndex,
      isCorrect: isCorrect,
      timeSpentMs: timeSpentMs,
      pointsEarned: points,
    );

    _currentSession!.addResult(result);
    _overrideQuestion = current;
    notifyListeners();
  }

  int _calculatePoints(int timeSpentMs) {
    final timeSpentSeconds = timeSpentMs / 1000;

    // Speed bonus calculation
    int speedBonus = 0;
    if (timeSpentSeconds <= 5) {
      speedBonus = maxSpeedBonus;
    } else if (timeSpentSeconds <= 10) {
      speedBonus = 300;
    } else if (timeSpentSeconds <= 15) {
      speedBonus = 100;
    }

    return basePoints + speedBonus;
  }

  void nextQuestion() {
    if (isGameComplete) {
      _currentSession?.complete();
      _timer?.cancel();
      notifyListeners();
      return;
    }

    _startQuestionTimer();
    notifyListeners();
  }

  void endGame() {
    _timer?.cancel();
    _currentSession?.complete();
    notifyListeners();
  }

  void resetGame() {
    _timer?.cancel();
    _currentSession = null;
    _questions = null;
    _remainingSeconds = questionTimeSeconds;
    _questionStartTime = null;
    _isAnswered = false;
    _overrideQuestion = null;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
}
