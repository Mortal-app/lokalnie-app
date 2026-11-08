import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../theme/widzew_colors.dart';
import '../theme/widzew_ui.dart';

class SosAlertsBanner extends StatelessWidget {
  final List<Announcement> alerts;
  final ValueChanged<Announcement> onOpenAlert;
  final VoidCallback? onAddAlert;

  const SosAlertsBanner({
    super.key,
    required this.alerts,
    required this.onOpenAlert,
    this.onAddAlert,
  });

  String _shortLabel(Announcement alert) {
    final category = alert.category.toLowerCase();
    if (category == Announcement.wildlifeCategory.toLowerCase()) {
      return 'Dziki · ${alert.subDistrict}';
    }
    if (alert.title.startsWith('PILNE: ')) {
      return '${alert.title.replaceFirst('PILNE: ', '')} · ${alert.subDistrict}';
    }
    return 'Ostrzeżenie · ${alert.subDistrict}';
  }

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();
    return Material(
      elevation: 3,
      color: WidzewColors.red,
      borderRadius: WidzewUi.borderRadius,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const Icon(Icons.sos, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Alerty SOS / PILNE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: alerts.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    return ActionChip(
                      key: ValueKey(
                        'sos-chip-${alert.publishedAt.toIso8601String()}',
                      ),
                      label: Text(_shortLabel(alert)),
                      onPressed: () => onOpenAlert(alert),
                      backgroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    );
                  },
                ),
              ),
              if (onAddAlert != null)
                IconButton(
                  tooltip: 'Nowy alert SOS',
                  onPressed: onAddAlert,
                  icon: const Icon(Icons.add_alert, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
