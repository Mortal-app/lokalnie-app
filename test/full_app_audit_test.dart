import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalnie_widzew/l10n/app_locale.dart';
import 'package:lokalnie_widzew/l10n/app_localizations.dart';
import 'package:lokalnie_widzew/main.dart';
import 'package:lokalnie_widzew/models/announcement.dart';
import 'package:lokalnie_widzew/models/pro_subscription.dart';
import 'package:lokalnie_widzew/models/tradesperson_marketplace.dart';
import 'package:lokalnie_widzew/screens/add_announcement_screen.dart';
import 'package:lokalnie_widzew/screens/announcement_detail_screen.dart';
import 'package:lokalnie_widzew/screens/my_announcements_screen.dart';
import 'package:lokalnie_widzew/screens/privacy_terms_screen.dart';
import 'package:lokalnie_widzew/screens/snap_post_screen.dart';
import 'package:lokalnie_widzew/screens/tradesperson_subscription_screen.dart';
import 'package:lokalnie_widzew/services/app_image_picker.dart';
import 'package:lokalnie_widzew/services/app_store.dart';
import 'package:lokalnie_widzew/services/form_draft_store.dart';
import 'package:lokalnie_widzew/services/network_gate.dart';
import 'package:lokalnie_widzew/services/pro_subscription_service.dart';
import 'package:lokalnie_widzew/services/widzew_location.dart';
import 'package:lokalnie_widzew/widgets/app_page_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

Finder _scrollableOf(String listKey) {
  final nested = find.descendant(
    of: find.byKey(ValueKey(listKey)),
    matching: find.byType(Scrollable),
  );
  if (nested.evaluate().isNotEmpty) return nested.first;
  return find.byType(Scrollable).first;
}

void _enlargeSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _reveal(WidgetTester tester, Finder finder, {String? listKey}) async {
  final scrollable = listKey == null
      ? find.byType(Scrollable).first
      : _scrollableOf(listKey);
  await tester.scrollUntilVisible(finder, 280, scrollable: scrollable);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

Future<void> _tapVisible(
  WidgetTester tester,
  Finder finder, {
  String? listKey,
}) async {
  await _reveal(tester, finder, listKey: listKey);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _appBarBack(WidgetTester tester) async {
  final homeBack = find.byKey(const ValueKey('home-subview-back'));
  if (homeBack.evaluate().isNotEmpty) {
    await tester.tap(homeBack);
    await tester.pumpAndSettle();
    return;
  }
  final material = find.byType(BackButton);
  expect(material, findsWidgets);
  await tester.tap(material.first);
  await tester.pumpAndSettle();
}

Future<void> _systemBack(WidgetTester tester) async {
  final handled = await tester.binding.handlePopRoute();
  expect(handled, isTrue);
  await tester.pumpAndSettle();
}

Widget _localized(Widget home) {
  return AppLocalizations(
    locale: AppLocale.pl,
    child: MaterialApp(home: home),
  );
}

Future<void> _pumpApp(WidgetTester tester, {MemoryAppStore? store}) async {
  _enlargeSurface(tester);
  await tester.pumpWidget(
    LokalnieWidzewApp(
      store: store ?? MemoryAppStore(),
      networkGate: FakeNetworkGate(current: false),
    ),
  );
  await tester.pumpAndSettle();
}

class _AuditImagePicker extends AppImagePicker {
  const _AuditImagePicker();

  @override
  Future<String?> pickFromGallery() async => 'preview.jpg';

  @override
  Future<String?> pickFromCamera() async => 'preview.jpg';
}

Announcement _ownListing() {
  return Announcement(
    title: 'Oddam deskę do prasowania',
    category: Announcement.otherCategory,
    subDistrict: 'Twoja okolica',
    time: 'Teraz',
    icon: Icons.campaign,
    publishedAt: DateTime(2026, 10, 13, 12),
    description: 'Odbiór po 17:00.',
    isMine: true,
    authorName: 'Sąsiad',
    authorUid: 'uid-1',
  );
}

Announcement _foreignListing() {
  return Announcement(
    title: 'Sprzedam rower',
    category: 'Sąsiedzi',
    subDistrict: 'Osiedle Słoneczne',
    time: 'Teraz',
    icon: Icons.pedal_bike,
    publishedAt: DateTime(2026, 10, 13, 11),
    description: 'Sprawny, odbiór na osiedlu.',
    isMine: false,
    authorName: 'Ania',
    authorUid: 'uid-2',
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FormDraftStore.clear(FormDraftStore.addAnnouncement);
    FormDraftStore.clear(FormDraftStore.snapPost);
    FormDraftStore.clear(FormDraftStore.homeFilters);
    WidzewLocation.debugOverride = null;
  });

  tearDown(() {
    WidzewLocation.debugOverride = null;
  });

  group('config audit', () {
    test('firestore.rules cover listings, reports, photos and Pro', () {
      final rules = File('firestore.rules').readAsStringSync();
      expect(rules, contains('optionalImageBase64'));
      expect(rules, contains('imageBase64'));
      expect(rules, contains('optionalStatus'));
      expect(rules, contains('content_reports'));
      expect(rules, contains('optionalProFields'));
      expect(rules, contains('isPro'));
      expect(rules, contains("match /users/{userId}"));
      expect(rules, isNot(contains('match /b/storage')));
    });

    test('Android package and label stay Lokalnie', () {
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();
      expect(manifest, contains('android:label="Lokalnie"'));
      expect(manifest, contains('com.android.vending.BILLING'));
      expect(
        manifest,
        contains('firebase_messaging_installation_id_enabled'),
      );
      final gradle = File('android/app/build.gradle.kts').readAsStringSync();
      expect(gradle, contains('applicationId = "pl.patryk.lokalnie"'));
      expect(gradle, contains('namespace = "pl.patryk.lokalnie"'));
    });

    test('home copy has no leftover Widzew district names', () {
      expect(AppSnapshot.initial().announcements, isNotEmpty);
      for (final item in AppSnapshot.initial().announcements) {
        expect(item.title.toLowerCase(), isNot(contains('widzew')));
        expect(item.description.toLowerCase(), isNot(contains('widzew')));
        expect(item.subDistrict.toLowerCase(), isNot(contains('widzew')));
        expect(item.description.toLowerCase(), isNot(contains('janowie')));
      }
    });
  });

  group('home board', () {
    testWidgets('renders categories including Inne and filters the feed', (
      tester,
    ) async {
      await _pumpApp(tester);
      expect(find.text('Lokalnie'), findsWidgets);
      expect(find.byKey(const ValueKey('category-Fachowcy')), findsOneWidget);
      await _reveal(
        tester,
        find.byKey(const ValueKey('category-Inne')),
        listKey: 'home-list',
      );
      expect(find.byKey(const ValueKey('category-Inne')), findsOneWidget);

      await _tapVisible(
        tester,
        find.byKey(const ValueKey('category-Fachowcy')),
        listKey: 'home-list',
      );
      expect(find.byKey(const ValueKey('home-subview-back')), findsOneWidget);
      expect(find.textContaining('hydraulik'), findsWidgets);
      expect(find.textContaining('pralkę'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('home-subview-back')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('home-subview-back')), findsNothing);
      await _reveal(
        tester,
        find.textContaining('pralkę'),
        listKey: 'home-list',
      );
      expect(find.textContaining('pralkę'), findsWidgets);
    });

    testWidgets('search box filters announcements by text', (tester) async {
      await _pumpApp(tester);
      await tester.enterText(
        find.byKey(const ValueKey('announcement-search')),
        'hydraulik',
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('hydraulik'), findsWidgets);
      expect(find.textContaining('pralkę'), findsNothing);
    });

    testWidgets('Aktualne / Zakończone status chip toggles the feed', (
      tester,
    ) async {
      await _pumpApp(tester);
      expect(find.textContaining('hydraulik'), findsWidgets);
      await _tapVisible(
        tester,
        find.byKey(const ValueKey('status-filter-closed-chip')),
        listKey: 'home-list',
      );
      expect(find.byKey(const ValueKey('home-subview-back')), findsOneWidget);
      expect(find.textContaining('hydraulik'), findsNothing);
      await tester.tap(find.byKey(const ValueKey('home-subview-back')));
      await tester.pumpAndSettle();
      expect(find.textContaining('hydraulik'), findsWidgets);
    });
  });

  group('back navigation', () {
    testWidgets('category, details and forms pop without leaving the app', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _tapVisible(
        tester,
        find.byKey(const ValueKey('category-Fachowcy')),
        listKey: 'home-list',
      );
      expect(find.byKey(const ValueKey('home-subview-back')), findsOneWidget);
      await _systemBack(tester);
      expect(find.byKey(const ValueKey('home-subview-back')), findsNothing);
      expect(find.text('Lokalnie'), findsWidgets);

      await _reveal(
        tester,
        find.text('Poszukiwany hydraulik - ul. Główna'),
        listKey: 'home-list',
      );
      await tester.tap(find.text('Poszukiwany hydraulik - ul. Główna'));
      await tester.pumpAndSettle();
      expect(find.text('Szczegóły ogłoszenia'), findsOneWidget);
      await _systemBack(tester);
      expect(find.text('Szczegóły ogłoszenia'), findsNothing);
      expect(find.text('Lokalnie'), findsWidgets);

      await tester.tap(find.byTooltip('Dodaj ogłoszenie'));
      await tester.pumpAndSettle();
      expect(find.text('Dodaj ogłoszenie'), findsWidgets);
      await _appBarBack(tester);
      expect(find.text('Opublikuj ogłoszenie'), findsNothing);
      expect(find.text('Lokalnie'), findsWidgets);
    });

    testWidgets('AppPageRoute forms honor the back arrow', (tester) async {
      _enlargeSurface(tester);
      await tester.pumpWidget(
        AppLocalizations(
          locale: AppLocale.pl,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                      AppPageRoute<void>(
                        builder: (_) => const AddAnnouncementScreen(),
                      ),
                    ),
                    child: const Text('Otwórz formularz'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Otwórz formularz'));
      await tester.pumpAndSettle();
      expect(find.text('Dodaj ogłoszenie'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Otwórz formularz'), findsOneWidget);
    });
  });

  group('add announcement and snap', () {
    testWidgets('add form validates title and accepts Inne plus optional photo', (
      tester,
    ) async {
      _enlargeSurface(tester);
      await tester.pumpWidget(
        _localized(
          AddAnnouncementScreen(
            imagePicker: const _AuditImagePicker(),
            initialSubDistrict: '',
          ),
        ),
      );
      await tester.tap(find.text('Opublikuj ogłoszenie'));
      await tester.pumpAndSettle();
      expect(find.text('Wpisz tytuł ogłoszenia'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).first, 'Oddam doniczkę');
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Inne').last);
      await tester.pumpAndSettle();
      await _tapVisible(tester, find.text('Dodaj zdjęcie'));
      expect(find.text('Podgląd zdjęcia'), findsOneWidget);
      expect(find.textContaining('Widzew'), findsNothing);
    });

    testWidgets('add form returns announcement with Inne and empty GPS place', (
      tester,
    ) async {
      _enlargeSurface(tester);
      Announcement? posted;
      await tester.pumpWidget(
        AppLocalizations(
          locale: AppLocale.pl,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    final result = await Navigator.of(context).push<Announcement>(
                      AppPageRoute(
                        builder: (_) => const AddAnnouncementScreen(
                          imagePicker: _AuditImagePicker(),
                          initialSubDistrict: '',
                        ),
                      ),
                    );
                    posted = result;
                  },
                  child: const Text('Start'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Tablica korkowa');
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Inne').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Opublikuj ogłoszenie'));
      await tester.pumpAndSettle();
      expect(posted, isNotNull);
      expect(posted!.title, 'Tablica korkowa');
      expect(posted!.category, Announcement.otherCategory);
      expect(posted!.subDistrict.toLowerCase(), isNot(contains('widzew')));
    });

    testWidgets('snap validates content and does not pin Widzew without GPS', (
      tester,
    ) async {
      _enlargeSurface(tester);
      WidzewLocation.debugOverride = WidzewFix.unavailable;
      Announcement? posted;
      await tester.pumpWidget(
        AppLocalizations(
          locale: AppLocale.pl,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    posted = await Navigator.of(context).push<Announcement>(
                      AppPageRoute(
                        builder: (_) => const SnapPostScreen(
                          initialSubDistrict: '',
                          authorName: 'Sąsiad',
                          imagePicker: _AuditImagePicker(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Start'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();
      expect(find.text('Szybkie zgłoszenie'), findsOneWidget);
      expect(find.text('GPS niedostępny (opcjonalnie)'), findsOneWidget);
      expect(find.textContaining('Widzew'), findsNothing);

      await tester.tap(find.text('Zgłoś usterkę teraz'));
      await tester.pumpAndSettle();
      expect(find.text('Dodaj zdjęcie albo krótki opis.'), findsOneWidget);

      await tester.enterText(
        find.byType(TextField).last,
        'Dziura w jezdni przy klatce',
      );
      await tester.tap(find.text('Zrób zdjęcie'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Zgłoś usterkę teraz'));
      await tester.pumpAndSettle();
      expect(posted, isNotNull);
      expect(posted!.subDistrict.toLowerCase(), isNot(contains('widzew')));
      expect(posted!.title.toLowerCase(), isNot(contains('widzew')));
      expect(posted!.imagePath, 'preview.jpg');
    });
  });

  group('listing management and chrome', () {
    testWidgets('owner can edit and delete from Moje ogłoszenia', (
      tester,
    ) async {
      _enlargeSurface(tester);
      var deleted = false;
      var edited = false;
      await tester.pumpWidget(
        _localized(
          MyAnnouncementsScreen(
            announcements: [_ownListing()],
            onOpen: (_) {},
            onEdit: (item) async {
              edited = true;
              return item.copyWith(title: 'Oddam deskę (zaktualizowane)');
            },
            onComplete: (_) {},
            onReopen: (_) {},
            onDelete: (_) => deleted = true,
          ),
        ),
      );
      expect(find.text('Oddam deskę do prasowania'), findsOneWidget);
      await tester.tap(find.text('Edytuj'));
      await tester.pumpAndSettle();
      expect(edited, isTrue);
      expect(find.text('Oddam deskę (zaktualizowane)'), findsOneWidget);
      await tester.tap(find.text('Usuń'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Usuń').last);
      await tester.pumpAndSettle();
      expect(deleted, isTrue);
      expect(find.text('Oddam deskę (zaktualizowane)'), findsNothing);
    });

    testWidgets('foreign listing can be reported and shared', (tester) async {
      _enlargeSurface(tester);
      String? reported;
      await tester.pumpWidget(
        _localized(
          AnnouncementDetailScreen(
            announcement: _foreignListing(),
            onToggleFavorite: (_) {},
            onAddComment: (_) {},
            onStatusChanged: (_) {},
            onReport: (reason) => reported = reason,
          ),
        ),
      );
      await tester.tap(find.byTooltip('Udostępnij ogłoszenie'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Skopiowano link do ogłoszenia'), findsOneWidget);

      await _reveal(
        tester,
        find.byKey(const ValueKey('share-listing-chip')),
      );
      expect(find.text('Udostępnij'), findsWidgets);
      await _tapVisible(
        tester,
        find.byKey(const ValueKey('report-content-button')),
      );
      expect(find.text('Zgłoś nadużycie'), findsOneWidget);
      await tester.tap(find.text('Zgłoś'));
      await tester.pumpAndSettle();
      expect(reported, 'Spam / Reklama');
    });

    testWidgets('Saved, Messages, Profile, Settings and privacy', (
      tester,
    ) async {
      await _pumpApp(tester);
      await tester.tap(find.text('Zapisane'));
      await tester.pumpAndSettle();
      expect(find.text('Nie masz jeszcze zapisanych ogłoszeń.'), findsOneWidget);

      await tester.tap(find.text('Wiadomości'));
      await tester.pumpAndSettle();
      expect(find.text('Wiadomości sąsiedzkie'), findsOneWidget);

      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();
      expect(find.text('Profil'), findsWidgets);
      await tester.tap(find.byKey(const ValueKey('profile-settings')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('dark-mode-switch')), findsOneWidget);
      await _tapVisible(
        tester,
        find.text('Polityka prywatności i regulamin'),
        listKey: 'settings-list',
      );
      expect(find.textContaining('Firebase Auth'), findsOneWidget);
      expect(find.textContaining('Base64'), findsOneWidget);
      await _appBarBack(tester);
      expect(find.byKey(const ValueKey('dark-mode-switch')), findsOneWidget);
    });
  });

  group('Pro account', () {
    testWidgets('purchase screen uses fallback price offline and toggles isPro', (
      tester,
    ) async {
      _enlargeSurface(tester);
      var buying = false;
      var account = const TradespersonAccount(isTradesperson: true);
      await tester.pumpWidget(
        MaterialApp(
          home: TradespersonSubscriptionScreen(
            account: account,
            jobRequests: const [],
            onRenew: () => buying = true,
            onRestore: () {},
            onListingPublishedChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Abonament Fachowca'), findsOneWidget);
      expect(find.text('Konto PRO'), findsOneWidget);
      expect(find.text('Status: nieaktywne'), findsOneWidget);
      expect(find.text(ProProduct.fallbackPriceLabel), findsOneWidget);
      expect(find.textContaining(ProProduct.id), findsOneWidget);
      expect(find.textContaining('Google Play'), findsWidgets);

      final offer = await ProSubscriptionService.instance.loadOffer();
      expect(offer.usesFallbackPrice, isTrue);
      expect(offer.fromStore, isFalse);
      expect(offer.priceLabel, ProProduct.fallbackPriceLabel);

      await tester.tap(find.byKey(const ValueKey('activate-pro-subscription')));
      await tester.pump();
      expect(buying, isTrue);

      account = account.copyWith(
        isPro: true,
        subscriptionExpiryDate: DateTime.now().add(const Duration(days: 20)),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: TradespersonSubscriptionScreen(
            account: account,
            jobRequests: const [],
            onRenew: () {},
            onListingPublishedChanged: (_) {},
            offer: ProOffer.fallback,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Status: aktywne'), findsOneWidget);
      expect(account.isPro, isTrue);
      expect(account.isProActive, isTrue);
    });

    testWidgets('profile can open the Pro purchase screen', (tester) async {
      await _pumpApp(tester);
      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();
      await _tapVisible(
        tester,
        find.text('Dlaczego warto zostać Fachowcem PRO'),
        listKey: 'profile-list',
      );
      expect(
        find.text('Dlaczego warto zostać Fachowcem PRO'),
        findsWidgets,
      );
      await _tapVisible(tester, find.text('Chcę pakiet PRO'));
      expect(find.text('Abonament Fachowca'), findsOneWidget);
      expect(find.text(ProProduct.fallbackPriceLabel), findsOneWidget);
      expect(find.textContaining(ProProduct.id), findsOneWidget);
    });
  });

  group('privacy screen isolated', () {
    testWidgets('policy mentions Firebase, FCM and local storage', (
      tester,
    ) async {
      _enlargeSurface(tester);
      await tester.pumpWidget(_localized(const PrivacyTermsScreen()));
      expect(find.text('Polityka prywatności i regulamin'), findsOneWidget);
      expect(find.textContaining('Firebase Auth'), findsOneWidget);
      await _reveal(
        tester,
        find.textContaining('SharedPreferences'),
        listKey: 'privacy-list',
      );
      expect(find.text('Przetwarzanie danych lokalnie'), findsOneWidget);
    });
  });
}
