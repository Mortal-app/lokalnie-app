import 'package:flutter/material.dart';

import '../models/home_module_visibility.dart';

class HomeModuleVisibilityScreen extends StatefulWidget {
  final HomeModuleVisibility visibility;
  final ValueChanged<HomeModuleVisibility> onSave;

  const HomeModuleVisibilityScreen({
    super.key,
    required this.visibility,
    required this.onSave,
  });

  @override
  State<HomeModuleVisibilityScreen> createState() =>
      _HomeModuleVisibilityScreenState();
}

class _HomeModuleVisibilityScreenState
    extends State<HomeModuleVisibilityScreen> {
  late HomeModuleVisibility _value;

  @override
  void initState() {
    super.initState();
    _value = widget.visibility;
  }

  void _set(String key, bool enabled) {
    setState(() {
      _value = switch (key) {
        'fachowcy' => _value.copyWith(fachowcy: enabled),
        'zwierzaki' => _value.copyWith(zwierzaki: enabled),
        'oddamKupie' => _value.copyWith(oddamKupie: enabled),
        'dzikieZwierzeta' => _value.copyWith(dzikieZwierzeta: enabled),
        'jedzenie' => _value.copyWith(jedzenie: enabled),
        'sasiedzi' => _value.copyWith(sasiedzi: enabled),
        'wydarzenia' => _value.copyWith(wydarzenia: enabled),
        'wiecej' => _value.copyWith(wiecej: enabled),
        _ => _value,
      };
    });
  }

  void _save() {
    widget.onSave(_value);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Zapisano widoczność kafli na home.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widoczność modułów UI')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Włączaj i wyłączaj kafle kategorii na ekranie głównym. Domyślnie wszystkie osiem są widoczne.',
          ),
          const SizedBox(height: 8),
          for (final tile in HomeModuleVisibility.tileLabels)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(tile.$1),
              value: _value.show(tile.$1),
              onChanged: (enabled) => _set(tile.$2, enabled),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _save,
            child: const Text('Zapisz widoczność'),
          ),
        ],
      ),
    );
  }
}
