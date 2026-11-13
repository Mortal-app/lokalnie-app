import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../theme/widzew_ui.dart';

class ContentReviewScreen extends StatelessWidget {
  final List<Announcement> items;
  final int Function(Announcement announcement) reportCount;
  final ValueChanged<Announcement> onOpen;
  final ValueChanged<Announcement> onRestore;
  final ValueChanged<Announcement> onKeepHidden;

  const ContentReviewScreen({
    super.key,
    required this.items,
    required this.reportCount,
    required this.onOpen,
    required this.onRestore,
    required this.onKeepHidden,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Treści do weryfikacji')),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Brak ukrytych ogłoszeń oczekujących na weryfikację.',
              ),
            )
          : ListView.separated(
              key: const ValueKey('content-review-list'),
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              scrollCacheExtent: WidzewUi.listCacheExtent,
              physics: WidzewUi.listPhysics,
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = items[index];
                final count = reportCount(item);
                return ListTile(
                  leading: const Icon(Icons.gpp_maybe_outlined),
                  title: Text(item.title),
                  subtitle: Text('${item.category} · $count zgłoszeń sąsiadów'),
                  onTap: () => onOpen(item),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      IconButton(
                        tooltip: 'Przywróć na tablicę',
                        onPressed: () => onRestore(item),
                        icon: const Icon(Icons.undo),
                      ),
                      IconButton(
                        tooltip: 'Pozostaw ukryte',
                        onPressed: () => onKeepHidden(item),
                        icon: const Icon(Icons.visibility_off_outlined),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
