import 'package:flutter/material.dart';

import '../models/home_stats_config.dart';

class HomeStatsConfigScreen extends StatefulWidget {
  final HomeStatsConfig config;
  final ValueChanged<HomeStatsConfig> onSave;

  const HomeStatsConfigScreen({
    super.key,
    required this.config,
    required this.onSave,
  });

  @override
  State<HomeStatsConfigScreen> createState() => _HomeStatsConfigScreenState();
}

class _HomeStatsConfigScreenState extends State<HomeStatsConfigScreen> {
  late bool _enabled;
  late String _category;

  @override
  void initState() {
    super.initState();
    _enabled = widget.config.bannerEnabled;
    _category = widget.config.favoriteCategory;
  }

  void _save() {
    widget.onSave(
      HomeStatsConfig(bannerEnabled: _enabled, favoriteCategory: _category),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Zapisano widget statystyk na ekranie głównym.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget statystyk na home')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Baner na górze ekranu głównego: statystyki osiedla, zgłoszenia wokół bloku i skrót do ulubionej kategorii.',
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Pokaż baner na home'),
            value: _enabled,
            onChanged: (value) => setState(() => _enabled = value),
          ),
          const SizedBox(height: 8),
          const Text('Ulubiona kategoria (skrót)'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final category in HomeStatsConfig.categories.take(3))
                ChoiceChip(
                  label: Text(category),
                  selected: _category == category,
                  onSelected: (_) => setState(() => _category = category),
                ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            child: const Text('Zapisz widget'),
          ),
        ],
      ),
    );
  }
}
