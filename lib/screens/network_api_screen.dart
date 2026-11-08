import 'package:flutter/material.dart';

class NetworkApiScreen extends StatefulWidget {
  final bool isOnline;
  final bool lastPingOk;
  final String lastSyncAt;
  final bool Function() onPing;
  final String Function() onForceSync;

  const NetworkApiScreen({
    super.key,
    required this.isOnline,
    required this.lastPingOk,
    required this.lastSyncAt,
    required this.onPing,
    required this.onForceSync,
  });

  @override
  State<NetworkApiScreen> createState() => _NetworkApiScreenState();
}

class _NetworkApiScreenState extends State<NetworkApiScreen> {
  late bool _lastPingOk;
  late String _lastSyncAt;

  @override
  void initState() {
    super.initState();
    _lastPingOk = widget.lastPingOk;
    _lastSyncAt = widget.lastSyncAt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sieć i łączność API')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Test połączenia z serwerem, status synchronizacji i ręczne odświeżenie treści — bez kasowania Twoich ogłoszeń.',
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(widget.isOnline ? Icons.wifi : Icons.wifi_off),
            title: Text(widget.isOnline ? 'Sieć: online' : 'Sieć: offline'),
            subtitle: Text(
              _lastPingOk
                  ? 'Ostatni ping API: OK'
                  : 'Ostatni ping API: brak odpowiedzi',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Synchronizacja danych'),
            subtitle: Text(
              _lastSyncAt.isEmpty
                  ? 'Brak wymuszonej synchronizacji w tej sesji'
                  : 'Ostatnia synchronizacja: $_lastSyncAt',
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () {
              final ok = widget.onPing();
              setState(() => _lastPingOk = ok);
            },
            icon: const Icon(Icons.network_check),
            label: const Text('Testuj połączenie z serwerem'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              final stamp = widget.onForceSync();
              setState(() => _lastSyncAt = stamp);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Wymuś odświeżenie treści'),
          ),
        ],
      ),
    );
  }
}
