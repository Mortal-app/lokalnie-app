import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalnie_widzew/models/tradesperson_marketplace.dart';
import 'package:lokalnie_widzew/screens/neighbor_help_board_screen.dart';
import 'package:lokalnie_widzew/screens/tradesperson_catalog_screen.dart';
import 'package:lokalnie_widzew/screens/tradesperson_detail_screen.dart';
import 'package:lokalnie_widzew/screens/tradesperson_pro_benefits_screen.dart';
import 'package:lokalnie_widzew/screens/tradesperson_subscription_screen.dart';
import 'package:lokalnie_widzew/widgets/tradesperson_listing_card.dart';
import 'package:lokalnie_widzew/services/tradesperson_store.dart';
import 'package:lokalnie_widzew/services/local_image_compressor.dart';
import 'package:lokalnie_widzew/utils/money_input.dart';
import 'package:lokalnie_widzew/utils/privacy_log.dart';
import 'package:lokalnie_widzew/utils/relative_time.dart';
import 'package:lokalnie_widzew/utils/utf8_text_guard.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _catalog() {
  return MaterialApp(
    home: TradespersonCatalogScreen(
      account: const TradespersonAccount(),
      clientName: 'Sąsiad z Widzewa',
      helpPosts: NeighborHelpPost.seeded(),
      onSubmitJob: (_) {},
      onOpenSubscription: () {},
      onPublishMine: () {},
      onAddHelpPost: (_) {},
      onAcceptHelpPost: (_) {},
      onToggleFavorite: (_) {},
    ),
  );
}

void main() {
  test('RelativeTime formats minutes, hours and yesterday', () {
    final now = DateTime(2026, 11, 4, 22);
    expect(
      RelativeTime.format(now.subtract(const Duration(minutes: 10)), now: now),
      '10 minut temu',
    );
    expect(
      RelativeTime.format(now.subtract(const Duration(hours: 2)), now: now),
      '2 godziny temu',
    );
    expect(RelativeTime.format(DateTime(2026, 11, 3, 9), now: now), 'Wczoraj');
  });

  test('tradesperson account defaults to inactive PRO', () {
    const account = TradespersonAccount();
    expect(account.isPro, isFalse);
    expect(account.subscriptionExpiryDate, isNull);
    expect(account.isProActive, isFalse);
    expect(account.subscriptionStatusLabel, 'Nieaktywny');
  });

  test('pro flag and expiry date round-trip through json', () {
    final expiry = DateTime(2026, 12, 1, 12);
    final account = TradespersonAccount(
      isTradesperson: true,
      isPro: true,
      subscriptionExpiryDate: expiry,
    );
    final roundtrip = TradespersonAccount.fromJson(account.toJson());
    expect(roundtrip.isPro, isTrue);
    expect(roundtrip.subscriptionExpiryDate, expiry);
    expect(roundtrip.isProActive, isTrue);

    final legacy = TradespersonAccount.fromJson({
      'isTradesperson': true,
      'subscriptionExpiresAt': DateTime.now()
          .add(const Duration(days: 10))
          .toIso8601String(),
    });
    expect(legacy.isPro, isTrue);
    expect(legacy.subscriptionExpiryDate, isNotNull);
  });

  test('catalog ranks PRO listings first and locks non-PRO own listing', () {
    final account = TradespersonAccount(
      isTradesperson: true,
      isPro: false,
      card: const TradespersonCard(
        displayName: 'Jan Kowalski',
        trade: 'Hydraulika',
        description: 'Awarie na Olechowie',
        rateLabel: 'od 120 zł',
      ),
    );
    final listings = TradespersonCatalog.visible(account);
    expect(listings.first.isPro, isTrue);
    expect(listings.last.isMine, isTrue);
    expect(listings.last.isPro, isFalse);
    expect(listings.where((item) => item.isMine), hasLength(1));
  });

  test('marketplace json with empty and missing keys does not throw', () {
    final empty = MarketplaceState.fromJson(null);
    expect(empty.account.isTradesperson, isFalse);
    expect(empty.account.isPro, isFalse);
    expect(empty.favoriteListingIds, isEmpty);

    final parsed = MarketplaceState.fromJson({
      'account': <String, Object?>{},
      'jobRequests': null,
      'helpPosts': <Object?>[],
      'reviews': <Object?>[],
    });
    expect(parsed.account.card.displayName, isEmpty);
    expect(parsed.boardPosts, isNotEmpty);
  });

  test('quality guarantee requires rating above 4.8 and five positives', () {
    final listings = TradespersonCatalog.visible(const TradespersonAccount());
    final hydraulik = listings.firstWhere(
      (item) => item.id == 'pro-hydraulik-olechow',
    );
    final locksmith = listings.firstWhere(
      (item) => item.id == 'pro-zamek-janow',
    );
    expect(hydraulik.hasQualityGuarantee, isTrue);
    expect(locksmith.hasQualityGuarantee, isFalse);
  });

  test(
    'tradesperson store ignores corrupt SharedPreferences payload',
    () async {
      SharedPreferences.setMockInitialValues({
        TradespersonStore.key: '{not-json',
      });
      final loaded = await TradespersonStore.load();
      expect(loaded.helpPosts, isEmpty);
      expect(loaded.account.isProActive, isFalse);
    },
  );

  test('marketplace prunes giełda posts older than 30 days', () {
    final now = DateTime(2026, 11, 6, 20);
    final state = MarketplaceState(
      helpPosts: [
        NeighborHelpPost(
          id: 'fresh',
          title: 'Nowe zlecenie',
          description: 'Dziś',
          subDistrict: 'Olechów',
          clientName: 'Kasia',
          createdAt: DateTime(2026, 10, 20),
        ),
        NeighborHelpPost(
          id: 'stale',
          title: 'Stare zlecenie',
          description: 'Sprzed miesiąca',
          subDistrict: 'Janów',
          clientName: 'Marek',
          createdAt: DateTime(2026, 9, 1),
        ),
      ],
      jobRequests: [
        TradespersonJobRequest(
          id: 'job-old',
          listingId: 'pro-hydraulik-olechow',
          tradespersonName: 'Marek',
          clientName: 'Ania',
          title: 'Wycena',
          description: 'Stara',
          clientPhone: '',
          createdAt: DateTime(2026, 9, 20),
        ),
      ],
    );
    final pruned = state.prunedExpired(now: now);
    expect(pruned.helpPosts.map((item) => item.id), ['fresh']);
    expect(pruned.jobRequests, isEmpty);
    expect(state.activeHelpPosts(now: now).map((item) => item.id), ['fresh']);
  });

  test('privacy log masks phones and emails', () {
    expect(
      PrivacyLog.mask('Zadzwoń +48 512 100 200 lub ania@widzew.pl'),
      'Zadzwoń [telefon] lub [email]',
    );
  });

  test('utf8 guard strips control characters from job text', () {
    expect(
      Utf8TextGuard.sanitize('Cieknie\u0000 kran\x07\nwieczór'),
      'Cieknie kran\nwieczór',
    );
  });

  test('image compressor returns original path when file is missing', () async {
    final path = await LocalImageCompressor.compressFile(
      'definitely-missing-preview.jpg',
    );
    expect(path, 'definitely-missing-preview.jpg');
  });

  test('money input accepts digits with comma or dot', () {
    expect(MoneyInput.isValid('120'), isTrue);
    expect(MoneyInput.isValid('120,50'), isTrue);
    expect(MoneyInput.isValid('120.5'), isTrue);
    expect(MoneyInput.isValid('od 120 zł'), isFalse);
    expect(MoneyInput.isValid('12.345'), isFalse);
    expect(MoneyInput.asRateLabel('80,5'), '80,5 zł');
  });

  testWidgets('catalog renders listings without district filters', (
    tester,
  ) async {
    await tester.pumpWidget(_catalog());
    await tester.pumpAndSettle();

    expect(find.text('Katalog Fachowców'), findsOneWidget);
    expect(find.text('Hydraulik Olechów – Marek Nowak'), findsOneWidget);
    expect(find.text('Gwarancja Jakości'), findsWidgets);
    expect(find.text('Szukam Fachowca'), findsOneWidget);
    expect(find.text('Ulubieni'), findsOneWidget);
    expect(find.byKey(const ValueKey('district-filter-Janów')), findsNothing);
    expect(find.text('Osiedle'), findsNothing);
  });

  testWidgets('job board shows urgent badge for seeded lock request', (
    tester,
  ) async {
    await tester.pumpWidget(_catalog());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Szukam Fachowca'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Szukam Fachowca'), findsWidgets);
    expect(find.text('Pilne'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('help-post-help-zamek-janow')),
      findsOneWidget,
    );
    expect(find.text('Odpowiedz / Przyjmij zlecenie'), findsWidgets);
  });

  testWidgets('subscription panel shows remaining days and renew action', (
    tester,
  ) async {
    final account = TradespersonAccount(
      isTradesperson: true,
      isPro: true,
      subscriptionExpiryDate: DateTime.now().add(const Duration(days: 12)),
      card: const TradespersonCard(
        displayName: 'Jan Kowalski',
        trade: 'Hydraulika',
        description: 'Awarie na Olechowie',
        rateLabel: 'od 120 zł',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: TradespersonSubscriptionScreen(
          account: account,
          jobRequests: const [],
          onRenew: () {},
          onListingPublishedChanged: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Status Abonamentu'), findsOneWidget);
    expect(find.text('Aktywny'), findsWidgets);
    expect(find.text('Przedłuż subskrypcję'), findsOneWidget);
    expect(find.textContaining('Pozostało'), findsOneWidget);
  });

  testWidgets('PRO benefits and tradesperson profile render', (tester) async {
    final listing = TradespersonCatalog.seeded().first;

    await tester.pumpWidget(
      MaterialApp(
        home: TradespersonDetailScreen(
          listing: listing,
          clientName: 'Sąsiad',
          onSubmitJob: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(listing.displayName), findsOneWidget);
    expect(find.text('Poproś o wycenę'), findsOneWidget);
    expect(find.text('Zweryfikowany Fachowiec'), findsOneWidget);
    expect(find.byTooltip('Udostępnij profil'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(home: TradespersonProBenefitsScreen(onBecomePro: () {})),
    );
    await tester.pumpAndSettle();
    expect(find.text('Dlaczego warto zostać Fachowcem PRO'), findsOneWidget);
    final becomePro = find.text('Chcę pakiet PRO');
    await tester.scrollUntilVisible(becomePro, 300);
    expect(becomePro, findsOneWidget);
  });

  testWidgets('listing card hides contact without PRO and shows activate', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TradespersonListingCard(
            listing: const TradespersonListing(
              id: 'mine-listing',
              displayName: 'Jan Kowalski',
              trade: 'Hydraulika',
              description: 'Awarie na Olechowie',
              rateLabel: 'od 120 zł',
              phone: '+48 600 000 000',
              subDistrict: 'Olechów',
              isPro: false,
              isMine: true,
            ),
            isFavorite: false,
            onOpen: () {},
            onToggleFavorite: () {},
            onActivatePro: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aktywuj abonament PRO'), findsOneWidget);
    expect(find.text('+48 600 000 000'), findsNothing);
    expect(find.byTooltip('Zadzwoń'), findsNothing);
    expect(find.byTooltip('SMS'), findsNothing);
  });

  testWidgets('PRO listing card shows phone, call and SMS', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TradespersonListingCard(
            listing: const TradespersonListing(
              id: 'pro-hydraulik-olechow',
              displayName: 'Hydraulik Olechów – Marek Nowak',
              trade: 'Hydraulika',
              description: 'Awarie',
              rateLabel: 'od 120 zł',
              phone: '+48 600 111 222',
              subDistrict: 'Olechów',
            ),
            isFavorite: false,
            onOpen: () {},
            onToggleFavorite: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('+48 600 111 222'), findsOneWidget);
    expect(find.byTooltip('Zadzwoń'), findsOneWidget);
    expect(find.byTooltip('SMS'), findsOneWidget);
    expect(find.text('Aktywuj abonament PRO'), findsNothing);
  });

  testWidgets('inactive subscription panel offers PRO activation', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TradespersonSubscriptionScreen(
          account: const TradespersonAccount(isTradesperson: true),
          jobRequests: const [],
          onRenew: () {},
          onListingPublishedChanged: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nieaktywny'), findsWidgets);
    expect(find.text('Aktywuj abonament PRO'), findsOneWidget);
  });

  testWidgets('help board blocks accept without PRO', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NeighborHelpBoardScreen(
            posts: NeighborHelpPost.seeded(),
            isProActive: false,
            clientName: 'Sąsiad',
            tradespersonName: 'Hydraulik',
            onAdd: (_) {},
            onAccept: (_) {},
            onNeedSubscription: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Odpowiedz / Przyjmij zlecenie').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('aktywnym abonamentem PRO'), findsOneWidget);
  });
}
