import 'package:flutter/material.dart';

import '../models/home_shortcuts.dart';

class HomeShortcutsScreen extends StatefulWidget {
  final List<String> tileOrder;
  final List<String> pinnedIds;
  final void Function(List<String> tileOrder, List<String> pinnedIds) onSave;

  const HomeShortcutsScreen({
    super.key,
    required this.tileOrder,
    required this.pinnedIds,
    required this.onSave,
  });

  @override
  State<HomeShortcutsScreen> createState() => _HomeShortcutsScreenState();
}

class _HomeShortcutsScreenState extends State<HomeShortcutsScreen> {
  late List<String> _order;
  late List<String> _pins;

  @override
  void initState() {
    super.initState();
    _order = HomeShortcuts(tileOrder: widget.tileOrder).resolvedTileOrder();
    _pins = List.of(widget.pinnedIds);
  }

  void _move(int index, int delta) {
    final next = index + delta;
    if (next < 0 || next >= _order.length) return;
    setState(() {
      final item = _order.removeAt(index);
      _order.insert(next, item);
    });
  }

  void _persist() {
    widget.onSave(_order, _pins);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skróty ekranu głównego')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Ułóż kolejność ośmiu kafelków kategorii i przypnij ulubione narzędzia szybkiego dostępu. Pusta kolejność w ustawieniach oznacza układ domyślny.',
          ),
          const SizedBox(height: 12),
          const Text(
            'Kolejność kafelków',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          for (var i = 0; i < _order.length; i++)
            ListTile(
              title: Text(_order[i]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'W górę',
                    onPressed: i == 0 ? null : () => _move(i, -1),
                    icon: const Icon(Icons.keyboard_arrow_up),
                  ),
                  IconButton(
                    tooltip: 'W dół',
                    onPressed: i == _order.length - 1
                        ? null
                        : () => _move(i, 1),
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _persist,
            child: const Text('Zapisz kolejność kafelków'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Przypięte narzędzia',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          for (final pin in HomeShortcuts.pinCatalog.take(3))
            CheckboxListTile(
              value: _pins.contains(pin.$1),
              title: Text(pin.$2),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    if (!_pins.contains(pin.$1)) _pins = [..._pins, pin.$1];
                  } else {
                    _pins = _pins.where((id) => id != pin.$1).toList();
                  }
                });
              },
            ),
          OutlinedButton(
            onPressed: _persist,
            child: const Text('Zapisz przypięte narzędzia'),
          ),
        ],
      ),
    );
  }
}
