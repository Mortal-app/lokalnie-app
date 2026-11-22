import 'package:flutter/material.dart';

import 'announcement.dart';
import 'neighborhood_event.dart';

class NeighborBadge {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;

  const NeighborBadge({
    this.id = '',
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });
}

class NeighborReputation {
  static int points({
    required int createdAnnouncementCount,
    required List<Announcement> ownAnnouncements,
    required List<Announcement> communityAnnouncements,
    required String userName,
    required List<NeighborhoodEvent> events,
  }) {
    final likes = ownAnnouncements.fold<int>(
      0,
      (sum, item) => sum + item.likesCount,
    );
    final comments = communityAnnouncements.fold<int>(0, (sum, item) {
      return sum +
          item.comments
              .where((comment) => comment.authorName == userName)
              .length;
    });
    final helpCount = ownAnnouncements.where((item) => item.isHelp).length;
    final ecoCount = ownAnnouncements.where((item) => item.isFree).length;
    final going = events.where((event) => event.isGoing).length;
    return createdAnnouncementCount * 15 +
        likes * 3 +
        comments * 2 +
        helpCount * 20 +
        ecoCount * 10 +
        going * 12;
  }

  static List<NeighborBadge> badges({
    required int createdAnnouncementCount,
    required List<Announcement> ownAnnouncements,
  }) {
    final hasFirst =
        createdAnnouncementCount > 0 || ownAnnouncements.isNotEmpty;
    final helpful =
        ownAnnouncements.any((item) => item.isHelp) ||
        ownAnnouncements.any((item) => item.likesCount > 0);
    return [
      NeighborBadge(
        id: 'first_listing',
        title: 'Pierwsze Ogłoszenie',
        description: 'Opublikuj pierwsze ogłoszenie na tablicy.',
        icon: Icons.campaign_outlined,
        unlocked: hasFirst,
      ),
      NeighborBadge(
        id: 'helpful_hand',
        title: 'Pomocny Sąsiad',
        description: 'Opublikuj pomoc sąsiedzką lub odpowiedz na ogłoszenie z prośbą o wsparcie w okolicy.',
        icon: Icons.volunteer_activism_outlined,
        unlocked: helpful,
      ),
    ];
  }
}

class NeighborAchievements {
  static const popularViewsThreshold = 50;

  const NeighborAchievements({
    required this.fastDeal,
    required this.goldenHand,
    required this.watchfulEye,
    required this.popularNeighbor,
  });

  final bool fastDeal;
  final bool goldenHand;
  final bool watchfulEye;
  final bool popularNeighbor;

  factory NeighborAchievements.evaluate({
    required List<Announcement> ownAnnouncements,
    bool helpedRepairJob = false,
    bool solvedCityReport = false,
  }) {
    return NeighborAchievements(
      fastDeal: ownAnnouncements.any(isFastDeal),
      goldenHand:
          helpedRepairJob ||
          ownAnnouncements.any(
            (item) =>
                isGoldenHand(item) &&
                item.status == AnnouncementStatus.resolved,
          ),
      watchfulEye: solvedCityReport || ownAnnouncements.any(isWatchfulEye),
      popularNeighbor: ownAnnouncements.any(isPopular),
    );
  }

  static bool isFastDeal(Announcement item) {
    final resolvedAt = item.resolvedAt;
    if (item.status != AnnouncementStatus.resolved || resolvedAt == null) {
      return false;
    }
    final delta = resolvedAt.difference(item.publishedAt);
    return !delta.isNegative && delta <= const Duration(hours: 24);
  }

  static bool isGoldenHand(Announcement item) {
    final category = item.category.toLowerCase();
    return category.contains('fachow') ||
        category.contains('złota rącz') ||
        category.contains('zlota racz') ||
        category.contains('remont') ||
        category.contains('jednorazowe') ||
        category.contains('napraw');
  }

  static bool isWatchfulEye(Announcement item) {
    return (item.isAlert ||
            item.category.toLowerCase().contains('awari') ||
            item.category.toLowerCase().contains('zgłos')) &&
        item.status == AnnouncementStatus.resolved;
  }

  static bool isPopular(Announcement item) =>
      item.viewsCount > popularViewsThreshold;
}
