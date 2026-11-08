import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../models/announcement.dart';
import '../models/city_issue.dart';
import '../models/neighborhood_geo.dart';
import '../theme/widzew_colors.dart';
import '../utils/flutter_runtime.dart';

class NeighborhoodMap extends StatelessWidget {
  final List<Announcement> announcements;
  final ValueChanged<Announcement> onOpenAnnouncement;
  final ValueChanged<Announcement>? onSupportIssue;
  final bool issuesOnly;

  const NeighborhoodMap({
    super.key,
    required this.announcements,
    required this.onOpenAnnouncement,
    this.onSupportIssue,
    this.issuesOnly = false,
  });

  bool get _isWidgetTest => isFlutterWidgetTest;

  @override
  Widget build(BuildContext context) {
    final active = announcements
        .where((item) => item.status == AnnouncementStatus.current)
        .where((item) => !issuesOnly || item.isCityIssue)
        .toList();

    return SizedBox(
      height: 380,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: NeighborhoodGeo.widzewCenter,
            initialZoom: 13.1,
            minZoom: 11,
            maxZoom: 18,
            interactionOptions: InteractionOptions(
              flags: _isWidgetTest ? InteractiveFlag.none : InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.lokalniewidzew.app',
              tileProvider: _isWidgetTest
                  ? _SilentTileProvider()
                  : NetworkTileProvider(),
              tileDisplay: const TileDisplay.instantaneous(),
            ),
            MarkerLayer(
              markers: [
                for (var index = 0; index < active.length; index++)
                  _markerFor(context, active[index], index),
              ],
            ),
            if (!_isWidgetTest)
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Marker _markerFor(
    BuildContext context,
    Announcement announcement,
    int index,
  ) {
    return Marker(
      point: NeighborhoodGeo.pointFor(announcement, index),
      width: 44,
      height: 44,
      alignment: Alignment.topCenter,
      child: Tooltip(
        message: announcement.title,
        child: GestureDetector(
          key: ValueKey(
            'map-marker-${announcement.publishedAt.toIso8601String()}',
          ),
          onTap: () => _showPreview(context, announcement),
          child: Icon(
            announcement.isAlert
                ? Icons.warning_amber_rounded
                : announcement.issuePinIcon,
            color: announcement.isAlert
                ? WidzewColors.red
                : announcement.issuePinColor,
            size: 36,
          ),
        ),
      ),
    );
  }

  Future<void> _showPreview(
    BuildContext context,
    Announcement announcement,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                announcement.title,
                style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${announcement.category} · ${announcement.subDistrict}',
                style: Theme.of(sheetContext).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                announcement.authorName,
                style: Theme.of(sheetContext).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              if (announcement.isCityIssue) ...[
                Text(
                  'Poparcia: ${announcement.supportCount}',
                  style: Theme.of(sheetContext).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: announcement.isSupported
                        ? null
                        : () {
                            Navigator.of(sheetContext).pop();
                            onSupportIssue?.call(announcement);
                          },
                    icon: const Icon(Icons.thumb_up_alt_outlined),
                    label: const Text('To też mnie dotyczy (+1)'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    onOpenAnnouncement(announcement);
                  },
                  child: const Text('Zobacz szczegóły'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SilentTileProvider extends TileProvider {
  @override
  ImageProvider<Object> getImage(
    TileCoordinates coordinates,
    TileLayer options,
  ) {
    return MemoryImage(_transparentPng);
  }
}

final Uint8List _transparentPng = Uint8List.fromList(const [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);
