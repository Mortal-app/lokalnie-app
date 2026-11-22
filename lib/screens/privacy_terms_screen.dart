import 'package:flutter/material.dart';

import '../app_info.dart';
import '../widgets/route_pop_scope.dart';

class PrivacyTermsScreen extends StatelessWidget {
  const PrivacyTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        title: const Text('Polityka prywatności i regulamin'),
      ),
      body: ListView(
        key: const ValueKey('privacy-list'),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          Text('Polityka prywatności', style: titleStyle),
          const SizedBox(height: 8),
          const Text(
            'Lokalnie nie sprzedaje danych sąsiadów i nie prowadzi analityki '
            'reklamowej. Część danych zostaje na telefonie, a ogłoszenia, '
            'zdjęcia i token powiadomień mogą trafić do Firebase, aby tablica '
            'działała na wielu urządzeniach.',
          ),
          const SizedBox(height: 20),
          Text('Usługi Firebase', style: titleStyle),
          const SizedBox(height: 8),
          const Text(
            'Firebase Auth (logowanie anonimowe) nadaje identyfikator sesji. '
            'Firestore przechowuje ogłoszenia, zgłoszenia treści, token FCM '
            'oraz opcjonalną miniaturkę zdjęcia (Base64, poniżej 150 KB). '
            'FCM dostarcza powiadomienia push. Lokalizacja GPS jest opcjonalna '
            'i dopisywana tylko do zgłoszenia, które sam publikujesz.',
          ),
          const SizedBox(height: 20),
          Text('Usuwanie danych', style: titleStyle),
          const SizedBox(height: 8),
          const Text(
            'Własne ogłoszenia możesz edytować i usuwać z profilu (Moje ogłoszenia). '
            'Usunięcie aplikacji lub wyczyszczenie danych w ustawieniach kasuje '
            'kopię lokalną. W sprawach konta napisz na adres administracji.',
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
