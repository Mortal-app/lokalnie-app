import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../theme/widzew_ui.dart';
import '../utils/neighbor_qr.dart';

class QrScanScreen extends StatefulWidget {
  final List<Announcement> announcements;
  final ValueChanged<Announcement> onOpenAnnouncement;
  final void Function(String name, String subDistrict)? onOpenProfile;

  const QrScanScreen({
    super.key,
    required this.announcements,
    required this.onOpenAnnouncement,
    this.onOpenProfile,
  });

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final _controller = TextEditingController();
  String? _status;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resolve(String raw) {
    final payload = raw.trim();
    if (payload.isEmpty) {
      setState(() => _status = 'Wpisz lub wybierz kod z klatki.');
      return;
    }
    if (payload.contains('sasiad?')) {
      final uri = Uri.tryParse(payload);
      final name = uri?.queryParameters['name'] ?? 'Sąsiad';
      final osiedle = uri?.queryParameters['osiedle'] ?? '';
      widget.onOpenProfile?.call(name, osiedle);
      setState(() => _status = 'Wizytówka: $name · $osiedle');
      return;
    }
    if (payload.contains('ogloszenie/')) {
      final stamp = payload.split('ogloszenie/').last;
      final match = widget.announcements.where(
        (item) => item.publishedAt.toIso8601String() == stamp,
      );
      if (match.isNotEmpty) {
        widget.onOpenAnnouncement(match.first);
        return;
      }
    }
    final byTitle = widget.announcements.where(
      (item) => payload.toLowerCase().contains(item.title.toLowerCase()),
    );
    if (byTitle.isNotEmpty) {
      widget.onOpenAnnouncement(byTitle.first);
      return;
    }
    setState(() => _status = 'Nie znaleziono ogłoszenia dla tego kodu.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skanuj kod QR')),
      body: CustomScrollView(
        scrollCacheExtent: WidzewUi.listCacheExtent,
        shrinkWrap: false,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Zeskanuj kod z ogłoszenia na klatce albo wklej treść kodu, aby otworzyć je w aplikacji.',
                  ),
                  const SizedBox(height: 16),
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 72,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Treść kodu QR',
                      hintText: 'lokalniewidzew://ogloszenie/…',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _resolve(_controller.text),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Otwórz z kodu'),
                  ),
                  if (_status != null) ...[
                    const SizedBox(height: 8),
                    Text(_status!),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    'Ogłoszenia z kodem na klatce',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            sliver: SliverFixedExtentList(
              itemExtent: 72,
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final announcement = widget.announcements[index];
                  return ListTile(
                    leading: const Icon(Icons.qr_code_2),
                    title: Text(
                      announcement.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      announcement.subDistrict,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      _controller.text = NeighborQr.announcementPayload(
                        announcement.publishedAt,
                      );
                      widget.onOpenAnnouncement(announcement);
                    },
                  );
                },
                childCount: widget.announcements.length,
                addAutomaticKeepAlives: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
