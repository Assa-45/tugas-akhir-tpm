import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifPromo = true;
  bool _notifTip = true;
  bool _notifSale = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.bgMain,
            title: const Text('My Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryLight, AppColors.accentLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Decorative circles
                  Positioned(
                    top: -20, right: -20,
                    child: Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20, left: -10,
                    child: Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Profile content
                  Positioned(
                    bottom: 20, left: 0, right: 0,
                    child: Column(
                      children: [
                        // Avatar with camera button
                        Stack(
                          children: [
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent.withOpacity(0.3),
                                    blurRadius: 16,
                                  )
                                ],
                                gradient: const LinearGradient(
                                  colors: [AppColors.primary, AppColors.accent],
                                ),
                              ),
                              child: const Center(
                                child: Text('👤', style: TextStyle(fontSize: 40)),
                              ),
                            ),
                            Positioned(
                              bottom: 0, right: 0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 26, height: 26,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sarah Amelia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Text(
                          'sarah.amelia@email.com',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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

                // ── Season Badge ──
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.swatchTerracotta.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: AppColors.swatchTerracotta.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('🍂', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Text(
                          'Warm Autumn · Deep & Muted',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.swatchTerracotta,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Stats ──
                Row(
                  children: [
                    _StatCard(value: '8', label: 'Analyses', icon: '🎨'),
                    const SizedBox(width: 10),
                    _StatCard(value: '24', label: 'Saved Items', icon: '💾'),
                    const SizedBox(width: 10),
                    _StatCard(value: '350', label: 'Game Score', icon: '🏆'),
                  ],
                ),
                const SizedBox(height: 20),

                // ── My Palette ──
                SectionHeader(title: 'My Color Palette'),
                const SizedBox(height: 12),
                InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Best Colors',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ColorSwatchTile(color: AppColors.swatchSienna, label: 'Sienna', size: 40),
                          ColorSwatchTile(color: AppColors.swatchCopper, label: 'Copper', size: 40),
                          ColorSwatchTile(color: AppColors.swatchMoss, label: 'Moss', size: 40),
                          ColorSwatchTile(color: AppColors.swatchCamel, label: 'Camel', size: 40),
                          ColorSwatchTile(color: AppColors.swatchBurgundy, label: 'Burgundy', size: 40),
                          ColorSwatchTile(color: AppColors.swatchTerracotta, label: 'Terra', size: 40),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Avoid Colors',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ColorSwatchTile(color: Color(0xFFC9B8E8).withOpacity(0.5), label: 'Lavndr', size: 40),
                          ColorSwatchTile(color: Color(0xFFA8C8E8).withOpacity(0.5), label: 'Ice Blue', size: 40),
                          ColorSwatchTile(color: Color(0xFFF0A8C0).withOpacity(0.5), label: 'Baby Pk', size: 40),
                          ColorSwatchTile(color: Color(0xFFB8D8C0).withOpacity(0.5), label: 'Mint', size: 40),
                          ColorSwatchTile(color: Color(0xFFD0D0D0).withOpacity(0.5), label: 'Ash', size: 40),
                          ColorSwatchTile(color: Color(0xFFE8E0FF).withOpacity(0.5), label: 'Orchid', size: 40),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Personal Info ──
                SectionHeader(title: 'Personal Info'),
                const SizedBox(height: 12),
                InfoCard(
                  child: Column(
                    children: [
                      _InfoRow(icon: Icons.person_outline_rounded, label: 'Full Name', value: 'Sarah Amelia'),
                      const Divider(height: 16),
                      _InfoRow(icon: Icons.mail_outline_rounded, label: 'Email', value: 'sarah.amelia@email.com'),
                      const Divider(height: 16),
                      _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: '+62 812 3456 7890'),
                      const Divider(height: 16),
                      _InfoRow(icon: Icons.cake_outlined, label: 'Birthday', value: '14 February 2002'),
                      const Divider(height: 16),
                      _InfoRow(icon: Icons.location_on_outlined, label: 'City', value: 'Yogyakarta, Indonesia'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Notifications ──
                SectionHeader(title: 'Notifications'),
                const SizedBox(height: 12),
                InfoCard(
                  child: Column(
                    children: [
                      _SwitchRow(
                        icon: Icons.local_offer_outlined,
                        label: 'Nearby Store Promos',
                        subtitle: 'Get notified about deals near you',
                        value: _notifPromo,
                        onChanged: (v) => setState(() => _notifPromo = v),
                      ),
                      const Divider(height: 16),
                      _SwitchRow(
                        icon: Icons.lightbulb_outline_rounded,
                        label: 'Daily Color Tips',
                        subtitle: 'Personalized beauty tips every day',
                        value: _notifTip,
                        onChanged: (v) => setState(() => _notifTip = v),
                      ),
                      const Divider(height: 16),
                      _SwitchRow(
                        icon: Icons.flash_on_outlined,
                        label: 'Flash Sale Alerts',
                        subtitle: 'International brand flash sales',
                        value: _notifSale,
                        onChanged: (v) => setState(() => _notifSale = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── App Settings ──
                SectionHeader(title: 'App Settings'),
                const SizedBox(height: 12),
                InfoCard(
                  child: Column(
                    children: [
                      _MenuRow(icon: Icons.fingerprint_rounded, label: 'Biometric Login', onTap: () {}),
                      const Divider(height: 16),
                      _MenuRow(icon: Icons.lock_outline_rounded, label: 'Change Password', onTap: () {}),
                      const Divider(height: 16),
                      _MenuRow(icon: Icons.language_outlined, label: 'Language', trailing: 'Indonesia', onTap: () {}),
                      const Divider(height: 16),
                      _MenuRow(icon: Icons.help_outline_rounded, label: 'Help & FAQ', onTap: () {}),
                      const Divider(height: 16),
                      _MenuRow(icon: Icons.info_outline_rounded, label: 'About ChromaMe', trailing: 'v1.0.0', onTap: () {}),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Logout ──
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.shield_outlined, size: 12, color: AppColors.textMuted),
                      SizedBox(width: 4),
                      Text(
                        'Data encrypted with AES-256 · Secure session',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        content: const Text(
          'Are you sure you want to logout from ChromaMe?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

// Sub-widgets
class _StatCard extends StatelessWidget {
  final String value, label, icon;
  const _StatCard({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InfoCard(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.accentDark)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: AppColors.bgMuted, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: AppColors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow({required this.icon, required this.label, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: AppColors.bgMuted, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: AppColors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.accent,
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;
  const _MenuRow({required this.icon, required this.label, required this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.bgMuted, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
          if (trailing != null)
            Text(trailing!, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
        ],
      ),
    );
  }
}