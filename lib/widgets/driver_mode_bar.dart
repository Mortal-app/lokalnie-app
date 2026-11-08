import 'package:flutter/material.dart';

class DriverModeBar extends StatelessWidget {
  final VoidCallback? onRoadAlert;
  final VoidCallback? onMap;
  final VoidCallback? onEco;

  const DriverModeBar({
    super.key,
    this.onRoadAlert,
    this.onMap,
    this.onEco,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tryb Kierowcy / Szybki Widok',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
            onPressed: onRoadAlert,
            child: const Text('Alert drogowy / SOS'),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
            onPressed: onMap,
            child: const Text('Mapa osiedli'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
            onPressed: onEco,
            child: const Text('Eko-Patrol'),
          ),
        ],
      ),
    );
  }
}
