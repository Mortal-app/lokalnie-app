import 'package:flutter/material.dart';

import '../models/tradesperson_marketplace.dart';
import '../theme/widzew_ui.dart';
import '../utils/neighbor_contact.dart';
import 'quality_guarantee_badge.dart';
import 'verified_tradesperson_badge.dart';

class TradespersonListingCard extends StatelessWidget {
  final TradespersonListing listing;
  final bool isFavorite;
  final VoidCallback onOpen;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onActivatePro;

  const TradespersonListingCard({
    super.key,
    required this.listing,
    required this.isFavorite,
    required this.onOpen,
    required this.onToggleFavorite,
    this.onActivatePro,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        key: ValueKey('tradesperson-${listing.id}'),
        margin: const EdgeInsets.only(bottom: 10),
        elevation: 0,
        shape: WidzewUi.shape,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          borderRadius: WidzewUi.borderRadius,
          onTap: onOpen,
          child: Padding(
            padding: WidzewUi.insets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        listing.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (listing.isPro)
                      Padding(
                        padding: const EdgeInsets.only(right: 4, top: 10),
                        child: Icon(
                          Icons.workspace_premium,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    IconButton(
                      tooltip: isFavorite
                          ? 'Usuń z ulubionych'
                          : 'Dodaj do ulubionych',
                      onPressed: onToggleFavorite,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${listing.trade} · ${listing.subDistrict} · ${listing.rateLabel}',
                ),
                const SizedBox(height: 8),
                Text(listing.description),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    VerifiedTradespersonBadge(
                      visible: listing.showsVerifiedBadge,
                      compact: true,
                    ),
                    QualityGuaranteeBadge(
                      visible: listing.hasQualityGuarantee,
                      compact: true,
                    ),
                    if (listing.isMine) const Chip(label: Text('Twoja oferta')),
                    Chip(label: Text(listing.isPro ? 'PRO' : 'PRO wyłączony')),
                  ],
                ),
                const SizedBox(height: 8),
                if (listing.isPro)
                  listing.phone.isEmpty
                      ? const Text('Brak numeru telefonu w wizytówce.')
                      : Row(
                          children: [
                            const Icon(Icons.phone_outlined, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(listing.phone)),
                            IconButton(
                              tooltip: 'Zadzwoń',
                              onPressed: () => NeighborContact.callNumber(
                                context,
                                listing.phone,
                              ),
                              icon: const Icon(Icons.call_outlined),
                            ),
                            IconButton(
                              tooltip: 'SMS',
                              onPressed: () => NeighborContact.sendSmsToNumber(
                                context,
                                listing.phone,
                                body:
                                    'Cześć! Piszę z aplikacji Lokalnie w sprawie usługi „${listing.trade}”.',
                              ),
                              icon: const Icon(Icons.sms_outlined),
                            ),
                          ],
                        )
                else
                  Card(
                    margin: EdgeInsets.zero,
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Numer telefonu i bezpośredni kontakt są zablokowane bez aktywnego abonamentu PRO.',
                          ),
                          if (onActivatePro != null) ...[
                            const SizedBox(height: 8),
                            FilledButton.icon(
                              key: ValueKey('activate-pro-${listing.id}'),
                              onPressed: onActivatePro,
                              icon: const Icon(
                                Icons.workspace_premium_outlined,
                              ),
                              label: const Text('Aktywuj abonament PRO'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
