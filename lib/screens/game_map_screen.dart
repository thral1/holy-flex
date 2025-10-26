import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';
import 'story_reader_screen.dart';

class GameMapScreen extends StatelessWidget {
  const GameMapScreen({super.key});

  void _launchGenesis(BuildContext context) {
    // For now, launch game directly (no story pages yet for Genesis)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GameScreen(),
      ),
    );
  }

  void _launchSamuel17(BuildContext context) {
    // Launch story reader first
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StoryReaderScreen(
          levelTitle: '1 Samuel 17',
          storyPages: [
            'assets/images/stories/samuel_17/276.jpg',
            'assets/images/stories/samuel_17/277.jpg',
            'assets/images/stories/samuel_17/278.jpg',
            'assets/images/stories/samuel_17/279.jpg',
            'assets/images/stories/samuel_17/280.jpg',
            'assets/images/stories/samuel_17/281.jpg',
          ],
          questionsJsonPath: 'lib/data/samuel_17_questions.json',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              _buildStatsRow(),
              const SizedBox(height: 22),
              Expanded(
                child: _MapSection(
                  onGenesisTap: () => _launchGenesis(context),
                  onSamuel17Tap: () => _launchSamuel17(context),
                ),
              ),
              const SizedBox(height: 20),
              _buildChallengeButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'HOLY FLEX',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: AppTheme.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Level Progress',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
                letterSpacing: 0.8,
              ),
            ),
          ],
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

  Widget _buildChallengeButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.cyanAccent,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cyanAccent.withOpacity(0.4),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'CHALLENGE A FRIEND',
          style: TextStyle(
            color: AppTheme.darkBackground,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}

class _MapSection extends StatelessWidget {
  final VoidCallback onGenesisTap;
  final VoidCallback onSamuel17Tap;

  const _MapSection({
    required this.onGenesisTap,
    required this.onSamuel17Tap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final genesisPos = Offset(width * 0.5, height * 0.1);
        final samuel17Pos = Offset(width * 0.72, height * 0.35);
        final locked1Pos = Offset(width * 0.5, height * 0.48);
        final locked2Pos = Offset(width * 0.42, height * 0.68);
        final locked3Pos = Offset(width * 0.5, height * 0.88);

        final nodes = [
          _NodePosition(genesisPos, 56),
          _NodePosition(samuel17Pos, 48),
          _NodePosition(locked1Pos, 44),
          _NodePosition(locked2Pos, 40),
          _NodePosition(locked3Pos, 44),
        ];

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _MapPainter(
                  verticalNodes: nodes,
                  genesisRadius: nodes[0].radius,
                  samuelRadius: nodes[1].radius,
                ),
              ),
            ),
            _PathImage(
              asset: 'assets/images/samuel_12_image.png',
              width: math.min(138, width * 0.38),
              top: height * 0.18,
              left: 0,
            ),
            _PathImage(
              asset: 'assets/images/david_image.png',
              width: math.min(138, width * 0.38),
              bottom: height * 0.04,
              right: 0,
            ),
            _buildNode(
              center: genesisPos,
              size: nodes[0].radius * 2,
              child: _PrimaryNode(
                label: 'Genesis',
                onTap: onGenesisTap,
              ),
            ),
            _buildNode(
              center: samuel17Pos,
              size: nodes[1].radius * 2,
              child: _SecondaryNode(
                label: 'David and\nGoliath',
                onTap: onSamuel17Tap,
              ),
            ),
            Positioned(
              top: samuel17Pos.dy - 14,
              left: math.min(width - 90, samuel17Pos.dx + nodes[1].radius + 12),
              child: _PlayPill(onTap: onSamuel17Tap),
            ),
            _buildNode(
              center: locked1Pos,
              size: nodes[2].radius * 2,
              child: const _LockedNode(),
            ),
            _buildNode(
              center: locked2Pos,
              size: nodes[3].radius * 2,
              child: const _LockedNode(),
            ),
            _buildNode(
              center: locked3Pos,
              size: nodes[4].radius * 2,
              child: const _LockedNode(),
            ),
          ],
        );
      },
    );
  }

  Positioned _buildNode({
    required Offset center,
    required double size,
    required Widget child,
  }) {
    return Positioned(
      left: center.dx - size / 2,
      top: center.dy - size / 2,
      child: SizedBox(
        width: size,
        height: size,
        child: child,
      ),
    );
  }
}

class _NodePosition {
  final Offset offset;
  final double radius;

  const _NodePosition(this.offset, this.radius);
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

class _PrimaryNode extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryNode({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              Color(0xFFCBFDFF),
              Color(0xFFC1F4F0),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF9CB0B7),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.cyanAccent.withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1C1C1C),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryNode extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryNode({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              Color(0xFF121419),
              Color(0xFF1F2831),
            ],
            center: Alignment.topLeft,
            radius: 1.0,
          ),
          border: Border.all(
            color: AppTheme.cyanAccent.withOpacity(0.75),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.cyanAccent.withOpacity(0.5),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _LockedNode extends StatelessWidget {
  const _LockedNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2B2B2B),
            Color(0xFF1F1F1F),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(
          color: Colors.white10,
          width: 1,
        ),
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _PlayPill extends StatelessWidget {
  final VoidCallback onTap;

  const _PlayPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.cyanAccent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.cyanAccent.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          'PLAY',
          style: TextStyle(
            color: AppTheme.darkBackground,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _PathImage extends StatelessWidget {
  final String asset;
  final double width;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

  const _PathImage({
    required this.asset,
    required this.width,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          asset,
          width: width,
          height: width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final List<_NodePosition> verticalNodes;
  final double genesisRadius;
  final double samuelRadius;

  _MapPainter({
    required this.verticalNodes,
    required this.genesisRadius,
    required this.samuelRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (verticalNodes.length < 5) return;

    final pathPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Create curved dotted lines connecting each circle to the next
    final paths = [
      // Path from circle 1 to circle 2 (1 Samuel 12 to 1 Samuel 17)
      _createCurvePath(
        verticalNodes[0].offset,
        verticalNodes[0].radius,
        verticalNodes[1].offset,
        verticalNodes[1].radius,
        size.width * 0.85,
      ),
      // Path from circle 2 to circle 3
      _createCurvePath(
        verticalNodes[1].offset,
        verticalNodes[1].radius,
        verticalNodes[2].offset,
        verticalNodes[2].radius,
        size.width * 0.3,
      ),
      // Path from circle 3 to circle 4
      _createCurvePath(
        verticalNodes[2].offset,
        verticalNodes[2].radius,
        verticalNodes[3].offset,
        verticalNodes[3].radius,
        size.width * 0.2,
      ),
      // Path from circle 4 to circle 5
      _createCurvePath(
        verticalNodes[3].offset,
        verticalNodes[3].radius,
        verticalNodes[4].offset,
        verticalNodes[4].radius,
        size.width * 0.6,
      ),
    ];

    // Draw dotted lines along each path
    for (final path in paths) {
      for (final metric in path.computeMetrics()) {
        for (double distance = 0.0; distance < metric.length; distance += 14) {
          final tangent = metric.getTangentForOffset(distance);
          if (tangent == null) continue;
          canvas.drawCircle(tangent.position, 2.5, pathPaint);
        }
      }
    }
  }

  Path _createCurvePath(
    Offset start,
    double startRadius,
    Offset end,
    double endRadius,
    double controlX,
  ) {
    return Path()
      ..moveTo(start.dx, start.dy + startRadius)
      ..quadraticBezierTo(
        controlX,
        (start.dy + end.dy) / 2,
        end.dx,
        end.dy - endRadius,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
