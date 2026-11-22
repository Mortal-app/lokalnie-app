import 'dart:async';

import 'package:flutter/material.dart';

import '../models/pro_subscription.dart';
import '../models/tradesperson_marketplace.dart';
import '../services/pro_subscription_service.dart';
import '../theme/widzew_ui.dart';
import '../widgets/subscription_status_panel.dart';

class TradespersonSubscriptionScreen extends StatefulWidget {
  final TradespersonAccount account;
  final List<TradespersonJobRequest> jobRequests;
  final VoidCallback onRenew;
  final VoidCallback? onRestore;
  final ValueChanged<bool> onListingPublishedChanged;
  final ProOffer? offer;

  const TradespersonSubscriptionScreen({
    super.key,
    required this.account,
    required this.jobRequests,
    required this.onRenew,
    required this.onListingPublishedChanged,
    this.onRestore,
    this.offer,
  });

  @override
  State<TradespersonSubscriptionScreen> createState() =>
      _TradespersonSubscriptionScreenState();
}

class _TradespersonSubscriptionScreenState
    extends State<TradespersonSubscriptionScreen> {
  late ProOffer _offer;
  var _loadingOffer = true;
  var _busy = false;

  static const _benefits = [
    'Wizytówka w katalogu fachowców okolicy',
    'Widoczny numer telefonu na profilu',
    'Alerty o nowych zleceniach z giełdy',
    'Przyjmowanie zapytań „Szukam fachowca”',
    'Odznaka Zweryfikowany Fachowiec',
  ];

  @override
  void initState() {
    super.initState();
    _offer = widget.offer ?? ProOffer.fallback;
    _loadingOffer = widget.offer == null;
    if (widget.offer == null) {
      unawaited(_loadOffer());
    }
  }

  Future<void> _loadOffer() async {
    final offer = await ProSubscriptionService.instance.loadOffer();
    if (!mounted) return;
    setState(() {
      _offer = offer;
      _loadingOffer = false;
    });
  }

  Future<void> _restore() async {
    if (_busy) return;
    final custom = widget.onRestore;
    if (custom != null) {
      custom();
      return;
    }
    setState(() => _busy = true);
    final result = await ProSubscriptionService.instance.restore();
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(result.message)));
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.account.isProActive;
    return Scaffold(
      appBar: AppBar(title: const Text('Abonament Fachowca')),
      body: ListView(
        padding: WidzewUi.insetsWide.copyWith(bottom: WidzewUi.scrollBottom),
        children: [
          SubscriptionStatusPanel(
            account: widget.account,
            onRenew: widget.onRenew,
            onRestore: _restore,
          ),
          const SizedBox(height: 12),
          Card(
            key: const ValueKey('pro-price-card'),
            child: Padding(
              padding: WidzewUi.insetsWide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Konto PRO',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    active ? 'Status: aktywne' : 'Status: nieaktywne',
                    key: const ValueKey('pro-account-status'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  if (_loadingOffer)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    )
                  else
                    Text(
                      _offer.priceLabel,
                      key: const ValueKey('pro-price-label'),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    _offer.fromStore
                        ? 'Cena z Google Play Billing'
                        : 'Cena orientacyjna — oferta ${ProProduct.id} pojawi się w sklepie po publikacji w Play Console.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(_offer.description),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Co odblokowuje PRO',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final benefit in _benefits)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_outline),
              title: Text(benefit),
            ),
          const SizedBox(height: 16),
          const Text(
            'Tylko fachowcy z aktywnym abonamentem mogą publikować oferty w katalogu usług i udostępniać bezpośredni numer telefonu. Płatność idzie przez oficjalny Google Play Billing — bez prowizji od zleceń.',
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Publikuj ofertę w katalogu'),
            subtitle: Text(
              widget.account.canPublishListing
                  ? 'Wizytówka kompletna — oferta widoczna dla klientów'
                  : 'Wymagany aktywny PRO i uzupełniona wizytówka',
            ),
            value:
                widget.account.listingPublished &&
                widget.account.canPublishListing,
            onChanged: widget.account.canPublishListing
                ? widget.onListingPublishedChanged
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            'Zlecenia od klientów',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (widget.jobRequests.isEmpty)
            const Text('Brak zleceń. Klienci piszą przez formularz w katalogu.')
          else
            for (final request in widget.jobRequests)
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
