import 'package:flutter/material.dart';

import '../app_info.dart';

class PrivacyTermsScreen extends StatelessWidget {
  const PrivacyTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(title: const Text('Polityka prywatności i regulamin')),
      body: ListView(
        key: const ValueKey('privacy-list'),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Text('Polityka prywatności', style: titleStyle),
          const SizedBox(height: 8),
          const Text(
            'Lokalnie Widzew przetwarza dane wyłącznie na Twoim urządzeniu. '
            'Aplikacja nie wysyła profilu, ogłoszeń ani ulubionych na serwer '
            'chmury w tej wersji. Nie zbieramy analityki reklamowej ani '
            'nie sprzedajemy danych sąsiadów.',
          ),
          const SizedBox(height: 20),
          Text('Przetwarzanie danych lokalnie', style: titleStyle),
          const SizedBox(height: 8),
          const Text(
            'Stan aplikacji (ogłoszenia, nazwa profilu, osiedle, motyw, '
            'ulubione i ustawienia powiadomień) jest zapisywany w '
            'SharedPreferences na telefonie. Zdjęcia ogłoszeń pozostają jako '
            'lokalne ścieżki plików. Usunięcie aplikacji lub wyczyszczenie '
            'danych lokalnych kasuje te informacje z urządzenia.',
          ),
          const SizedBox(height: 20),
          Text('Regulamin osiedlowy', style: titleStyle),
          const SizedBox(height: 8),
          const Text(
            '1. Publikuj tylko prawdziwe informacje dotyczące najbliższej okolicy.\n'
            '2. Szanuj prywatność sąsiadów — bez danych osobowych bez zgody.\n'
            '3. Alerty o zwierzętach i awariach oznaczaj jasno i aktualizuj status.\n'
            '4. Nie publikuj treści obraźliwych, reklam spamowych ani ogłoszeń spoza osiedla.\n'
            '5. Ogłoszenia rozwiązane oznaczaj jako zakończone, aby nie wprowadzać w błąd.\n'
            '6. Zgłoszenia nadużyć służą do ukrycia treści w Twojej sesji i informacji dla administracji.',
          ),
          const SizedBox(height: 24),
          Text(
            '${AppInfo.name} ${AppInfo.fullVersion}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
