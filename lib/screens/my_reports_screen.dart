import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/announcement.dart';
import '../theme/widzew_ui.dart';

class MyReportsScreen extends StatelessWidget {
  final List<Announcement> reports;
  final ValueChanged<Announcement> onOpen;

  const MyReportsScreen({
    super.key,
    required this.reports,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('myReports'))),
      body: reports.isEmpty
          ? Center(child: Text(context.tr('noReports')))
          : ListView.separated(
              key: const ValueKey('my-reports-list'),
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              scrollCacheExtent: WidzewUi.listCacheExtent,
              shrinkWrap: false,
              physics: WidzewUi.listPhysics,
              itemCount: reports.length,
              addAutomaticKeepAlives: false,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final announcement = reports[index];
                return ListTile(
                  leading: Icon(
                    announcement.isAlert
                        ? Icons.warning_amber_outlined
                        : Icons.report_outlined,
                  ),
                  title: Text(announcement.title),
                  subtitle: Text(
                    '${announcement.category} · ${announcement.status.label}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => onOpen(announcement),
                );
              },
            ),
    );
  }
}
