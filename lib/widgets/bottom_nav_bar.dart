import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/splash_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        border: Border(
          top: BorderSide(
            color: AppTheme.cyanAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home_rounded,
                label: 'Dashboard',
                index: 0,
                isActive: currentIndex == 0,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.sports_esports_rounded,
                label: 'Game',
                index: 1,
                isActive: currentIndex == 1,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.menu_book_rounded,
                label: 'Bible',
                index: 2,
                isActive: currentIndex == 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        // Dashboard button (index 0) should go to splash screen
        if (index == 0) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            ),
            (route) => false,
          );
        } else {
          onTap(index);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.cyanAccent.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.cyanAccent : AppTheme.mediumGray,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.cyanAccent : AppTheme.mediumGray,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
