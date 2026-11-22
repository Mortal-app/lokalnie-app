import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalnie_widzew/l10n/app_locale.dart';
import 'package:lokalnie_widzew/l10n/app_localizations.dart';
import 'package:lokalnie_widzew/models/announcement.dart';
import 'package:lokalnie_widzew/screens/announcement_detail_screen.dart';
import 'package:lokalnie_widzew/screens/my_announcements_screen.dart';
import 'package:lokalnie_widzew/screens/privacy_terms_screen.dart';
import 'package:lokalnie_widzew/widgets/empty_announcements.dart';

Announcement _sample({bool isMine = false}) {
  return Announcement(
    title: 'Oddam doniczkę',
    category: Announcement.otherCategory,
    subDistrict: 'Twoja okolica',
    time: 'Teraz',
    icon: Icons.campaign,
    publishedAt: DateTime(2026, 10, 13),
    description: 'Stoi pod klatką.',
    isMine: isMine,
    authorUid: isMine ? 'uid-1' : 'uid-2',
  );
}

Widget _app(Widget home) {
  return AppLocalizations(
    locale: AppLocale.pl,
    child: MaterialApp(home: home),
  );
}

void main() {
  testWidgets('empty announcements widget shows Polish copy', (tester) async {
    await tester.pumpWidget(
      _app(
        const Scaffold(
          body: EmptyAnnouncements(
            message: 'Nie masz jeszcze zapisanych ogłoszeń.',
            hint: 'Oznacz ogłoszenie sercem na tablicy.',
            fill: true,
          ),
        ),
      ),
    );
    expect(find.text('Nie masz jeszcze zapisanych ogłoszeń.'), findsOneWidget);
    expect(find.text('Oznacz ogłoszenie sercem na tablicy.'), findsOneWidget);
  });

  testWidgets('my announcements empty state is readable', (tester) async {
    await tester.pumpWidget(
      _app(
        MyAnnouncementsScreen(
          announcements: const [],
          onOpen: (_) {},
          onEdit: (_) async => null,
          onComplete: (_) {},
          onReopen: (_) {},
          onDelete: (_) {},
        ),
      ),
    );
    expect(find.text('Nie masz jeszcze aktywnych ogłoszeń.'), findsOneWidget);
  });

  testWidgets('own listing shows edit and delete actions', (tester) async {
    await tester.pumpWidget(
      _app(
        AnnouncementDetailScreen(
          announcement: _sample(isMine: true),
          onToggleFavorite: (_) {},
          onAddComment: (_) {},
          onStatusChanged: (_) {},
          onEdit: () {},
          onDelete: () {},
        ),
      ),
    );
    expect(find.byKey(const ValueKey('edit-own-announcement')), findsOneWidget);
    expect(find.byKey(const ValueKey('delete-own-announcement')), findsOneWidget);
    expect(find.text('Zgłoś treść'), findsNothing);
  });

  testWidgets('foreign listing shows Zgłoś treść', (tester) async {
    await tester.pumpWidget(
      _app(
        AnnouncementDetailScreen(
          announcement: _sample(),
          onToggleFavorite: (_) {},
          onAddComment: (_) {},
          onStatusChanged: (_) {},
          onReport: (_) {},
        ),
      ),
    );
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('report-content-button')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Zgłoś treść'), findsOneWidget);
  });

  testWidgets('privacy screen mentions Firebase and local storage', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const PrivacyTermsScreen()));
    expect(find.textContaining('Firebase Auth'), findsOneWidget);
    expect(find.textContaining('Firestore'), findsOneWidget);
    expect(find.textContaining('FCM'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('SharedPreferences'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Przetwarzanie danych lokalnie'), findsOneWidget);
  });
}
