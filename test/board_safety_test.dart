import 'package:flutter_test/flutter_test.dart';
import 'package:lokalnie_widzew/services/board_safety.dart';

void main() {
  test('limits three posts per rolling day and enforces cooldown', () {
    final now = DateTime(2026, 11, 13, 12);
    final three = [
      now.subtract(const Duration(hours: 2)),
      now.subtract(const Duration(hours: 1)),
      now.subtract(const Duration(minutes: 30)),
    ];
    expect(BoardSafety.publishGate(three, now: now).allowed, isFalse);

    final two = three.take(2).toList();
    expect(BoardSafety.publishGate(two, now: now).allowed, isTrue);

    final recent = [now.subtract(const Duration(seconds: 10))];
    final cooldown = BoardSafety.publishGate(recent, now: now);
    expect(cooldown.allowed, isFalse);
    expect(cooldown.message, contains('Poczekaj'));
  });

  test('hides an announcement after three unique neighbor reports', () {
    final reports = <String, List<ContentReport>>{};
    const key = 'post-1';
    final first = BoardSafety.recordReport(
      reports: reports,
      announcementKey: key,
      reporterId: 'Anna',
      reason: 'Spam / Reklama',
    );
    expect(first.hidden, isFalse);
    expect(first.count, 1);

    BoardSafety.recordReport(
      reports: reports,
      announcementKey: key,
      reporterId: 'Bartek',
      reason: 'Oszustwo',
    );
    final third = BoardSafety.recordReport(
      reports: reports,
      announcementKey: key,
      reporterId: 'Celina',
      reason: 'Treść obraźliwa',
    );
    expect(third.accepted, isTrue);
    expect(third.hidden, isTrue);
    expect(third.count, 3);

    final duplicate = BoardSafety.recordReport(
      reports: reports,
      announcementKey: key,
      reporterId: 'Anna',
      reason: 'Spam / Reklama',
    );
    expect(duplicate.accepted, isFalse);
    expect(duplicate.count, 3);
  });

  test('blocks profanity and spam, flags external domains', () {
    expect(ContentFilter.inspect('Sprzedam kurwa rower').blocked, isTrue);
    expect(
      ContentFilter.inspect('Kliknij tutaj po darmowe pieniądze').blocked,
      isTrue,
    );
    expect(ContentFilter.inspect('Zobacz www.przyklad.com').flagged, isTrue);
    expect(ContentFilter.inspect('Zobacz www.przyklad.com').blocked, isFalse);
    expect(ContentFilter.inspect('Oddam pralkę na Janowie').blocked, isFalse);
    expect(ContentFilter.inspect('Oddam pralkę na Janowie').flagged, isFalse);
  });
}
