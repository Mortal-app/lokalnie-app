import '../models/announcement.dart';
import '../models/community_stats.dart';
import '../models/eco_report.dart';
import '../models/home_feed_category.dart';
import '../models/infrastructure_report.dart';
import '../models/neighbor_message.dart';

/// Liczy „Życie osiedla w liczbach” z bieżącego stanu tablicy.
class StatsService {
  const StatsService();

  CommunityStats fromAppState({
    required List<Announcement> announcements,
    List<NeighborMessage> messages = const [],
    List<EcoReport> ecoReports = const [],
    List<InfrastructureReport> infrastructureReports = const [],
    String currentUserName = '',
    DateTime? now,
  }) {
    final moment = now ?? DateTime.now();
    final weekAgo = moment.subtract(const Duration(days: 7));
    return CommunityStats(
      rescuedItems: _rescuedItems(announcements),
      activeNeighborsThisWeek: _activeNeighbors(
        announcements: announcements,
        messages: messages,
        currentUserName: currentUserName,
        weekAgo: weekAgo,
      ),
      resolvedReports: _resolvedReports(
        announcements: announcements,
        ecoReports: ecoReports,
        infrastructureReports: infrastructureReports,
      ),
      neighborsOnBoard: _neighborsOnBoard(announcements),
    );
  }

  static int _rescuedItems(List<Announcement> announcements) {
    return announcements.where((item) {
      final isOddam = HomeFeedCategory.oddam.matchesAnnouncement(item);
      final givenAway =
          item.status == AnnouncementStatus.resolved &&
          (isOddam || item.isFree);
      return isOddam || givenAway;
    }).length;
  }

  static int _activeNeighbors({
    required List<Announcement> announcements,
    required List<NeighborMessage> messages,
    required String currentUserName,
    required DateTime weekAgo,
  }) {
    final names = <String>{};
    void addName(String name) {
      final trimmed = name.trim();
      if (trimmed.isNotEmpty) names.add(trimmed);
    }

    for (final item in announcements) {
      if (item.publishedAt.isAfter(weekAgo)) addName(item.authorName);
      final resolvedAt = item.resolvedAt;
      if (resolvedAt != null && resolvedAt.isAfter(weekAgo)) {
        addName(item.authorName);
      }
    }
    for (final message in messages) {
      if (!message.sentAt.isAfter(weekAgo)) continue;
      if (message.isMine) {
        addName(currentUserName);
      } else {
        addName(message.peerName);
      }
    }
    return names.length;
  }

  static int _resolvedReports({
    required List<Announcement> announcements,
    required List<EcoReport> ecoReports,
    required List<InfrastructureReport> infrastructureReports,
  }) {
    final board = announcements.where((item) {
      if (item.status != AnnouncementStatus.resolved) return false;
      return item.isAlert ||
          item.isHelp ||
          HomeFeedCategory.alerty.matchesAnnouncement(item);
    }).length;
    final eco = ecoReports
        .where((item) => item.status == EcoInterventionStatus.acceptedByOffice)
        .length;
    final infrastructure = infrastructureReports
        .where((item) => item.status == InfrastructureStatus.repaired)
        .length;
    return board + eco + infrastructure;
  }

  static int _neighborsOnBoard(List<Announcement> announcements) {
    return announcements
        .where((item) => item.status == AnnouncementStatus.current)
        .map((item) => item.authorName.trim())
        .where((name) => name.isNotEmpty)
        .toSet()
        .length;
  }
}
