import 'package:flutter/material.dart';

import '../models/led_swap.dart';
import '../theme/widzew_ui.dart';

class LedSwapScreen extends StatefulWidget {
  final List<LedSwapItem> items;
  final String userName;
  final ValueChanged<LedSwapItem> onAdd;

  const LedSwapScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<LedSwapScreen> createState() => _LedSwapScreenState();
}

class _LedSwapScreenState extends State<LedSwapScreen> {
  late List<LedSwapItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<LedSwapItem>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _LedDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wymiana żarówek LED')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.lightbulb_outline),
        label: const Text('Oddaję żarówki'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Pozostałe materiały elektroinstalacyjne i energooszczędne żarówki po remontach.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.lightbulb),
                title: Text(item.title),
                subtitle: Text('${item.place} · ${item.authorName}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _LedDialog extends StatefulWidget {
  final String userName;

  const _LedDialog({required this.userName});

  @override
  State<_LedDialog> createState() => _LedDialogState();
}

class _LedDialogState extends State<_LedDialog> {
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Żarówki / LED'),
      content: TextField(
        controller: _title,
        decoration: const InputDecoration(labelText: 'Co oddajesz?'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              LedSwapItem(
                id: 'led-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Żarówki LED po remoncie'
                    : _title.text.trim(),
                place: 'Okolica',
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
