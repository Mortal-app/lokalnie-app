import 'package:flutter/material.dart';

class DistrictEcoStatsScreen extends StatelessWidget {
  final double exchangedKg;
  final double savedCo2Kg;
  final int carpoolTrips;
  final int reusedItems;

  const DistrictEcoStatsScreen({
    super.key,
    required this.exchangedKg,
    required this.savedCo2Kg,
    required this.carpoolTrips,
    required this.reusedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statystyki ekologiczne dzielnicy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Wpływ sąsiedzkiej wymiany i wspólnych przejazdów w Twojej okolicy.',
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Łączna waga wymienionych przedmiotów'),
              subtitle: Text('$reusedItems pozycji w wymianie i darach'),
              trailing: Text(
                '${exchangedKg.toStringAsFixed(1)} kg',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.eco_outlined),
              title: const Text(
                'Zaoszczędzone kilogramy CO2 dzięki carpoolingowi',
              ),
              subtitle: Text('$carpoolTrips wspólnych kursów'),
              trailing: Text(
                '${savedCo2Kg.toStringAsFixed(1)} kg',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
