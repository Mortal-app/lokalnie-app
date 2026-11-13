import 'package:flutter/material.dart';

import '../models/staircase_code.dart';
import '../theme/widzew_ui.dart';

class StaircaseCodesScreen extends StatefulWidget {
  final List<StaircaseCodeNote> items;
  final bool unlocked;
  final ValueChanged<bool> onUnlocked;
  final ValueChanged<StaircaseCodeNote> onAdd;

  const StaircaseCodesScreen({
    super.key,
    required this.items,
    required this.unlocked,
    required this.onUnlocked,
    required this.onAdd,
  });

  @override
  State<StaircaseCodesScreen> createState() => _StaircaseCodesScreenState();
}

class _StaircaseCodesScreenState extends State<StaircaseCodesScreen> {
  late bool _unlocked;
  late List<StaircaseCodeNote> _items;

  @override
  void initState() {
    super.initState();
    _unlocked = widget.unlocked;
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    if (!_unlocked) return;
    final block = TextEditingController();
    final hint = TextEditingController();
    final created = await showDialog<StaircaseCodeNote>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('Notatka gospodarza'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: block,
              decoration: const InputDecoration(labelText: 'Blok / klatka'),
            ),
            TextField(
              controller: hint,
              decoration: const InputDecoration(
                labelText: 'Wskazówka (bez publikowania obcych kodów)',
              ),
            ),
          ],
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
                StaircaseCodeNote(
                  id: 'sc-${DateTime.now().millisecondsSinceEpoch}',
                  block: block.text.trim().isEmpty
                      ? 'Moja klatka'
                      : block.text.trim(),
                  staircase: 'Gospodarz',
                  hint: hint.text.trim().isEmpty
                      ? 'Notatka tylko dla gospodarza tej klatki.'
                      : hint.text.trim(),
                ),
              );
            },
            child: const Text('Zapisz'),
          ),
        ],
      ),
    );
    block.dispose();
    hint.dispose();
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes klatek i domofonów')),
      floatingActionButton: WidzewUi.maybeSafeFab(
        _unlocked
          ? FloatingActionButton.extended(
              onPressed: _add,
              icon: const Icon(Icons.note_add_outlined),
              label: const Text('Notatka'),
            )
          : null,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Notes serwisowy dla gospodarzy klatek. Dostęp po autoryzacji. Aplikacja nie udostępnia kodów obcych budynków.',
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Jestem gospodarzem / administratorem klatki'),
            subtitle: const Text('Potwierdzam uprawnienie do notatek tej klatki'),
            value: _unlocked,
            onChanged: (value) {
              setState(() => _unlocked = value);
              widget.onUnlocked(value);
            },
          ),
          if (!_unlocked)
            const Card(
              child: ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Zablokowane'),
                subtitle: Text(
                  'Włącz autoryzację gospodarza, aby zobaczyć i dodać notatki.',
                ),
              ),
            )
          else
            for (final item in _items)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.key_outlined),
                  title: Text(item.block),
                  subtitle: Text('${item.staircase}\n${item.hint}'),
                  isThreeLine: true,
                ),
              ),
        ],
      ),
    );
  }
}
