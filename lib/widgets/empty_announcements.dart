import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class EmptyAnnouncements extends StatelessWidget {
  final String message;
  final String? hint;
  final VoidCallback? onAddAnnouncement;
  final VoidCallback? onResetFilters;
  final String? resetLabel;
  final IconData icon;
  final bool fill;

  const EmptyAnnouncements({
    super.key,
    required this.message,
    this.hint,
    this.onAddAnnouncement,
    this.onResetFilters,
    this.resetLabel,
    this.icon = Icons.campaign_outlined,
    this.fill = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: fill ? 64 : 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (hint != null) ...[
            const SizedBox(height: 8),
            Text(
              hint!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          if (onResetFilters != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              key: const ValueKey('reset-filters'),
              onPressed: onResetFilters,
              icon: const Icon(Icons.filter_alt_off),
              label: Text(resetLabel ?? context.tr('showAll')),
            ),
          ],
          if (onAddAnnouncement != null) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAddAnnouncement,
              icon: const Icon(Icons.add),
              label: Text(context.tr('addAnnouncement')),
            ),
          ],
        ],
      ),
    );
    if (!fill) return content;
    return Center(child: content);
  }
}
