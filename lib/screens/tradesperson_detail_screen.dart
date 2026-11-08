import 'package:flutter/material.dart';

import '../models/tradesperson_marketplace.dart';
import '../theme/widzew_ui.dart';
import '../utils/neighbor_contact.dart';
import '../utils/neighbor_share.dart';
import '../utils/utf8_text_guard.dart';
import '../widgets/app_page_route.dart';
import '../widgets/quality_guarantee_badge.dart';
import '../widgets/verified_tradesperson_badge.dart';
import 'path_photo_gallery_screen.dart';
import 'tradesperson_job_request_screen.dart';
import 'tradesperson_quote_sheet.dart';

class TradespersonDetailScreen extends StatefulWidget {
  final TradespersonListing listing;
  final String clientName;
  final ValueChanged<TradespersonJobRequest> onSubmitJob;
  final ValueChanged<TradespersonReview>? onAddReview;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onOpenPortfolio;
  final VoidCallback? onOpenPriceList;
  final VoidCallback? onActivatePro;

  const TradespersonDetailScreen({
    super.key,
    required this.listing,
    required this.clientName,
    required this.onSubmitJob,
    this.onAddReview,
    this.isFavorite = false,
    this.onToggleFavorite,
    this.onOpenPortfolio,
    this.onOpenPriceList,
    this.onActivatePro,
  });

  @override
  State<TradespersonDetailScreen> createState() =>
      _TradespersonDetailScreenState();
}

class _TradespersonDetailScreenState extends State<TradespersonDetailScreen> {
  late List<TradespersonReview> _reviews;
  late bool _favorite;

  TradespersonListing get listing => widget.listing;
  String get clientName => widget.clientName;
  ValueChanged<TradespersonJobRequest> get onSubmitJob => widget.onSubmitJob;
  VoidCallback? get onOpenPortfolio => widget.onOpenPortfolio;
  VoidCallback? get onOpenPriceList => widget.onOpenPriceList;

  @override
  void initState() {
    super.initState();
    _reviews = List.of(widget.listing.reviews);
    _favorite = widget.isFavorite;
  }

  @override
  void didUpdateWidget(covariant TradespersonDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _favorite = widget.isFavorite;
    }
  }

  bool get _hasQualityGuarantee {
    if (_reviews.isEmpty) return false;
    final sum = _reviews.fold<int>(0, (total, item) => total + item.stars);
    final rating = sum / _reviews.length;
    final positive = _reviews.where((item) => item.isPositive).length;
    return rating > 4.8 && positive >= 5;
  }

  Future<void> _addReview() async {
    var stars = 5;
    var saving = false;
    final text = TextEditingController();
    final created = await showDialog<TradespersonReview>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Opinia o fachowcu'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: stars.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: '$stars / 5',
                    onChanged: (value) {
                      setDialogState(() => stars = value.round());
                    },
                  ),
                  TextField(
                    controller: text,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Krótka opinia',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Anuluj'),
                ),
                FilledButton(
                  onPressed: saving
                      ? null
                      : () {
                          setDialogState(() => saving = true);
                          Navigator.pop(
                            dialogContext,
                            TradespersonReview(
                              listingId: listing.id,
                              authorName: clientName,
                              stars: stars,
                              text: Utf8TextGuard.sanitize(text.text).isEmpty
                                  ? 'Polecam tego fachowca z Widzewa.'
                                  : Utf8TextGuard.sanitize(text.text),
                              createdAt: DateTime.now(),
                            ),
                          );
                        },
                  child: const Text('Zapisz opinię'),
                ),
              ],
            );
          },
        );
      },
    );
    text.dispose();
    if (created == null || !mounted) return;
    setState(() => _reviews = [created, ..._reviews]);
    widget.onAddReview?.call(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing.trade),
        actions: [
          IconButton(
            tooltip: 'Udostępnij profil',
            onPressed: () {
              NeighborShare.shareText(
                context,
                text: NeighborShare.tradespersonMessage(listing),
                subject: 'Polecam fachowca ${listing.displayName}',
                copiedMessage: 'Skopiowano polecenie fachowca do schowka.',
              );
            },
            icon: const Icon(Icons.share_outlined),
          ),
          if (widget.onToggleFavorite != null)
            IconButton(
              tooltip: _favorite
                  ? 'Usuń z ulubionych'
                  : 'Dodaj do ulubionych',
              onPressed: () {
                setState(() => _favorite = !_favorite);
                widget.onToggleFavorite?.call();
              },
              icon: Icon(
                _favorite ? Icons.favorite : Icons.favorite_border,
                color: _favorite
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
        ],
      ),
      body: ListView(
        padding: WidzewUi.insetsWide,
        children: [
          Text(
            listing.displayName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(listing.trade)),
              Chip(label: Text(listing.subDistrict)),
              VerifiedTradespersonBadge(visible: listing.showsVerifiedBadge),
              QualityGuaranteeBadge(visible: _hasQualityGuarantee),
              if (listing.companyVerified)
                const Chip(label: Text('NIP / dowód')),
              Chip(
                label: Text(listing.isPro ? 'PRO Aktywny' : 'PRO Wygasł'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(listing.description),
          const SizedBox(height: 8),
          Text(
            'Stawka: ${listing.rateLabel}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          if (listing.isPro && listing.phone.isNotEmpty) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.phone_outlined),
              title: Text(listing.phone),
              subtitle: const Text(
                'Numer z opłaconego profilu PRO — nie kopiuj do ogłoszeń poza aplikacją',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () =>
                        NeighborContact.callNumber(context, listing.phone),
                    icon: const Icon(Icons.call_outlined),
                    label: const Text('Zadzwoń'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => NeighborContact.sendSmsToNumber(
                      context,
                      listing.phone,
                      body:
                          'Cześć! Piszę z aplikacji Lokalnie Widzew w sprawie usługi „${listing.trade}”.',
                    ),
                    icon: const Icon(Icons.sms_outlined),
                    label: const Text('SMS'),
                  ),
                ),
              ],
            ),
          ] else
            Card(
              child: Padding(
                padding: WidzewUi.insets,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      listing.isPro
                          ? 'Numer telefonu jest ukryty w katalogu. Skorzystaj z formularza zleceń w aplikacji.'
                          : 'Bez aktywnego abonamentu fachowiec nie udostępnia numeru i nie publikuje oferty.',
                    ),
                    if (widget.onActivatePro != null) ...[
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        key: const ValueKey('activate-pro-detail'),
                        onPressed: widget.onActivatePro,
                        icon: const Icon(Icons.workspace_premium_outlined),
                        label: const Text('Aktywuj abonament PRO'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              TradespersonQuoteSheet.show(
                context,
                listing: listing,
                clientName: clientName,
                onSubmit: onSubmitJob,
              );
            },
            icon: const Icon(Icons.request_quote_outlined),
            label: const Text('Poproś o wycenę'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Zdjęcia moich prac',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (listing.isMine && onOpenPortfolio != null)
                TextButton(
                  onPressed: onOpenPortfolio,
                  child: const Text('Edytuj'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (listing.portfolio.isEmpty)
            const Text('Brak zdjęć realizacji Przed / Po.')
          else
            PortfolioRealizationStrip(
              photos: listing.portfolio,
              onOpenAt: (index) {
                Navigator.of(context).push(
                  AppPageRoute<void>(
                    builder: (_) => PathPhotoGalleryScreen(
                      photos: listing.portfolio,
                      initialIndex: index,
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Orientacyjny Cennik',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (listing.isMine && onOpenPriceList != null)
                TextButton(
                  onPressed: onOpenPriceList,
                  child: const Text('Edytuj'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (listing.priceList.isEmpty)
            const Text('Brak stawek. Fachowiec uzupełni cennik w profilu.')
          else
            Card(
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                },
                children: [
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Usługa',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Stawka',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  for (final item in listing.priceList)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(item.service),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(item.rate),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Opinie mieszkańców',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: _addReview,
                child: const Text('Dodaj opinię'),
              ),
            ],
          ),
          if (_reviews.isEmpty)
            const Text('Brak opinii. Bądź pierwszy.')
          else ...[
            Text(
              '${( _reviews.fold<int>(0, (total, item) => total + item.stars) / _reviews.length).toStringAsFixed(1)} ★ · ${_reviews.length} opinii'
              '${_hasQualityGuarantee ? ' · Gwarancja Jakości Lokalnie Widzew' : ''}',
            ),
            const SizedBox(height: 8),
            for (final review in _reviews.take(5))
              ListTile(
                key: ValueKey(
                  'review-${review.listingId}-${review.authorName}-${review.createdAt.toIso8601String()}',
                ),
                contentPadding: EdgeInsets.zero,
                title: Text('${review.stars}/5 · ${review.authorName}'),
                subtitle: Text(review.text),
              ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                AppPageRoute<void>(
                  builder: (_) => TradespersonJobRequestScreen(
                    listing: listing,
                    clientName: clientName,
                    onSubmit: onSubmitJob,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.assignment_outlined),
            label: const Text('Wyślij zlecenie w aplikacji'),
          ),
        ],
      ),
    );
  }
}
