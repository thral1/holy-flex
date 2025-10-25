import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BibleScreen extends StatelessWidget {
  const BibleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 80,
                color: AppTheme.cyanAccent.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'Bible Reading',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppTheme.cyanAccent,
                    ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Coming soon: Read Bible stories with Picture Bible and CEV translations',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
