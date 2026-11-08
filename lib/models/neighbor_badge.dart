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
          item.comments.where((comment) => comment.authorName == userName).length;
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
    required List<NeighborhoodEvent> events,
  }) {
    final hasFirst = createdAnnouncementCount > 0 || ownAnnouncements.isNotEmpty;
    final helpful =
        ownAnnouncements.any((item) => item.isHelp) ||
        ownAnnouncements.any((item) => item.likesCount > 0);
    final eco = ownAnnouncements.any((item) => item.isFree);
    final organizer =
        events.any((event) => event.isGoing) ||
        ownAnnouncements.any(
          (item) => item.category.toLowerCase().contains('wydarzen'),
        );
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
        description: 'Pomoc sąsiedzka albo polubione ogłoszenie.',
        icon: Icons.volunteer_activism_outlined,
        unlocked: helpful,
      ),
      NeighborBadge(
        id: 'eco_resident',
        title: 'Eko-Mieszkaniec',
        description: 'Oddaj coś za darmo albo wypożycz bez kaucji.',
        icon: Icons.eco_outlined,
        unlocked: eco,
      ),
      NeighborBadge(
        id: 'local_organizer',
        title: 'Lokalny Organizator',
        description: 'Dołącz do wydarzenia albo ogłoś spotkanie.',
        icon: Icons.event_available_outlined,
        unlocked: organizer,
      ),
    ];
  }
}

class NeighborAchievements {
  static const popularViewsThreshold = 50;
  static const wandererDistrictsNeeded = 3;

  const NeighborAchievements({
    required this.nightWatch,
    required this.fastDeal,
    required this.garageKing,
    required this.goldenHand,
    required this.watchfulEye,
    required this.popularNeighbor,
    required this.wanderer,
  });

  final bool nightWatch;
  final bool fastDeal;
  final bool garageKing;
  final bool goldenHand;
  final bool watchfulEye;
  final bool popularNeighbor;
  final bool wanderer;

  factory NeighborAchievements.evaluate({
    required List<Announcement> ownAnnouncements,
    List<String> exploredSubDistricts = const [],
    bool helpedRepairJob = false,
    bool solvedCityReport = false,
  }) {
    final explored = exploredSubDistricts
        .where(Announcement.subDistricts.contains)
        .toSet();
    return NeighborAchievements(
      nightWatch: ownAnnouncements.any(isNightWatch),
      fastDeal: ownAnnouncements.any(isFastDeal),
      garageKing: ownAnnouncements.any(isGarageKing),
      goldenHand:
          helpedRepairJob ||
          ownAnnouncements.any(
            (item) =>
                isGoldenHand(item) &&
                item.status == AnnouncementStatus.resolved,
          ),
      watchfulEye:
          solvedCityReport || ownAnnouncements.any(isWatchfulEye),
      popularNeighbor: ownAnnouncements.any(isPopular),
      wanderer: explored.length >= wandererDistrictsNeeded,
    );
  }

  static bool isNightWatch(Announcement item) {
    if (!item.isAlert && !item.category.toLowerCase().contains('awari')) {
      return false;
    }
    final hour = item.publishedAt.hour;
    return hour >= 22 || hour < 6;
  }

  static bool isFastDeal(Announcement item) {
    final resolvedAt = item.resolvedAt;
    if (item.status != AnnouncementStatus.resolved || resolvedAt == null) {
      return false;
    }
    final delta = resolvedAt.difference(item.publishedAt);
    return !delta.isNegative && delta <= const Duration(hours: 24);
  }

  static bool isGarageKing(Announcement item) {
    if (item.isFree) return true;
    final haystack =
        '${item.category} ${item.title} ${item.description}'.toLowerCase();
    return item.category == 'Oddam/Kupię' ||
        haystack.contains('garaż') ||
        haystack.contains('garaz') ||
        haystack.contains('wyprzeda') ||
        haystack.contains('pchli targ');
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
