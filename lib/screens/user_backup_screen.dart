import 'package:flutter/material.dart';

class UserBackupScreen extends StatelessWidget {
  final VoidCallback onExportBackup;

  const UserBackupScreen({super.key, required this.onExportBackup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kopie zapasowe i eksport')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Eksport własnych ogłoszeń, historii zgłoszeń i ulubionych wątków do JSON (schowek / udostępnianie pliku backup).',
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.folder_outlined),
              title: Text('Zakres kopii'),
              subtitle: Text(
                'Moje ogłoszenia, ulubione, historia wyszukiwania, zgłoszenia (smog, wysypiska, pożar).',
              ),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onExportBackup,
            icon: const Icon(Icons.save_alt_outlined),
            label: const Text('Eksport JSON / Backup'),
          ),
        ],
      ),
    );
  }
}
