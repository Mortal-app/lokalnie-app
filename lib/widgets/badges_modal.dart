import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/neighbor_badge.dart';
import '../theme/widzew_colors.dart';
import '../theme/widzew_ui.dart';

class BadgesModal extends StatelessWidget {
  const BadgesModal({
    super.key,
    required this.badges,
    this.pointsLabel,
  });

  final List<NeighborBadge> badges;
  final String? pointsLabel;

  static Future<void> show(
    BuildContext context, {
    required List<NeighborBadge> badges,
    String? pointsLabel,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final height = MediaQuery.sizeOf(sheetContext).height;
        return WidzewUi.barrierDismissibleSheet(
          context: sheetContext,
          child: Material(
            color: Theme.of(sheetContext).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(WidzewUi.radius),
            ),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: height * 0.78,
                child: BadgesModal(
                  badges: badges,
                  pointsLabel: pointsLabel,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final earned = badges.where((badge) => badge.unlocked).toList();
    final locked = badges.where((badge) => !badge.unlocked).toList();
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr('yourBadges'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            context.tr('badgesEarnedCount', {
              'earned': '${earned.length}',
              'total': '${badges.length}',
            }),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (pointsLabel != null && pointsLabel!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              pointsLabel!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 20),
          _sectionTitle(context, context.tr('badgesEarnedSection')),
          const SizedBox(height: 8),
          for (final badge in earned)
            _BadgeTile(badge: badge, earned: true),
          const SizedBox(height: 20),
          _sectionTitle(context, context.tr('badgesLockedSection')),
          const SizedBox(height: 8),
          for (final badge in locked)
            _BadgeTile(badge: badge, earned: false),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge, required this.earned});

  final NeighborBadge badge;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.45);
    final ink = earned ? WidzewColors.red : muted;
    final fill = earned
        ? WidzewColors.red.withValues(alpha: 0.12)
        : scheme.surfaceContainerHighest;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: earned
            ? scheme.surfaceContainerHighest
            : scheme.surfaceContainerHigh.withValues(alpha: 0.65),
        shape: WidzewUi.shape,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: fill,
                child: Icon(badge.icon, color: ink, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badge.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: earned ? null : muted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badge.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: earned ? scheme.onSurfaceVariant : muted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
