import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/local_deal.dart';

class LocalDealsScreen extends StatelessWidget {
  final List<LocalDeal> deals;

  const LocalDealsScreen({super.key, required this.deals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Okazje i rabaty')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: deals.length,
        itemBuilder: (context, index) {
          final deal = deals[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.local_offer_outlined),
              title: Text(deal.title),
              subtitle: Text(
                '${deal.business} · ${deal.subDistrict}\n'
                'Hasło: „${deal.passphrase}”\n${deal.details}',
              ),
              isThreeLine: true,
              trailing: IconButton(
                tooltip: 'Kopiuj hasło',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: deal.passphrase));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Skopiowano hasło: ${deal.passphrase}'),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
              ),
            ),
          );
        },
      ),
    );
  }
}
