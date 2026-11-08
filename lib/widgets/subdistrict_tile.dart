import 'package:flutter/material.dart';

import '../theme/widzew_colors.dart';
import '../theme/widzew_ui.dart';

class SubdistrictTile extends StatelessWidget {
  final String name;
  final int activeCount;
  final int alertCount;

  const SubdistrictTile({
    super.key,
    required this.name,
    required this.activeCount,
    required this.alertCount,
  });

  @override
  Widget build(BuildContext context) {
    final hasAlert = alertCount > 0;
    return Card(
      margin: EdgeInsets.zero,
      color: hasAlert ? WidzewColors.alertFill : null,
      shape: RoundedRectangleBorder(
        borderRadius: WidzewUi.borderRadius,
        side: hasAlert
            ? const BorderSide(color: WidzewColors.alertOrange)
            : BorderSide.none,
      ),
      child: Padding(
        padding: WidzewUi.insets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: hasAlert ? WidzewColors.alertOrange : WidzewColors.red,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    name,
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Aktywne: $activeCount',
              softWrap: true,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Alerty: $alertCount',
              softWrap: true,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
