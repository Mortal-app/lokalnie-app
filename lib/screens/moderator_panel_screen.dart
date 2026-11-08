import 'package:flutter/material.dart';

import '../models/announcement.dart';

class ModeratorPanelScreen extends StatelessWidget {
  final List<Announcement> announcements;
  final Set<String> pinnedKeys;
  final Set<String> blockedKeys;
  final String Function(Announcement) keyOf;
  final ValueChanged<Announcement> onPin;
  final ValueChanged<Announcement> onBlockSpam;
  final ValueChanged<Announcement> onRemoveExpired;

  const ModeratorPanelScreen({
    super.key,
    required this.announcements,
    required this.pinnedKeys,
    required this.blockedKeys,
    required this.keyOf,
    required this.onPin,
    required this.onBlockSpam,
    required this.onRemoveExpired,
  });

  bool _isExpired(Announcement item) {
    return DateTime(2026, 10, 28).difference(item.publishedAt).inDays >= 14;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel moderatora')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Usuwanie wygasłych ogłoszeń, blokada spamu i przypinanie ogłoszeń społecznych.',
          ),
          const SizedBox(height: 12),
          for (final item in announcements)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('${item.category} · ${item.subDistrict}'),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (pinnedKeys.contains(keyOf(item)))
                          const Chip(
                            label: Text('Przypięte'),
                            visualDensity: VisualDensity.compact,
                          ),
                        if (blockedKeys.contains(keyOf(item)))
                          const Chip(
                            label: Text('Spam / ukryte'),
                            visualDensity: VisualDensity.compact,
                          ),
                        if (_isExpired(item))
                          const Chip(
                            label: Text('Wygasłe'),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                    OverflowBar(
                      children: [
                        TextButton(
                          onPressed: () => onPin(item),
                          child: const Text('Przypnij społeczne'),
                        ),
                        TextButton(
                          onPressed: () => onBlockSpam(item),
                          child: const Text('Blokuj spam'),
                        ),
                        TextButton(
                          onPressed: _isExpired(item)
                              ? () => onRemoveExpired(item)
                              : null,
                          child: const Text('Usuń wygasłe'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
