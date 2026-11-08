import 'package:flutter/material.dart';

import '../models/cooperative_notice.dart';

class CooperativeBoardScreen extends StatelessWidget {
  final List<CooperativeNotice> notices;
  final String userSubDistrict;

  const CooperativeBoardScreen({
    super.key,
    required this.notices,
    required this.userSubDistrict,
  });

  String _format(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day.$month.${value.year} $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final nearby = notices.where((notice) {
      return notice.area.contains(userSubDistrict) ||
          notice.area.toLowerCase().contains('widzew');
    }).toList();
    final items = nearby.isEmpty ? notices : nearby;
    return Scaffold(
      appBar: AppBar(title: const Text('Tablica zarządu / spółdzielni')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final notice = items[index];
          final onMyStreet = notice.area.contains(userSubDistrict);
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            color: onMyStreet ? const Color(0xFFFFF3E0) : null,
            child: ListTile(
              leading: Icon(switch (notice.kind) {
                CooperativeNoticeKind.water => Icons.water_drop_outlined,
                CooperativeNoticeKind.heating => Icons.thermostat,
                CooperativeNoticeKind.power => Icons.bolt_outlined,
                CooperativeNoticeKind.general => Icons.campaign_outlined,
              }),
              title: Text(notice.title),
              subtitle: Text(
                '${notice.kind.label} · ${notice.area}\n'
                '${_format(notice.startsAt)}'
                '${notice.endsAt == null ? '' : ' – ${_format(notice.endsAt!)}'}\n'
                '${notice.body}',
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
