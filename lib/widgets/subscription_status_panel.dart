import 'package:flutter/material.dart';

import '../models/tradesperson_marketplace.dart';
import '../theme/widzew_ui.dart';

class SubscriptionStatusPanel extends StatelessWidget {
  final TradespersonAccount account;
  final VoidCallback onRenew;
  final VoidCallback? onOpenDetails;

  const SubscriptionStatusPanel({
    super.key,
    required this.account,
    required this.onRenew,
    this.onOpenDetails,
  });

  @override
  Widget build(BuildContext context) {
    final active = account.isProActive;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: WidzewUi.insetsWide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Status Abonamentu',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  active ? Icons.verified_outlined : Icons.timer_off_outlined,
                  color: active ? scheme.primary : scheme.error,
                ),
                const SizedBox(width: 8),
                Chip(label: Text(account.subscriptionStatusLabel)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              active
                  ? 'Pakiet ważny do ${account.expiryDateLabel}'
                  : account.subscriptionExpiryDate == null
                  ? 'Abonament PRO nieaktywny — wykup dostęp, żeby publikować oferty i numer.'
                  : 'Pakiet wygasł — odnów, żeby publikować oferty i numer.',
            ),
            Text(
              active
                  ? 'Pozostało ${account.remainingDays} dni'
                  : 'Pozostało 0 dni',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              key: const ValueKey('activate-pro-subscription'),
              onPressed: onRenew,
              icon: const Icon(Icons.payments_outlined),
              label: Text(
                active ? 'Przedłuż subskrypcję' : 'Aktywuj abonament PRO',
              ),
            ),
            if (onOpenDetails != null)
              TextButton(
                onPressed: onOpenDetails,
                child: const Text('Szczegóły pakietu PRO'),
              ),
          ],
        ),
      ),
    );
  }
}
