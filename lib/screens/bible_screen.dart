import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'BIBLE',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.cyanAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1 Samuel 17 - David and Goliath',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightGray,
                        ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.darkBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.cyanAccent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.cyanAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppTheme.darkBackground,
                unselectedLabelColor: AppTheme.lightGray,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                tabs: const [
                  Tab(text: 'Picture Bible'),
                  Tab(text: 'CEV'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPictureBibleTab(),
                  _buildCEVTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPictureBibleTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildComicPanel(
          title: 'The Giant\'s Challenge',
          text: 'Goliath, a giant warrior, challenged the Israelites to send out a champion to fight him.',
          imagePlaceholder: Icons.shield,
        ),
        const SizedBox(height: 16),
        _buildComicPanel(
          title: 'David Arrives',
          text: 'Young David came to bring food to his brothers and heard Goliath\'s taunts.',
          imagePlaceholder: Icons.person,
        ),
        const SizedBox(height: 16),
        _buildComicPanel(
          title: 'Faith Over Fear',
          text: 'While others were afraid, David trusted God and volunteered to fight the giant.',
          imagePlaceholder: Icons.favorite,
        ),
        const SizedBox(height: 16),
        _buildComicPanel(
          title: 'The Victory',
          text: 'With just a sling and stone, David defeated Goliath, showing God\'s power.',
          imagePlaceholder: Icons.celebration,
        ),
      ],
    );
  }

  Widget _buildComicPanel({
    required String title,
    required String text,
    required IconData imagePlaceholder,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.cyanAccent.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.cyanAccent.withOpacity(0.2),
                  AppTheme.darkBackground,
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Center(
              child: Icon(
                imagePlaceholder,
                size: 80,
                color: AppTheme.cyanAccent.withOpacity(0.5),
              ),
            ),
          ),
          // Text content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.cyanAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.lightGray,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCEVTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.darkBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.cyanAccent.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1 Samuel 17 (CEV)',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.cyanAccent,
                ),
              ),
              const SizedBox(height: 16),
              _buildVerseText('4-7',
                'The Philistines chose Goliath, a champion from Gath, who was over nine feet tall. He wore a bronze helmet and had bronze armor to protect his chest and legs.'),
              _buildVerseText('32-33',
                'David told Saul, "Your Majesty, this Philistine shouldn\'t turn us into cowards. I\'ll go out and fight him myself!" "You don\'t have a chance against him," Saul replied.'),
              _buildVerseText('45',
                'David said to Goliath, "You come to me with a sword, a spear, and a dagger. But I come to you in the name of the LORD All-Powerful."'),
              _buildVerseText('49-50',
                'David struck Goliath on the forehead with the stone from his sling, and Goliath fell face down. David defeated Goliath with a sling and a rock.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerseText(String verse, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.lightGray,
            height: 1.6,
          ),
          children: [
            TextSpan(
              text: '$verse  ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.cyanAccent,
              ),
            ),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }
}
