import 'package:flutter/material.dart';

import '../theme/widzew_ui.dart';

class TradespersonProBenefitsScreen extends StatelessWidget {
  final VoidCallback onBecomePro;

  const TradespersonProBenefitsScreen({super.key, required this.onBecomePro});

  static const _benefits = [
    (
      Icons.campaign_outlined,
      'Oferta w katalogu usług',
      'Tylko fachowcy PRO publikują wizytówkę widoczną dla mieszkańców Widzewa, Olechowa i Janowa.',
    ),
    (
      Icons.phone_in_talk_outlined,
      'Bezpośredni kontakt na profilu',
      'Numer telefonu widać wyłącznie przy opłaconym pakiecie — chronisz bazę, a klienci i tak Cię znajdą.',
    ),
    (
      Icons.notifications_active_outlined,
      'Alerty o zleceniach z okolicy',
      'Dostajesz lokalne powiadomienie, gdy na giełdzie pojawi się nowe zapytanie, także oznaczone jako Pilne.',
    ),
    (
      Icons.handshake_outlined,
      'Przyjmowanie zleceń z giełdy',
      'Odpowiadasz na „Szukam fachowca” i kontaktujesz się z klientem bez wycieku numeru poza aplikację.',
    ),
    (
      Icons.workspace_premium_outlined,
      'Zaufanie i wyróżnienia',
      'Odznaka Zweryfikowany Fachowiec, Gwarancja Jakości i portfolio Przed/Po budują prestiż na osiedlu.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dlaczego warto zostać Fachowcem PRO')),
      body: SingleChildScrollView(
        padding: WidzewUi.insetsWide.copyWith(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pakiet abonamentowy dla wykonawców z Widzewa',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Konto klienta jest darmowe. Konto Fachowca (Złota Rączka) z aktywnym PRO otwiera katalog, giełdę zleceń i zaufanie sąsiadów — bez prowizji od każdej naprawy, tylko prosty abonament.',
            ),
            const SizedBox(height: 16),
            for (final item in _benefits)
              Card(
                child: ListTile(
                  leading: Icon(item.$1),
                  title: Text(item.$2),
                  subtitle: Text(item.$3),
                  isThreeLine: true,
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'Symulacja płatności Blik lub kartą przedłuża pakiet o 30 dni. Status i datę ważności zawsze sprawdzisz w Profilu.',
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onBecomePro,
              icon: const Icon(Icons.workspace_premium_outlined),
              label: const Text('Chcę pakiet PRO'),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
