import 'package:flutter/material.dart';

import 'announcement.dart';
import 'neighborhood_geo.dart';
import 'neighborhood_street.dart';
import 'neighbor_reminder.dart';
import 'notification_radius.dart';

class NeighborhoodNotification {
  final String title;
  final String body;
  final DateTime createdAt;
  final IconData icon;
  final Announcement? announcement;
  final bool isRead;

  const NeighborhoodNotification({
    required this.title,
    required this.body,
    required this.createdAt,
    required this.icon,
    this.announcement,
    this.isRead = false,
  });

  String get readKey => '$title|${createdAt.toIso8601String()}';

  String get _haystack => '$title $body'.toLowerCase();

  bool get isNeighborMessage =>
      _haystack.contains('wiadomość od sąsiada') ||
      _haystack.contains('wiadomosc od sasiada');

  bool get isMediaOutageAlert =>
      title.toLowerCase().contains('awaria mediów') ||
      title.toLowerCase().contains('awaria mediow');

  bool get isServiceWorks => _haystack.contains('prace serwisowe');

  bool get isRoadDisruption =>
      _haystack.contains('utrudnienia') || _haystack.contains('objazd');

  bool get isReminder => title.toLowerCase().startsWith('przypomnienie');

  bool get isSosOrWildlife {
    final item = announcement;
    if (item != null && item.isAlert) return true;
    return _haystack.contains('dzik') || _haystack.contains('alert');
  }

  NeighborhoodNotification copyWith({bool? isRead}) {
    return NeighborhoodNotification(
      title: title,
      body: body,
      createdAt: createdAt,
      icon: icon,
      announcement: announcement,
      isRead: isRead ?? this.isRead,
    );
  }
}

class LocalNotificationMock {
  static List<NeighborhoodNotification> build({
    required List<Announcement> announcements,
    required String userSubDistrict,
    required bool neighborhoodEnabled,
    NotificationRadius radius = NotificationRadius.allWidzew,
    List<String> categoryFilters = const [],
    List<NeighborReminder> reminders = const [],
    List<String> favoriteStreets = const [],
  }) {
    final items = <NeighborhoodNotification>[];

    bool inRadius(Announcement announcement) {
      return switch (radius) {
        NotificationRadius.streetOrDistrict =>
          announcement.subDistrict == userSubDistrict,
        NotificationRadius.radius2km =>
          NeighborhoodGeo.distanceKm(
                userSubDistrict,
                announcement.subDistrict,
              ) <=
              2,
        NotificationRadius.allWidzew => true,
      };
    }

    bool matchesCategoryFilter(Announcement announcement) {
      if (categoryFilters.isEmpty) return true;
      final haystack =
          '${announcement.title} ${announcement.description} ${announcement.category}'
              .toLowerCase();
      return categoryFilters.any((filter) {
        if (filter == NotificationCategoryFilter.sos) {
          return announcement.isAlert;
        }
        if (filter == NotificationCategoryFilter.garageSale) {
          return haystack.contains('garaż') ||
              haystack.contains('garaz') ||
              haystack.contains('wyprzedaż') ||
              haystack.contains('wyprzedaz') ||
              announcement.category == 'Oddam/Kupię';
        }
        return announcement.category == filter;
      });
    }

    if (neighborhoodEnabled) {
      final alerts =
          announcements.where((announcement) {
            return inRadius(announcement) &&
                NeighborhoodStreet.matchesAnnouncement(
                  announcement,
                  favoriteStreets,
                ) &&
                matchesCategoryFilter(announcement) &&
                (announcement.isAlert ||
                    announcement.title.toLowerCase().contains('awaria') ||
                    announcement.description.toLowerCase().contains('awaria'));
          }).toList()..sort(
            (first, second) => second.publishedAt.compareTo(first.publishedAt),
          );
      for (final announcement in alerts.take(10)) {
        items.add(
          NeighborhoodNotification(
            title: announcement.title,
            body: '${announcement.subDistrict} · ${announcement.time}',
            createdAt: announcement.publishedAt,
            icon: announcement.isAlert
                ? Icons.warning_amber_rounded
                : Icons.build_circle_outlined,
            announcement: announcement,
          ),
        );
      }

      final newestOnDistrict = announcements.where(
        (announcement) =>
            inRadius(announcement) &&
            NeighborhoodStreet.matchesAnnouncement(
              announcement,
              favoriteStreets,
            ) &&
            matchesCategoryFilter(announcement),
      );
      if (newestOnDistrict.isNotEmpty) {
        final newest = newestOnDistrict.first;
        items.add(
          NeighborhoodNotification(
            title: 'Nowe ogłoszenie w Twojej okolicy',
            body: '${newest.category} · ${newest.subDistrict}',
            createdAt: newest.publishedAt,
            icon: Icons.campaign_outlined,
            announcement: newest,
          ),
        );
      }

      if (categoryFilters.isEmpty) {
        items.add(
          NeighborhoodNotification(
            title: 'Prace serwisowe na osiedlu',
            body: 'Zaplanowane prace na $userSubDistrict. Sprawdź ogłoszenia.',
            createdAt: DateTime(2026, 10, 13, 8),
            icon: Icons.handyman_outlined,
          ),
        );
        items.add(
          NeighborhoodNotification(
            title: 'Uwaga: utrudnienia na ul. Parkowa',
            body:
                'Objazdy i utrudnienia w rejonie $userSubDistrict. Zachowaj ostrożność.',
            createdAt: DateTime(2026, 10, 13, 7, 45),
            icon: Icons.warning_amber_rounded,
          ),
        );
        items.add(
          NeighborhoodNotification(
            title: 'Nowa wiadomość od sąsiada',
            body: 'Sąsiad czeka na Twoją odpowiedź w wątku ogłoszenia.',
            createdAt: DateTime(2026, 10, 13, 12, 10),
            icon: Icons.chat_bubble_outline,
          ),
        );
      }
    }

    for (final reminder in reminders) {
      items.add(
        NeighborhoodNotification(
          title: 'Przypomnienie: ${reminder.title}',
          body: reminder.body,
          createdAt: reminder.remindAt,
          icon: Icons.alarm_outlined,
        ),
      );
    }

    for (final announcement in announcements.where(
      (item) => item.isMine && item.likesCount > 0,
    )) {
      items.add(
        NeighborhoodNotification(
          title: 'Twoje ogłoszenie uzyskało polubienie',
          body: announcement.title,
          createdAt: announcement.publishedAt,
          icon: Icons.favorite_outline,
          announcement: announcement,
        ),
      );
    }

    items.sort((first, second) => second.createdAt.compareTo(first.createdAt));
    return items;
  }
}
