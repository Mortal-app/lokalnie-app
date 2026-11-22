import 'package:flutter/material.dart';

class AchievementShareScreen extends StatelessWidget {
  final String userName;
  final int swapCount;
  final int helpPoints;
  final int createdCount;
  final ValueChanged<String> onShare;

  const AchievementShareScreen({
    super.key,
    required this.userName,
    required this.swapCount,
    required this.helpPoints,
    required this.createdCount,
    required this.onShare,
  });

  String get cardText =>
      'Lokalnie — karta osiągnięć\n'
      '$userName\n'
      'Wymiany: $swapCount\n'
      'Pomoc sąsiedzka: $helpPoints pkt\n'
      'Ogłoszenia: $createdCount';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Karta osiągnięć')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Podsumowanie do social mediów: wymiany i pomoc sąsiedzka. Osobny eksport — nie zastępuje listy ogłoszeń.',
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFFD32F2F),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.white, height: 1.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lokalnie',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(userName, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    Text('Wymiany: $swapCount'),
                    Text('Pomoc sąsiedzka: $helpPoints pkt'),
                    Text('Ogłoszenia: $createdCount'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => onShare(cardText),
            icon: const Icon(Icons.share_outlined),
            label: const Text('Udostępnij kartę'),
          ),
        ],
      ),
    );
  }
}
