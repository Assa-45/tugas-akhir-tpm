import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ──────────────────────────────────────────────
// Section Header
// ──────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            )),
        const Spacer(),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                )),
          ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Color Swatch Tile
// ──────────────────────────────────────────────
class ColorSwatchTile extends StatelessWidget {
  final Color color;
  final String? label;
  final double size;
  final double radius;
  final bool showBorder;

  const ColorSwatchTile({
    super.key,
    required this.color,
    this.label,
    this.size = 36,
    this.radius = 8,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
            border: showBorder ? Border.all(color: AppColors.border, width: 0.5) : null,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(label!,
              style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Info Card
// ──────────────────────────────────────────────
class InfoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  const InfoCard({super.key, required this.child, this.padding, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color ?? AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 0.5),
      ),
      child: child,
    );
  }
}

// ──────────────────────────────────────────────
// Pastel Badge
// ──────────────────────────────────────────────
class PastelBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;

  const PastelBadge({super.key, required this.label, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? AppColors.primaryLight,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColors.primaryDark,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Divider with label
// ──────────────────────────────────────────────
class LabelDivider extends StatelessWidget {
  final String label;
  const LabelDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Harmony Bar
// ──────────────────────────────────────────────
class HarmonyBar extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final double value; // 0.0 to 1.0

  const HarmonyBar({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(leftLabel,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              textAlign: TextAlign.right),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.bgMuted,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryLight, AppColors.accent],
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * value * 0.55,
                top: -3,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.4),
                        blurRadius: 4,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 48,
          child: Text(rightLabel,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Store Card
// ──────────────────────────────────────────────
class StoreCard extends StatelessWidget {
  final String name;
  final String category;
  final String distance;
  final String hours;
  final bool isOpen;
  final Color iconBg;
  final IconData icon;
  final VoidCallback? onTap;

  const StoreCard({
    super.key,
    required this.name,
    required this.category,
    required this.distance,
    required this.hours,
    required this.isOpen,
    required this.iconBg,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InfoCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.accentDark, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      PastelBadge(
                        label: category,
                        color: AppColors.secondaryLight,
                        textColor: AppColors.accentDark,
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isOpen ? AppColors.success : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOpen ? 'Open · $hours' : 'Closed',
                        style: TextStyle(
                          fontSize: 11,
                          color: isOpen ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(distance,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    )),
                const Text('km',
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}