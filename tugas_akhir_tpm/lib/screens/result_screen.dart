import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../utils/analysis_mapper.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ResultScreen({super.key, required this.data});


  @override
  Widget build(BuildContext context) {
    final mapped = AnalysisMapper.mapAll(data);
    final season = data['season'] ?? "Unknown";
    final undertone = data['undertone'] ?? "-";
    final brightness = data['brightness'] ?? "-";
    final contrast = data['contrast_level'] ?? "-";

    final bestColors = List<String>.from(data['best_colors'] ?? []);
    final avoidColors = List<String>.from(data['avoid_colors'] ?? []);
    final tips = data['styling_tips'] ?? "";

    final features = mapped['faceFeatures'] as List;
    final harmony = mapped['harmony'] as Map<String, double>;
    final glowTips = List<String>.from(
      data['glow_tips'] ?? [
        "Use colors that match your undertone",
        "Avoid extreme contrast outfits",
      ],
    );

    
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: CustomScrollView(
        slivers: [
          // ── Sticky Header ──
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient bg
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFE8A598), Color(0xFFA87890)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Decorative circles
                  Positioned(
                    top: -30, right: -20,
                    child: Container(
                      width: 130, height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -10, left: 20,
                    child: Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    bottom: 20, left: 20, right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PastelBadge(
                          label: 'AI Analysis Result',
                          color: Colors.white.withOpacity(0.25),
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          season,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "$brightness · $contrast · $undertone",
                          style: const TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Face Features ──

                Row(
                  children: features.map<Widget>((f) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FaceFeaturePill(
                        emoji: f['emoji'],
                        label: f['label'],
                        sub: f['sub'],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // ── Color Harmony ──
                SectionHeader(title: 'Color Harmony Profile'),
                const SizedBox(height: 12),
                InfoCard(
                  child: Column(
                    children: [
                      HarmonyBar(
                        leftLabel: 'Warm',
                        rightLabel: 'Cool',
                        value: (harmony['warmCool']) as double,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Best & Avoid Colors ──
                SectionHeader(title: 'Personal Color Palette'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InfoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: const [
                              Icon(Icons.check_circle_outline, color: AppColors.success, size: 14),
                              SizedBox(width: 4),
                              Text('Make You Glow',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success)),
                            ]),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: bestColors.map((hex) {
                                return ColorSwatchTile(
                                  color: _hexToColor(hex),
                                  label: hex.replaceAll("#", ""),
                                  size: 32,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InfoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: const [
                              Icon(Icons.cancel_outlined, color: AppColors.error, size: 14),
                              SizedBox(width: 4),
                              Text('Dull You Out',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.error)),
                            ]),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: avoidColors.map((hex) {
                                return ColorSwatchTile(
                                  color: _hexToColor(hex).withOpacity(0.6),
                                  label: hex.replaceAll("#", ""),
                                  size: 32,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Makeup Guide ──
                SectionHeader(title: 'Makeup Tonal Guide'),
                const SizedBox(height: 12),
                InfoCard(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.bgMuted,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Warm · Muted · Soft',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            PastelBadge(label: 'Your Tone'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _MakeupCol(
                            title: 'Foundation',
                            items: [
                              _MakeupItem(color: const Color(0xFFE8C4A0), name: 'Lt Warm Beige', isCircle: false),
                              _MakeupItem(color: const Color(0xFFD4A878), name: 'Nat Beige', isCircle: false),
                              _MakeupItem(color: const Color(0xFFC09060), name: 'Warm Sand', isCircle: false),
                            ],
                          ),
                          const SizedBox(width: 6),
                          _MakeupCol(
                            title: 'Blush',
                            items: [
                              _MakeupItem(color: const Color(0xFFE8A090), name: 'Peach', isCircle: true),
                              _MakeupItem(color: const Color(0xFFD4887A), name: 'Warm Rose', isCircle: true),
                              _MakeupItem(color: const Color(0xFFC87060), name: 'Terracotta', isCircle: true),
                            ],
                          ),
                          const SizedBox(width: 6),
                          _MakeupCol(
                            title: 'Eyeshadow',
                            items: [
                              _MakeupItem(color: const Color(0xFFC4A882), name: 'Champagne', isCircle: true),
                              _MakeupItem(color: const Color(0xFF8B6248), name: 'Mocha', isCircle: true),
                              _MakeupItem(color: const Color(0xFF6B4030), name: 'Deep Brown', isCircle: true),
                            ],
                          ),
                          const SizedBox(width: 6),
                          _MakeupCol(
                            title: 'Lips',
                            items: [
                              _MakeupItem(color: const Color(0xFFD4785A), name: 'Terra', isCircle: false, isLip: true),
                              _MakeupItem(color: const Color(0xFFC06050), name: 'Brick Rose', isCircle: false, isLip: true),
                              _MakeupItem(color: const Color(0xFFA04840), name: 'Berry Warm', isCircle: false, isLip: true),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Accessories ──
                SectionHeader(title: 'Accessories Guide'),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _AccessoryCard(
                    title: 'Metals', icon: '💍',
                    bestItems: ['Gold', 'Rose Gold'],
                    avoidItems: ['Silver', 'Gunmetal'],
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _AccessoryCard(
                    title: 'Jewelry', icon: '✨',
                    bestItems: ['Minimal', 'Dainty', 'Rounded'],
                    avoidItems: ['Chunky', 'Sharp edges'],
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _AccessoryCard(
                    title: 'Bags & Shoes', icon: '👜',
                    bestItems: ['Brown', 'Camel', 'Olive'],
                    avoidItems: ['Neon', 'Electric Blue'],
                  )),
                ]),
                const SizedBox(height: 20),

                // ── ChromaBot Response ──
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accentLight),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(child: Text('🤖', style: TextStyle(fontSize: 16))),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ChromaBot says',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.accentDark)),
                            SizedBox(height: 4),
                            Text(
                              '"$tips"',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Glow Guide ──
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryLight, AppColors.accentLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✦ Glow Guide',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentDark)),
                      const SizedBox(height: 12),
                      Column(
                        children: glowTips.map((tip) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _GlowTip(
                              icon: '✨',
                              text: tip,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

Color _hexToColor(String hex) {
  final cleaned = hex.replaceAll("#", "");
  return Color(int.parse("0xFF$cleaned"));
}

// Sub-widgets
class _FaceFeaturePill extends StatelessWidget {
  final String emoji, label, sub;
  const _FaceFeaturePill({required this.emoji, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InfoCard(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textPrimary), textAlign: TextAlign.center),
          Text(sub, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
        ]),
      ),
    );
  }
}

class _NeutralCard extends StatelessWidget {
  final String title;
  final List<Color> colors;
  final List<String> labels;
  const _NeutralCard({required this.title, required this.colors, required this.labels});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(colors.length, (i) => Expanded(
              child: Column(children: [
                Container(height: 22, margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(color: colors[i], borderRadius: BorderRadius.circular(5))),
                const SizedBox(height: 3),
                Text(labels[i], style: const TextStyle(fontSize: 7, color: AppColors.textMuted)),
              ]),
            )),
          ),
        ],
      ),
    );
  }
}

class _MakeupItem {
  final Color color;
  final String name;
  final bool isCircle;
  final bool isLip;
  const _MakeupItem({required this.color, required this.name, required this.isCircle, this.isLip = false});
}

class _MakeupCol extends StatelessWidget {
  final String title;
  final List<_MakeupItem> items;
  const _MakeupCol({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textSecondary), textAlign: TextAlign.center),
        const SizedBox(height: 6),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Column(children: [
            item.isLip
              ? Container(width: 36, height: 12, decoration: BoxDecoration(color: item.color, borderRadius: BorderRadius.circular(99)))
              : item.isCircle
                ? Container(width: 26, height: 26, decoration: BoxDecoration(color: item.color, shape: BoxShape.circle))
                : Container(width: double.infinity, height: 10, decoration: BoxDecoration(color: item.color, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 2),
            Text(item.name, style: const TextStyle(fontSize: 7, color: AppColors.textMuted), textAlign: TextAlign.center),
          ]),
        )),
      ]),
    );
  }
}

class _AccessoryCard extends StatelessWidget {
  final String title, icon;
  final List<String> bestItems, avoidItems;
  const _AccessoryCard({required this.title, required this.icon, required this.bestItems, required this.avoidItems});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Text(icon, style: const TextStyle(fontSize: 14)), const SizedBox(width: 4), Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textPrimary))]),
          const SizedBox(height: 6),
          ...bestItems.map((e) => Text('✓ $e', style: const TextStyle(fontSize: 9, color: AppColors.success))),
          const SizedBox(height: 4),
          ...avoidItems.map((e) => Text('✕ $e', style: const TextStyle(fontSize: 9, color: AppColors.error))),
        ],
      ),
    );
  }
}

class _GlowTip extends StatelessWidget {
  final String icon, text;
  const _GlowTip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.4))),
        ],
      ),
    );
  }
}