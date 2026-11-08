import 'package:flutter/material.dart';

import '../models/app_error_log.dart';

class AppDiagnosticsScreen extends StatefulWidget {
  final bool unlocked;
  final int announcementCount;
  final int snapshotFieldCount;
  final int jsonChars;
  final String backendLabel;
  final List<AppErrorLog> errorLogs;
  final VoidCallback onUnlock;

  const AppDiagnosticsScreen({
    super.key,
    required this.unlocked,
    required this.announcementCount,
    required this.snapshotFieldCount,
    required this.jsonChars,
    required this.backendLabel,
    required this.errorLogs,
    required this.onUnlock,
  });

  @override
  State<AppDiagnosticsScreen> createState() => _AppDiagnosticsScreenState();
}

class _AppDiagnosticsScreenState extends State<AppDiagnosticsScreen> {
  late bool _unlocked;

  @override
  void initState() {
    super.initState();
    _unlocked = widget.unlocked;
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = _unlocked;
    return Scaffold(
      appBar: AppBar(title: const Text('Konsola diagnostyczna')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Ukryty panel admina: stan lokalnej bazy (SharedPreferences), liczba ogłoszeń i logi. Bez haseł i tokenów.',
          ),
          const SizedBox(height: 12),
          if (!unlocked)
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Panel zablokowany'),
                subtitle: const Text(
                  'Pięciokrotnie stuknij „Wersja aplikacji” w profilu albo odblokuj podgląd lokalny.',
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: () {
                    widget.onUnlock();
                    setState(() => _unlocked = true);
                  },
                  child: const Text('Odblokuj'),
                ),
              ),
            )
          else ...[
            Card(
              child: ListTile(
                leading: const Icon(Icons.storage_outlined),
                title: const Text('SharedPreferences'),
                subtitle: Text(
                  'Backend: ${widget.backendLabel}\nPól snapshotu: ${widget.snapshotFieldCount} · JSON: ${widget.jsonChars} znaków',
                ),
                isThreeLine: true,
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.campaign_outlined),
                title: const Text('Ogłoszenia lokalne'),
                subtitle: Text(
                  'Zapisane na urządzeniu: ${widget.announcementCount}',
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Logi błędów',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            for (final log in widget.errorLogs)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: Text(log.message),
                  subtitle: Text(log.at),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
