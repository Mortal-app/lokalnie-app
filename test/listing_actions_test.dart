import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalnie_widzew/models/announcement.dart';
import 'package:lokalnie_widzew/screens/announcement_detail_screen.dart';
import 'package:lokalnie_widzew/screens/home_screen.dart';
import 'package:lokalnie_widzew/utils/announcement_share.dart';
import 'package:lokalnie_widzew/widgets/announcement_card.dart';

Announcement _listing({
  bool isMine = false,
  AnnouncementStatus status = AnnouncementStatus.current,
}) {
  return Announcement(
    title: 'Oddam wiertarkę',
    category: 'Sąsiedzi',
    subDistrict: 'Osiedle Słoneczne',
    time: 'Teraz',
    icon: Icons.handyman_outlined,
    publishedAt: DateTime(2026, 10, 13, 12),
    description: 'Sprawna, odbiór po 17:00.',
    authorName: 'Ania',
    isMine: isMine,
    status: status,
  );
}

void main() {
  test('share text includes title, category, location and description', () {
    final text = AnnouncementShare.clipboardText(_listing());
    expect(text, contains('Lokalnie — ogłoszenie sąsiedzkie'));
    expect(text, contains('Tytuł: Oddam wiertarkę'));
    expect(text, contains('Kategoria: Sąsiedzi'));
    expect(text, contains('Lokalizacja: Osiedle Słoneczne'));
    expect(text, contains('Status: Aktualne'));
    expect(text, contains('Opis:'));
    expect(text, contains('Sprawna, odbiór po 17:00.'));
    expect(text, contains('https://lokalniewidzew.app/ogloszenie/'));
  });

  test('share text marks closed listings and empty location', () {
    final closed = _listing(status: AnnouncementStatus.resolved).copyWith(
      subDistrict: '   ',
      description: '',
    );
    final text = AnnouncementShare.clipboardText(closed);
    expect(text, contains('Status: Zakończone'));
    expect(text, contains('Lokalizacja: Brak lokalizacji'));
    expect(text, isNot(contains('Opis:')));
  });

  testWidgets('owner can close a listing and restore it as current', (
    tester,
  ) async {
    var status = AnnouncementStatus.current;
    await tester.pumpWidget(
      MaterialApp(
        home: AnnouncementDetailScreen(
          announcement: _listing(isMine: true),
          onToggleFavorite: (_) {},
          onAddComment: (_) {},
          onStatusChanged: (value) => status = value,
        ),
      ),
    );

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('mark-listing-closed')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byKey(const ValueKey('mark-listing-closed')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('mark-listing-closed')));
    await tester.pumpAndSettle();
    expect(status, AnnouncementStatus.resolved);
    expect(
      find.byKey(const ValueKey('restore-listing-current')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('restore-listing-current')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('restore-listing-current')));
    await tester.pumpAndSettle();
    expect(status, AnnouncementStatus.current);
    expect(find.byKey(const ValueKey('mark-listing-closed')), findsOneWidget);
  });

  testWidgets('other neighbor sees contact action, owner does not', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnnouncementDetailScreen(
          announcement: _listing(),
          onToggleFavorite: (_) {},
          onAddComment: (_) {},
          onStatusChanged: (_) {},
        ),
      ),
    );
    expect(find.byKey(const ValueKey('contact-author-button')), findsOneWidget);
    expect(find.text('Napisz do autora'), findsWidgets);

    await tester.pumpWidget(
      MaterialApp(
        home: AnnouncementDetailScreen(
          announcement: _listing(isMine: true),
          onToggleFavorite: (_) {},
          onAddComment: (_) {},
          onStatusChanged: (_) {},
        ),
      ),
    );
    expect(find.byKey(const ValueKey('contact-author-button')), findsNothing);
  });

  testWidgets('list cards show listing status and hide contact actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnnouncementCard(
            announcement: _listing(status: AnnouncementStatus.resolved),
            onTap: () {},
            onFavoriteToggle: () {},
            onLike: () {},
          ),
        ),
      ),
    );
    expect(find.text('Zakończone'), findsOneWidget);
    expect(find.text('Napisz do autora'), findsNothing);
    expect(find.text('Zadzwoń / SMS'), findsNothing);
  });

  test('home status filter enum distinguishes current and closed', () {
    expect(HomeStatusFilter.current.name, 'current');
    expect(HomeStatusFilter.closed.name, 'closed');
    expect(
      AnnouncementStatus.resolved.label,
      HomeStatusFilter.closed == HomeStatusFilter.closed
          ? 'Zakończone'
          : 'Aktualne',
    );
  });
}
