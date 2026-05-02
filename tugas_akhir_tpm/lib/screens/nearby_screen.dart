import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Makeup', 'Fashion', 'Skincare', 'Accessories'];

  final List<_StoreData> _stores = [
    _StoreData('Sariayu Beauty Store', 'Makeup', '0.3', 'Until 21:00', true, Icons.face_retouching_natural_outlined, AppColors.primaryLight),
    _StoreData('Zara Malioboro Mall', 'Fashion', '0.8', 'Until 22:00', true, Icons.shopping_bag_outlined, AppColors.secondaryLight),
    _StoreData('Wardah Official Store', 'Makeup', '1.2', 'Until 20:00', true, Icons.spa_outlined, AppColors.primaryLight),
    _StoreData('Erha Clinic', 'Skincare', '1.5', 'Opens 09:00', false, Icons.local_pharmacy_outlined, AppColors.accentLight),
    _StoreData('H&M Malioboro', 'Fashion', '1.7', 'Until 22:00', true, Icons.checkroom_outlined, AppColors.secondaryLight),
    _StoreData('The Body Shop', 'Skincare', '2.0', 'Until 21:00', true, Icons.eco_outlined, AppColors.accentLight),
    _StoreData('Miniso', 'Accessories', '2.4', 'Until 22:00', true, Icons.style_outlined, AppColors.primaryLight),
  ];

  List<_StoreData> get _filteredStores {
    if (_selectedFilter == 0) return _stores;
    final filter = _filters[_selectedFilter];
    return _stores.where((s) => s.category == filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text('Nearby Stores'),
        actions: [
          IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // ── Map View ──
          Container(
            height: 200,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Map placeholder (replace with google_maps_flutter widget)
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFD8E8DF), Color(0xFFCCDDD4)],
                    ),
                  ),
                ),
                // Grid lines overlay
                CustomPaint(painter: _MapGridPainter()),
                // Map pins
                ..._buildMapPins(),
                // Your location
                Center(
                  child: Container(
                    width: 16, height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 8)],
                    ),
                  ),
                ),
                // Info overlay
                Positioned(
                  bottom: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.location_on, size: 12, color: AppColors.accent),
                        SizedBox(width: 4),
                        Text('Yogyakarta · 12 stores nearby',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
                // Expand map button
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fullscreen_rounded, size: 16, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Filter Chips ──
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final selected = _selectedFilter == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.accent : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                          color: selected ? AppColors.accent : AppColors.border),
                    ),
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: selected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // ── Recommendation Banner ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: const [
                  Text('💡', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Based on your Warm Autumn palette, look for terracotta & earthy tones!',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Store List ──
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredStores.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final store = _filteredStores[index];
                return StoreCard(
                  name: store.name,
                  category: store.category,
                  distance: store.distance,
                  hours: store.hours,
                  isOpen: store.isOpen,
                  iconBg: store.iconBg,
                  icon: store.icon,
                  onTap: () => _showStoreDetail(context, store),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMapPins() {
    final positions = [
      const Offset(0.25, 0.3),
      const Offset(0.6, 0.25),
      const Offset(0.75, 0.55),
      const Offset(0.3, 0.65),
      const Offset(0.55, 0.7),
    ];
    return positions.map((pos) {
      return Positioned(
        left: pos.dx * 350,
        top: pos.dy * 200,
        child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 22),
      );
    }).toList();
  }

  void _showStoreDetail(BuildContext context, _StoreData store) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _StoreDetailSheet(store: store),
    );
  }
}

class _StoreData {
  final String name, category, distance, hours;
  final bool isOpen;
  final IconData icon;
  final Color iconBg;
  const _StoreData(this.name, this.category, this.distance, this.hours, this.isOpen, this.icon, this.iconBg);
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

class _StoreDetailSheet extends StatelessWidget {
  final _StoreData store;
  const _StoreDetailSheet({required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: AppColors.bgMuted, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: store.iconBg, borderRadius: BorderRadius.circular(14)),
              child: Icon(store.icon, color: AppColors.accentDark),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(store.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Row(children: [
                PastelBadge(label: store.category, color: AppColors.secondaryLight, textColor: AppColors.accentDark),
                const SizedBox(width: 8),
                Container(width: 7, height: 7, decoration: BoxDecoration(color: store.isOpen ? AppColors.success : AppColors.error, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text(store.isOpen ? 'Open now' : 'Closed', style: TextStyle(fontSize: 11, color: store.isOpen ? AppColors.success : AppColors.error)),
              ]),
            ]),
            const Spacer(),
            Text('${store.distance} km', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.success)),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.directions_rounded, size: 16),
                label: const Text('Directions'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call_outlined, size: 16),
                label: const Text('Call'),
              ),
            ),
          ]),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}