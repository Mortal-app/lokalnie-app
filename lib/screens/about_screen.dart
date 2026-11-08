import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_info.dart';
import '../widgets/app_page_route.dart';
import 'privacy_terms_screen.dart';

class AboutScreen extends StatelessWidget {
  final String version;
  final String buildNumber;

  const AboutScreen({
    super.key,
    this.version = AppInfo.version,
    this.buildNumber = AppInfo.buildNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('O aplikacji')),
      body: ListView(
        key: const ValueKey('about-list'),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          const Text(
            'O aplikacji Lokalnie Widzew',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Color(0xFFFDE0E0),
              child: Icon(Icons.location_on, color: Color(0xFFD32F2F)),
            ),
            title: Text(AppInfo.name),
            subtitle: Text(AppInfo.tagline),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Wersja aplikacji'),
              subtitle: Text('v$version+$buildNumber'),
            ),
          ),
          const SizedBox(height: 12),
          Text('O projekcie', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Lokalnie Widzew to sąsiedzka tablica ogłoszeń dla Widzewa, '
            'Olechowa, Janowa, Starego Widzewa i Księżego Młyna. Pomaga '
            'dzielić się alertami, pomocą i codziennymi sprawami osiedla.',
          ),
          const SizedBox(height: 20),
          Text(
            'Kontakt do administracji',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.mail_outline),
            title: const Text(AppInfo.adminEmail),
            subtitle: const Text('Napisz w sprawie ogłoszeń i zgłoszeń'),
            onTap: () {
              Clipboard.setData(const ClipboardData(text: AppInfo.adminEmail));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Skopiowano adres e-mail.')),
              );
            },
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.phone_outlined),
            title: Text(AppInfo.adminPhone),
            subtitle: Text('Infolinia osiedlowa'),
          ),
          const SizedBox(height: 12),
          Text(
            'Regulamin osiedlowy',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Publikuj tylko prawdziwe informacje dotyczące najbliższej okolicy.\n'
            '2. Szanuj prywatność sąsiadów — bez danych osobowych bez zgody.\n'
            '3. Alerty o zwierzętach i awariach oznaczaj jasno i aktualizuj status.\n'
            '4. Nie publikuj treści obraźliwych, reklam spamowych ani ogłoszeń spoza osiedla.\n'
            '5. Ogłoszenia rozwiązane oznaczaj jako zakończone, aby nie wprowadzać w błąd.',
          ),
          const SizedBox(height: 28),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              AppPageRoute<void>(builder: (_) => const PrivacyTermsScreen()),
            ),
            child: const Text('Polityka prywatności i regulamin'),
          ),
        ],
      ),
    );
  }
}
