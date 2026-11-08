import 'package:flutter/material.dart';

import '../models/tradesperson_marketplace.dart';
import '../theme/widzew_ui.dart';
import '../widgets/app_page_route.dart';
import '../widgets/tradesperson_listing_card.dart';
import 'neighbor_help_board_screen.dart';
import 'tradesperson_detail_screen.dart';

class TradespersonCatalogScreen extends StatefulWidget {
  final TradespersonAccount account;
  final String clientName;
  final List<NeighborHelpPost> helpPosts;
  final List<TradespersonReview> reviews;
  final List<String> favoriteListingIds;
  final int catalogTabIndex;
  final ValueChanged<TradespersonJobRequest> onSubmitJob;
  final ValueChanged<TradespersonReview>? onAddReview;
  final VoidCallback onOpenSubscription;
  final VoidCallback onPublishMine;
  final ValueChanged<NeighborHelpPost> onAddHelpPost;
  final ValueChanged<NeighborHelpPost> onAcceptHelpPost;
  final ValueChanged<String> onToggleFavorite;
  final List<String> searchHistory;
  final ValueChanged<String>? onRecordSearch;
  final ValueChanged<String>? onRemoveSearch;
  final VoidCallback? onOpenPortfolio;
  final VoidCallback? onOpenPriceList;

  const TradespersonCatalogScreen({
    super.key,
    required this.account,
    required this.clientName,
    required this.helpPosts,
    this.reviews = const [],
    this.favoriteListingIds = const [],
    this.catalogTabIndex = 0,
    required this.onSubmitJob,
    this.onAddReview,
    required this.onOpenSubscription,
    required this.onPublishMine,
    required this.onAddHelpPost,
    required this.onAcceptHelpPost,
    required this.onToggleFavorite,
    this.searchHistory = const [],
    this.onRecordSearch,
    this.onRemoveSearch,
    this.onOpenPortfolio,
    this.onOpenPriceList,
  });

  static const districtFilters = [
    'Wszystkie',
    'Stary Widzew',
    'Widzew Wschód',
    'Olechów',
    'Janów',
  ];

  @override
  State<TradespersonCatalogScreen> createState() =>
      _TradespersonCatalogScreenState();
}

class _TradespersonCatalogScreenState extends State<TradespersonCatalogScreen>
    with SingleTickerProviderStateMixin {
  String? _trade;
  String _district = 'Wszystkie';
  String _searchQuery = '';
  late final TextEditingController _search;
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
    _tabs = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.catalogTabIndex.clamp(0, 2),
    );
    _tabs.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant TradespersonCatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.catalogTabIndex != widget.catalogTabIndex) {
      _tabs.animateTo(widget.catalogTabIndex.clamp(0, 2));
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  List<TradespersonListing> get _allListings {
    return TradespersonCatalog.visible(
      widget.account,
      extraReviews: widget.reviews,
    );
  }

  List<TradespersonListing> get _listings {
    final query = _searchQuery.trim().toLowerCase();
    return _allListings.where((item) {
      final matchesTrade = _trade == null || item.trade == _trade;
      final matchesDistrict = item.servesDistrict(_district);
      final haystack =
          '${item.displayName} ${item.trade} ${item.description} ${item.subDistrict}'
              .toLowerCase();
      final matchesQuery = query.isEmpty || haystack.contains(query);
      return matchesTrade && matchesDistrict && matchesQuery;
    }).toList();
  }

  List<TradespersonListing> get _favorites {
    return _allListings
        .where((item) => widget.favoriteListingIds.contains(item.id))
        .toList();
  }

  void _openListing(TradespersonListing listing) {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => TradespersonDetailScreen(
          listing: listing,
          clientName: widget.clientName,
          onSubmitJob: widget.onSubmitJob,
          onAddReview: widget.onAddReview,
          isFavorite: widget.favoriteListingIds.contains(listing.id),
          onToggleFavorite: () => widget.onToggleFavorite(listing.id),
          onOpenPortfolio: listing.isMine ? widget.onOpenPortfolio : null,
          onOpenPriceList: listing.isMine ? widget.onOpenPriceList : null,
          onActivatePro: listing.isMine && !listing.isPro
              ? widget.onOpenSubscription
              : null,
        ),
      ),
    );
  }

  void _applySearch(String value, {bool record = false}) {
    setState(() => _searchQuery = value);
    _search.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    if (record) widget.onRecordSearch?.call(value);
  }

  Widget _listingCard(TradespersonListing listing) {
    return TradespersonListingCard(
      listing: listing,
      isFavorite: widget.favoriteListingIds.contains(listing.id),
      onOpen: () => _openListing(listing),
      onToggleFavorite: () => widget.onToggleFavorite(listing.id),
      onActivatePro: listing.isMine && !listing.isPro
          ? widget.onOpenSubscription
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final listings = _listings;
    final favorites = _favorites;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Fachowców'),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Katalog'),
            Tab(text: 'Szukam Fachowca'),
            Tab(text: 'Ulubieni'),
          ],
        ),
      ),
      floatingActionButton: _tabs.index == 0 && widget.account.isTradesperson
          ? FloatingActionButton.extended(
              onPressed: widget.account.canPublishListing
                  ? widget.onPublishMine
                  : widget.onOpenSubscription,
              icon: const Icon(Icons.add),
              label: const Text('Publikuj ofertę'),
            )
          : null,
      body: TabBarView(
        controller: _tabs,
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
            children: [
              const Text(
                'Usługi remontowo-naprawcze na Widzewie. W katalogu tylko fachowcy z aktywnym abonamentem PRO.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Szukaj fachowca (np. hydraulik, zamek)',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Wyczyść',
                          icon: const Icon(Icons.close),
                          onPressed: () => _applySearch(''),
                        ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
                onSubmitted: (value) => _applySearch(value, record: true),
              ),
              if (widget.searchHistory.isNotEmpty &&
                  _searchQuery.trim().isEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Ostatnie wyszukiwania',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final phrase in widget.searchHistory.take(5))
                      InputChip(
                        label: Text(phrase),
                        onPressed: () => _applySearch(phrase, record: true),
                        onDeleted: widget.onRemoveSearch == null
                            ? null
                            : () => widget.onRemoveSearch!(phrase),
                      ),
                  ],
                ),
              ],
              if (widget.account.isTradesperson) ...[
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.workspace_premium_outlined),
                  title: Text(
                    'Twój status PRO: ${widget.account.subscriptionStatusLabel}',
                  ),
                  subtitle: Text(
                    widget.account.isProActive
                        ? (widget.account.listingPublished
                            ? 'Oferta jest widoczna w katalogu'
                            : 'Możesz opublikować ofertę')
                        : 'Kontakt i wysoka pozycja wymagają aktywnego PRO',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: widget.onOpenSubscription,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Osiedle',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final district
                      in TradespersonCatalogScreen.districtFilters)
                    FilterChip(
                      key: ValueKey('district-filter-$district'),
                      label: Text(district),
                      selected: _district == district,
                      onSelected: (_) => setState(() => _district = district),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  FilterChip(
                    label: const Text('Wszystkie branże'),
                    selected: _trade == null,
                    onSelected: (_) => setState(() => _trade = null),
                  ),
                  for (final trade in TradespersonTrade.values.take(3))
                    FilterChip(
                      label: Text(trade),
                      selected: _trade == trade,
                      onSelected: (_) => setState(
                        () => _trade = _trade == trade ? null : trade,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (listings.isEmpty)
                Padding(
                  padding: WidzewUi.insetsWide,
                  child: Text(
                    _district == 'Wszystkie'
                        ? 'Brak zweryfikowanych fachowców PRO w tej branży.'
                        : 'Brak fachowców obsługujących osiedle $_district.',
                  ),
                )
              else
                for (final listing in listings) _listingCard(listing),
            ],
          ),
          NeighborHelpBoardScreen(
            posts: widget.helpPosts,
            isProActive: widget.account.isProActive,
            clientName: widget.clientName,
            tradespersonName: widget.account.card.displayName.isEmpty
                ? widget.clientName
                : widget.account.card.displayName,
            onAdd: widget.onAddHelpPost,
            onAccept: widget.onAcceptHelpPost,
            onNeedSubscription: widget.onOpenSubscription,
          ),
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
            children: [
              const Text(
                'Ulubieni Fachowcy — Twoi zapisani, zaufani wykonawcy z Widzewa.',
              ),
              const SizedBox(height: 12),
              if (favorites.isEmpty)
                const Padding(
                  padding: WidzewUi.insetsWide,
                  child: Text(
                    'Brak ulubionych. Dodaj fachowca serduszkiem na karcie lub w profilu.',
                  ),
                )
              else
                for (final listing in favorites) _listingCard(listing),
            ],
          ),
        ],
      ),
    );
  }
}
