import 'package:flutter/material.dart';

import '../models/tradesperson_marketplace.dart';
import '../theme/widzew_ui.dart';
import '../widgets/subscription_status_panel.dart';

class TradespersonSubscriptionScreen extends StatelessWidget {
  final TradespersonAccount account;
  final List<TradespersonJobRequest> jobRequests;
  final VoidCallback onRenew;
  final ValueChanged<bool> onListingPublishedChanged;

  const TradespersonSubscriptionScreen({
    super.key,
    required this.account,
    required this.jobRequests,
    required this.onRenew,
    required this.onListingPublishedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abonament Fachowca')),
      body: ListView(
        padding: WidzewUi.insetsWide.copyWith(bottom: WidzewUi.scrollBottom),
        children: [
          SubscriptionStatusPanel(account: account, onRenew: onRenew),
          const SizedBox(height: 12),
          const Text(
            'Tylko fachowcy z aktywnym abonamentem mogą publikować oferty w katalogu usług i udostępniać bezpośredni numer telefonu.',
          ),
          const SizedBox(height: 8),
          Text(
            'Symulacja płatności Blik lub kartą — 30 dni dostępu do katalogu.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Publikuj ofertę w katalogu'),
            subtitle: Text(
              account.canPublishListing
                  ? 'Wizytówka kompletna — oferta widoczna dla klientów'
                  : 'Wymagany aktywny PRO i uzupełniona wizytówka',
            ),
            value: account.listingPublished && account.canPublishListing,
            onChanged: account.canPublishListing
                ? onListingPublishedChanged
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            'Zlecenia od klientów',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (jobRequests.isEmpty)
            const Text('Brak zleceń. Klienci piszą przez formularz w katalogu.')
          else
            for (final request in jobRequests)
              Card(
                child: ListTile(
                  title: Text(request.title),
                  subtitle: Text(
                    [
                      if (request.isQuote) 'Zapytanie o wycenę',
                      if (request.preferredDay.isNotEmpty)
                        'Termin: ${request.preferredDay}',
                      '${request.clientName} · ${request.clientPhone}',
                      request.description,
                    ].join('\n'),
                  ),
                  isThreeLine: true,
                ),
              ),
        ],
      ),
    );
  }
}

class TradespersonPaymentSheet extends StatelessWidget {
  final ValueChanged<String> onPay;

  const TradespersonPaymentSheet({super.key, required this.onPay});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: WidzewUi.insetsWide,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Abonament PRO fachowca',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Wybierz metodę. To symulacja płatności — bez prawdziwego obciążenia.',
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.pin_outlined),
              title: const Text('Blik'),
              subtitle: const Text('Kod 6-cyfrowy (symulacja)'),
              onTap: () => onPay('Blik'),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card_outlined),
              title: const Text('Karta'),
              subtitle: const Text('Płatność kartą (symulacja)'),
              onTap: () => onPay('karta'),
            ),
          ],
        ),
      ),
    );
  }
}
