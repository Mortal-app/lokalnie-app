import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/announcement.dart';
import '../models/infrastructure_report.dart';
import '../models/neighborhood_geo.dart';
import '../app_info.dart';
import '../utils/flutter_runtime.dart';
import '../theme/widzew_ui.dart';

class InfrastructureScreen extends StatefulWidget {
  final List<InfrastructureReport> reports;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<InfrastructureReport> onAdd;
  final void Function(String id, InfrastructureStatus status) onStatusChanged;

  const InfrastructureScreen({
    super.key,
    required this.reports,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
    required this.onStatusChanged,
  });

  @override
  State<InfrastructureScreen> createState() => _InfrastructureScreenState();
}

class _InfrastructureScreenState extends State<InfrastructureScreen> {
  late List<InfrastructureReport> _reports;

  bool get _isWidgetTest => isFlutterWidgetTest;

  @override
  void initState() {
    super.initState();
    _reports = List.of(widget.reports);
  }

  Future<void> _add() async {
    final created = await showDialog<InfrastructureReport>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _InfraDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _reports = [created, ..._reports]);
    widget.onAdd(created);
  }

  void _setStatus(InfrastructureReport report, InfrastructureStatus status) {
    setState(() {
      _reports = _reports
          .map(
            (item) =>
                item.id == report.id ? item.copyWith(status: status) : item,
          )
          .toList();
    });
    widget.onStatusChanged(report.id, status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Naprawmy okolicę')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.report_outlined),
        label: const Text('Zgłoś usterkę'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Szybkie zgłoszenia infrastruktury: gniazda os, dziury w chodniku, spalone latarnie. Pinezka na mapie i status ZDiT / MPK.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: NeighborhoodGeo.widzewCenter,
                  initialZoom: 13,
                  interactionOptions: InteractionOptions(
                    flags: _isWidgetTest
                        ? InteractiveFlag.none
                        : InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: AppInfo.applicationId,
                    tileProvider: _isWidgetTest
                        ? _SilentTileProvider()
                        : NetworkTileProvider(),
                    tileDisplay: const TileDisplay.instantaneous(),
                  ),
                  MarkerLayer(
                    markers: [
                      for (final report in _reports)
                        Marker(
                          point: LatLng(report.latitude, report.longitude),
                          width: 40,
                          height: 40,
                          child: Tooltip(
                            message: report.title,
                            child: Icon(
                              Icons.location_on,
                              color: switch (report.status) {
                                InfrastructureStatus.repaired =>
                                  Colors.green,
                                InfrastructureStatus.inProgress =>
                                  Colors.orange,
                                InfrastructureStatus.reportedToZditMpk =>
                                  Colors.red,
                              },
                              size: 36,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final report in _reports)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('${report.kind.label} · ${report.place}'),
                    Text(report.description),
                    Text(
                      'Pinezka: ${report.latitude.toStringAsFixed(4)}, ${report.longitude.toStringAsFixed(4)}',
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final status in InfrastructureStatus.values.take(3))
                          ChoiceChip(
                            label: Text(status.label),
                            selected: report.status == status,
                            onSelected: (_) => _setStatus(report, status),
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

class _InfraDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _InfraDialog({required this.userName, required this.subDistrict});

  @override
  State<_InfraDialog> createState() => _InfraDialogState();
}

class _InfraDialogState extends State<_InfraDialog> {
  final _title = TextEditingController();
  final _place = TextEditingController();
  final _description = TextEditingController();
  var _kind = InfrastructureKind.sidewalkHole;
  late String _subDistrict;
  late LatLng _pin;

  bool get _isWidgetTest => isFlutterWidgetTest;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
    _pin = NeighborhoodGeo.forSubDistrict(widget.subDistrict);
  }

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoś usterkę'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            DropdownButtonFormField<InfrastructureKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Rodzaj'),
              items: InfrastructureKind.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: _subDistrict,
              decoration: const InputDecoration(labelText: 'Osiedle (pinezka)'),
              items: Announcement.subDistricts
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _subDistrict = value;
                  _pin = NeighborhoodGeo.forSubDistrict(value);
                });
              },
            ),
            TextField(
              controller: _place,
              decoration: const InputDecoration(labelText: 'Miejsce / ulica'),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Dotknij mapy, aby ustawić pinezkę'),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _pin,
                  initialZoom: 14,
                  onTap: (_, point) => setState(() => _pin = point),
                  interactionOptions: InteractionOptions(
                    flags: _isWidgetTest
                        ? InteractiveFlag.none
                        : InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: AppInfo.applicationId,
                    tileProvider: _isWidgetTest
                        ? _SilentTileProvider()
                        : NetworkTileProvider(),
                    tileDisplay: const TileDisplay.instantaneous(),
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _pin,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TextField(
              controller: _description,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Opis'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: () {
            if (_title.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              InfrastructureReport(
                id: 'infra-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                description: _description.text.trim(),
                kind: _kind,
                place: _place.text.trim().isEmpty
                    ? _subDistrict
                    : _place.text.trim(),
                subDistrict: _subDistrict,
                latitude: _pin.latitude,
                longitude: _pin.longitude,
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Zgłoś'),
        ),
      ],
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
