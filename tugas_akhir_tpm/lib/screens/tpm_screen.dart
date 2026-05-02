import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class TpmScreen extends StatefulWidget {
  const TpmScreen({super.key});

  @override
  State<TpmScreen> createState() => _TpmScreenState();
}

class _TpmScreenState extends State<TpmScreen> {
  final _saranCtrl = TextEditingController();
  final _kesanCtrl = TextEditingController();
  double _rating = 4.0;
  bool _submitted = false;
  int _selectedMood = -1;

  final List<_MoodOption> _moods = [
    _MoodOption('😊', 'Menyenangkan'),
    _MoodOption('😤', 'Menantang'),
    _MoodOption('🤯', 'Intense'),
    _MoodOption('😴', 'Membosankan'),
    _MoodOption('🥰', 'Sangat Suka'),
  ];

  void _submit() {
    if (_saranCtrl.text.isEmpty || _kesanCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Harap isi semua kolom!'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    setState(() => _submitted = true);
  }

  @override
  void dispose() {
    _saranCtrl.dispose();
    _kesanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(title: const Text('Saran & Kesan')),
      body: _submitted ? _buildSuccess() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header Card ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accentLight, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(child: Text('📚', style: TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mata Kuliah TPM',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                        Text(
                          'Teknologi Pemrograman Mobile',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Bagikan pengalamanmu mengikuti mata kuliah ini. Masukanmu sangat berarti untuk perkembangan pembelajaran!',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Rating ──
          SectionHeader(title: 'Rating Mata Kuliah'),
          const SizedBox(height: 12),
          InfoCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () => setState(() => _rating = i + 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          i < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                          size: 36,
                          color: i < _rating ? const Color(0xFFFFB800) : AppColors.textMuted,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  _getRatingLabel(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentDark,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Mood Selector ──
          SectionHeader(title: 'Bagaimana perasaanmu?'),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _moods.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final selected = _selectedMood == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.accentLight : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? AppColors.accent : AppColors.borderLight,
                        width: selected ? 1.5 : 0.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_moods[index].emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 4),
                        Text(
                          _moods[index].label,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: selected ? AppColors.accentDark : AppColors.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ── Kesan ──
          SectionHeader(title: 'Kesan'),
          const SizedBox(height: 8),
          const Text(
            'Ceritakan pengalamanmu selama mengikuti mata kuliah TPM',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _kesanCtrl,
            maxLines: 4,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: 'Mata kuliah ini sangat membantu saya dalam...',
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 20),

          // ── Saran ──
          SectionHeader(title: 'Saran'),
          const SizedBox(height: 8),
          const Text(
            'Berikan masukan untuk pengembangan mata kuliah TPM ke depannya',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _saranCtrl,
            maxLines: 4,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: 'Saran saya untuk mata kuliah ini adalah...',
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 24),

          // ── Submit ──
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Kirim Saran & Kesan'),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.successLight, AppColors.primaryLight],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('🎉', style: TextStyle(fontSize: 52))),
            ),
            const SizedBox(height: 24),
            const Text(
              'Terima Kasih!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Saran dan kesanmu telah berhasil dikirim. Masukanmu sangat berarti untuk perkembangan mata kuliah TPM!',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            InfoCard(
              child: Column(
                children: [
                  _SummaryRow(label: 'Rating', value: '⭐ ${_rating.toInt()}/5 — ${_getRatingLabel()}'),
                  if (_selectedMood >= 0) ...[
                    const Divider(height: 16),
                    _SummaryRow(label: 'Mood', value: '${_moods[_selectedMood].emoji} ${_moods[_selectedMood].label}'),
                  ],
                  const Divider(height: 16),
                  _SummaryRow(label: 'Status', value: '✅ Terkirim'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => setState(() {
                  _submitted = false;
                  _saranCtrl.clear();
                  _kesanCtrl.clear();
                  _rating = 4.0;
                  _selectedMood = -1;
                }),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Isi Ulang'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingLabel() {
    switch (_rating.toInt()) {
      case 5: return 'Sangat Memuaskan';
      case 4: return 'Memuaskan';
      case 3: return 'Cukup';
      case 2: return 'Kurang';
      default: return 'Sangat Kurang';
    }
  }
}

class _MoodOption {
  final String emoji, label;
  const _MoodOption(this.emoji, this.label);
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}