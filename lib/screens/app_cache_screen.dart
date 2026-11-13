import 'package:flutter/material.dart';

class AppCacheScreen extends StatefulWidget {
  final int cacheKb;
  final String refreshedAt;
  final VoidCallback onClearCache;
  final VoidCallback onRefreshAnnouncements;

  const AppCacheScreen({
    super.key,
    required this.cacheKb,
    required this.refreshedAt,
    required this.onClearCache,
    required this.onRefreshAnnouncements,
  });

  @override
  State<AppCacheScreen> createState() => _AppCacheScreenState();
}

class _AppCacheScreenState extends State<AppCacheScreen> {
  late int _cacheKb;
  late String _refreshedAt;

  @override
  void initState() {
    super.initState();
    _cacheKb = widget.cacheKb;
    _refreshedAt = widget.refreshedAt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pamięć podręczna i cache')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Czyszczenie lokalnego cache, zwalnianie miejsca i odświeżanie pobranych ogłoszeń — bez kasowania Twoich wpisów.',
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.sd_storage_outlined),
            title: Text('Szacowany cache: $_cacheKb kB'),
            subtitle: Text(
              _refreshedAt.isEmpty
                  ? 'Ogłoszenia nie były jeszcze odświeżane w tej sesji'
                  : 'Ostatnie odświeżenie: $_refreshedAt',
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () {
              setState(() => _cacheKb = 8);
              widget.onClearCache();
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Wyczyść cache'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              final stamp =
                  '${DateTime.now().day.toString().padLeft(2, '0')}.'
                  '${DateTime.now().month.toString().padLeft(2, '0')}.'
                  '${DateTime.now().year} '
                  '${DateTime.now().hour.toString().padLeft(2, '0')}:'
                  '${DateTime.now().minute.toString().padLeft(2, '0')}';
              setState(() {
                _refreshedAt = stamp;
                _cacheKb = 48;
              });
              widget.onRefreshAnnouncements();
            },
            icon: const Icon(Icons.sync),
            label: const Text('Odśwież pobrane ogłoszenia'),
          ),
        ],
      ),
    );
  }
}
