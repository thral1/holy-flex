import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';

class StoryReaderScreen extends StatefulWidget {
  final String levelTitle;
  final List<String> storyPages;
  final String? questionsJsonPath;

  const StoryReaderScreen({
    super.key,
    required this.levelTitle,
    required this.storyPages,
    this.questionsJsonPath,
  });

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  int _currentPage = 0;

  void _goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < widget.storyPages.length) {
      setState(() {
        _currentPage = pageIndex;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < widget.storyPages.length - 1) {
      setState(() {
        _currentPage++;
      });
    } else {
      _startGame();
    }
  }

  void _skipStory() {
    _startGame();
  }

  void _startGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          questionsJsonPath: widget.questionsJsonPath,
          levelTitle: widget.levelTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button and title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
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
                    widget.levelTitle,
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

            // Segmented progress bar (clickable)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(widget.storyPages.length, (index) {
                  final isActive = index <= _currentPage;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _goToPage(index),
                      child: Container(
                        height: 6,
                        margin: EdgeInsets.only(
                          right: index < widget.storyPages.length - 1 ? 4 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppTheme.cyanAccent
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // Story page image (expanded to fill space)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 1.0,
                  maxScale: 3.0,
                  child: Image.asset(
                    widget.storyPages[_currentPage],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Skip Story button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _skipStory,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'SKIP STORY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Next button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppTheme.cyanAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage < widget.storyPages.length - 1
                            ? 'NEXT'
                            : 'START QUIZ',
                        style: const TextStyle(
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
          ],
        ),
      ),
    );
  }
}
