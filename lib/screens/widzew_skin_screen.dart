import 'package:flutter/material.dart';

import '../models/widzew_skin.dart';

class WidzewSkinScreen extends StatelessWidget {
  final WidzewSkin selected;
  final ValueChanged<WidzewSkin> onChanged;

  const WidzewSkinScreen({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motywy i skórki')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Kolorystyka nawiązująca do miejsc Widzewa. Tryb jasny/ciemny zostaje bez zmian.',
          ),
          const SizedBox(height: 12),
          for (final skin in WidzewSkinX.palette)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: skin.seed),
                title: Text(skin.label),
                selected: selected == skin,
                trailing: selected == skin
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  onChanged(skin);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ustawiono motyw: ${skin.label}')),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
