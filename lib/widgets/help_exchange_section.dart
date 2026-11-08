import 'package:flutter/material.dart';

import '../theme/widzew_colors.dart';

class HelpExchangeSection extends StatelessWidget {
  final bool selected;
  final ValueChanged<bool> onSelected;
  final ValueChanged<String> onSelectNeed;
  final VoidCallback? onAddHelp;

  const HelpExchangeSection({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.onSelectNeed,
    this.onAddHelp,
  });

  static const needs = [
    'Drobna naprawa',
    'Wniesienie zakupów',
    'Wyprowadzenie psa',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sąsiedzka Pomoc i Wolontariat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FilterChip(
            key: const ValueKey('help-exchange-chip'),
            avatar: const Icon(Icons.volunteer_activism, size: 18),
            label: const Text('Potrzebuję pomocy / Zaoferuj pomoc'),
            selected: selected,
            selectedColor: WidzewColors.redSoft,
            onSelected: onSelected,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final need in needs)
                ActionChip(
                  key: ValueKey('help-need-$need'),
                  label: Text(need),
                  onPressed: () => onSelectNeed(need),
                ),
            ],
          ),
          if (onAddHelp != null)
            TextButton.icon(
              onPressed: onAddHelp,
              icon: const Icon(Icons.add),
              label: const Text('Dodaj prośbę lub ofertę pomocy'),
            ),
        ],
      ),
    );
  }
}
