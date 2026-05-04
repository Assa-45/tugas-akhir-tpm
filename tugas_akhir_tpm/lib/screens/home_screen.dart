import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../services/storage_service.dart';
import 'game_screen.dart';
import 'chatbot_screen.dart';
import 'converter_screen.dart';
import 'nearby_screen.dart';
import 'scan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name = '';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  void _loadName() async {
    final name = await StorageService.getName();
    setState(() => _name = name ?? 'there');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Header ──
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, $_name!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Discover your color identity today',
                          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryLight, AppColors.accentLight],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                        child: Text('👤', style: TextStyle(fontSize: 20))),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Upload / Scan Banner ──
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScanScreen(),
                    ),
                  )
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE8A598), Color(0xFFA87890)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Analyze Your Colors',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Upload a photo and discover your\npersonal color season & palette',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 14),
                            _ScanButton(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 70,
                        height: 90,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const Center(
                              child: Text('📸',
                                  style: TextStyle(fontSize: 36)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Quick Access ──
              const SectionHeader(title: 'Quick Access'),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
                children: [
                  _QuickAction(
                    icon: '🤖',
                    label: 'ChromaBot',
                    color: AppColors.accentLight,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChatbotScreen()),
                      );
                    },
                  ),
                  _QuickAction(
                    icon: '📍',
                    label: 'Nearby',
                    color: AppColors.secondaryLight,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NearbyScreen()),
                      );
                    },
                  ),
                  _QuickAction(
                    icon: '🎮',
                    label: 'Color Game',
                    color: AppColors.primaryLight,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GameScreen()),
                      );
                    },
                  ),
                  _QuickAction(
                    icon: '💱',
                    label: 'Converter',
                    color: const Color(0xFFE0F2F1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ConverterScreen()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Explore Section (pengganti Recent Analyses) ──
              _ExploreSection(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Explore Section ──
class _ExploreSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header persuasif
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accentLight.withOpacity(0.45),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentLight),
          ),
          child: const Row(
            children: [
              Text('🌟', style: TextStyle(fontSize: 22)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No analysis yet!',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentDark,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Take a photo and discover the colors that look best on you 💄',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Label
        const Text(
          'While you\'re at it, try exploring our other features',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        // Card 1 — Game
        _ExploreCard(
          emoji: '🎮',
          title: 'ColorMatch Game',
          desc: 'Test your color knowledge! Guess the best color combo for each skin tone and rack up your highest score.',
          badgeLabel: 'Mini Game',
          badgeColor: AppColors.primaryLight,
          badgeTextColor: AppColors.primaryDark,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GameScreen()),
            );
          },
        ),
        const SizedBox(height: 10),

        // Card 2 — ChromaBot
        _ExploreCard(
          emoji: '🤖',
          title: 'Ask ChromaBot',
          desc: 'Got questions about makeup or outfits? ChromaBot is ready to give you personalized beauty advice.',
          badgeLabel: 'AI Chatbot',
          badgeColor: AppColors.accentLight,
          badgeTextColor: AppColors.accentDark,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatbotScreen()),
            );
          },
        ),
        const SizedBox(height: 10),

        // Card 3 — Nearby
        _ExploreCard(
          emoji: '📍',
          title: 'Find Nearby Stores',
          desc: 'Discover makeup and fashion stores around you. Filter by category and check them out on the map.',
          badgeLabel: 'Location',
          badgeColor: AppColors.secondaryLight,
          badgeTextColor: AppColors.accentDark,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NearbyScreen()),
            );
          },
        ),
      ],
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final String emoji, title, desc, badgeLabel;
  final Color badgeColor, badgeTextColor;
  final VoidCallback onTap;

  const _ExploreCard({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InfoCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: badgeTextColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ──

class _ScanButton extends StatelessWidget {
  const _ScanButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.camera_alt_outlined,
              size: 14, color: AppColors.accentDark),
          SizedBox(width: 6),
          Text(
            'Start Analysis',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accentDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.45),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.8), width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}