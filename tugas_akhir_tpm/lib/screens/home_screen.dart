import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'result_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                          'Hi, Sarah ✨',
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
                  // Avatar
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
                    child: const Center(child: Text('👤', style: TextStyle(fontSize: 20))),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Upload / Scan Banner ──
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResultScreen()),
                ),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
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
                              'Upload a photo and get your\npersonal color palette',
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
                      // Decorative circles
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
                              child: Text('📸', style: TextStyle(fontSize: 36)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Your Palette ──
              SectionHeader(title: 'Your Palette', action: 'See all', onAction: () {}),
              const SizedBox(height: 12),
              InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.swatchTerracotta.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '🍂 Warm Autumn',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.swatchTerracotta,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Text('Last update: 2 days ago',
                            style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ColorSwatchTile(color: AppColors.swatchSienna, label: 'Sienna'),
                        ColorSwatchTile(color: AppColors.swatchCopper, label: 'Copper'),
                        ColorSwatchTile(color: AppColors.swatchMoss, label: 'Moss'),
                        ColorSwatchTile(color: AppColors.swatchCamel, label: 'Camel'),
                        ColorSwatchTile(color: AppColors.swatchBurgundy, label: 'Burgundy'),
                        ColorSwatchTile(color: AppColors.swatchTerracotta, label: 'Terra'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Quick Actions ──
              SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 12),
              Row(
                children: [
                  _QuickAction(
                    icon: '🤖',
                    label: 'Ask ChromaBot',
                    color: AppColors.accentLight,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _QuickAction(
                    icon: '📍',
                    label: 'Nearby Stores',
                    color: AppColors.secondaryLight,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _QuickAction(
                    icon: '🎮',
                    label: 'Color Game',
                    color: AppColors.primaryLight,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Daily Tip ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accentLight),
                ),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Color Tip of the Day',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentDark,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Warm undertones glow best in earth tones. Try pairing terracotta with olive for a harmonious autumn look.',
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

              const SizedBox(height: 24),

              // ── Recent Analyses ──
              SectionHeader(title: 'Recent Analyses', action: 'See all', onAction: () {}),
              const SizedBox(height: 12),
              _AnalysisHistoryCard(
                type: '🍂 Warm Autumn',
                subtitle: '14 colors · Deep · Muted',
                date: '2 days ago',
                swatchColors: [
                  AppColors.swatchSienna,
                  AppColors.swatchCopper,
                  AppColors.swatchMoss,
                ],
              ),
              const SizedBox(height: 8),
              _AnalysisHistoryCard(
                type: '🌸 Bright Spring',
                subtitle: '12 colors · Warm · Clear',
                date: '1 week ago',
                swatchColors: [
                  const Color(0xFFE8A878),
                  const Color(0xFFD4785A),
                  const Color(0xFF7DB87D),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.camera_alt_outlined, size: 14, color: AppColors.accentDark),
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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalysisHistoryCard extends StatelessWidget {
  final String type;
  final String subtitle;
  final String date;
  final List<Color> swatchColors;

  const _AnalysisHistoryCard({
    required this.type,
    required this.subtitle,
    required this.date,
    required this.swatchColors,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Row(
            children: swatchColors
                .asMap()
                .entries
                .map((e) => Transform.translate(
                      offset: Offset(e.key * -6.0, 0),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: e.value,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}