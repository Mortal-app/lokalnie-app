import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/neighborhood_street.dart';

class DistrictAnalyticsScreen extends StatelessWidget {
  final List<Announcement> announcements;

  const DistrictAnalyticsScreen({super.key, required this.announcements});

  @override
  Widget build(BuildContext context) {
    final resolved = announcements
        .where((item) => item.status == AnnouncementStatus.resolved)
        .length;
    final current = announcements
        .where((item) => item.status == AnnouncementStatus.current)
        .length;
    final categories = <String, int>{};
    for (final item in announcements) {
      categories[item.category] = (categories[item.category] ?? 0) + 1;
    }
    final rankedCategories = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final streets = <String, int>{};
    for (final street in NeighborhoodStreet.selectable) {
      streets[street] = announcements
          .where(
            (item) => NeighborhoodStreet.matchesAnnouncement(item, [street]),
          )
          .length;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Raporty aktywności dzielnicy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Zbiorcze statystyki: sprawy rozwiązane, popularne kategorie i aktywność ulic.',
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.task_alt_outlined),
              title: const Text('Rozwiązane sprawy'),
              subtitle: Text('$resolved (bieżące na tablicy: $current)'),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Najpopularniejsze kategorie',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (rankedCategories.isEmpty)
            const Text('Brak danych kategorii.')
          else
            for (final entry in rankedCategories.take(6))
              Card(
                child: ListTile(
                  leading: const Icon(Icons.category_outlined),
                  title: Text(entry.key),
                  trailing: Text('${entry.value}'),
                ),
              ),
          const SizedBox(height: 8),
          const Text(
            'Aktywność ulic (Puszkina, Rokicińska, Przybyszewskiego)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          for (final entry in streets.entries)
            Card(
              child: ListTile(
                leading: const Icon(Icons.place_outlined),
                title: Text(entry.key),
                subtitle: Text('Wzmianki w ogłoszeniach: ${entry.value}'),
              ),
            ),
        ],
      ),
    );
  }
}
