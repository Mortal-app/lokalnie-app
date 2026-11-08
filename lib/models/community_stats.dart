import 'announcement.dart';
import 'book_offer.dart';
import 'eco_report.dart';
import 'neighborhood_event.dart';
import 'time_bank_offer.dart';

class CommunityStats {
  final int rescuedItems;
  final int activeNeighborsThisWeek;
  final int resolvedReports;
  final int neighborsOnBoard;

  const CommunityStats({
    required this.rescuedItems,
    required this.activeNeighborsThisWeek,
    required this.resolvedReports,
    required this.neighborsOnBoard,
  });

  factory CommunityStats.from({
    required List<Announcement> announcements,
    required List<EcoReport> ecoReports,
    required List<BookOffer> books,
    required List<TimeBankOffer> timeOffers,
    required List<NeighborhoodEvent> events,
    DateTime? now,
  }) {
    final moment = now ?? DateTime.now();
    final weekAgo = moment.subtract(const Duration(days: 7));
    final rescued =
        announcements.where((item) => item.isFree).length +
        books.where((item) => item.terms == BookOfferTerms.free).length;
    final names = <String>{};
    for (final item in announcements) {
      if (item.publishedAt.isAfter(weekAgo)) names.add(item.authorName);
    }
    for (final item in ecoReports) {
      if (item.createdAt.isAfter(weekAgo)) names.add('eko-${item.id}');
    }
    for (final item in events) {
      if (item.startsAt.isAfter(weekAgo) || item.isGoing) {
        names.add(item.title);
      }
    }
    for (final item in timeOffers) {
      names.add(item.authorName);
    }
    final resolved =
        announcements
            .where((item) => item.status == AnnouncementStatus.resolved)
            .length +
        ecoReports
            .where(
              (item) => item.status == EcoInterventionStatus.acceptedByOffice,
            )
            .length +
        timeOffers.where((item) => item.isCompleted).length;
    final board = announcements.map((item) => item.authorName).toSet().length;
    return CommunityStats(
      rescuedItems: rescued,
      activeNeighborsThisWeek: names.length,
      resolvedReports: resolved,
      neighborsOnBoard: board,
    );
  }
}
