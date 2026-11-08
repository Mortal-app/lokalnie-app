import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class EmptyAnnouncements extends StatelessWidget {
  final String message;
  final String? hint;
  final VoidCallback? onAddAnnouncement;
  final VoidCallback? onResetFilters;
  final String? resetLabel;

  const EmptyAnnouncements({
    super.key,
    required this.message,
    this.hint,
    this.onAddAnnouncement,
    this.onResetFilters,
    this.resetLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 48,
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
  }
}
