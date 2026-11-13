import 'package:flutter/material.dart';

import '../models/block_push.dart';

class BlockPushScreen extends StatefulWidget {
  final List<BlockPushNotice> notices;
  final String homeBlockNumber;
  final String homeStaircase;
  final List<BlockPushKind> selectedKinds;
  final void Function({
    required String block,
    required String staircase,
    required List<BlockPushKind> kinds,
  })
  onSaveFilter;

  const BlockPushScreen({
    super.key,
    required this.notices,
    required this.homeBlockNumber,
    required this.homeStaircase,
    required this.selectedKinds,
    required this.onSaveFilter,
  });

  @override
  State<BlockPushScreen> createState() => _BlockPushScreenState();
}

class _BlockPushScreenState extends State<BlockPushScreen> {
  late final TextEditingController _block;
  late final TextEditingController _staircase;
  late List<BlockPushKind> _kinds;

  @override
  void initState() {
    super.initState();
    _block = TextEditingController(text: widget.homeBlockNumber);
    _staircase = TextEditingController(text: widget.homeStaircase);
    _kinds = List.of(widget.selectedKinds);
  }

  @override
  void dispose() {
    _block.dispose();
    _staircase.dispose();
    super.dispose();
  }

  List<BlockPushNotice> get _visible {
    return widget.notices
        .where(
          (item) => item.matches(
            userBlock: _block.text.trim(),
            userStaircase: _staircase.text.trim(),
            kinds: _kinds,
          ),
        )
        .toList();
  }

  void _save() {
    widget.onSaveFilter(
      block: _block.text.trim(),
      staircase: _staircase.text.trim(),
      kinds: List.of(_kinds),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Zapisano filtr powiadomień bloku i klatki.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Powiadomienia blokowe')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Filtr push dokładnie na numer bloku i klatkę. Puste pola = wszystkie powiadomienia.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _block,
            decoration: const InputDecoration(
              labelText: 'Numer bloku',
              hintText: 'np. 140',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _staircase,
            decoration: const InputDecoration(
              labelText: 'Klatka schodowa',
              hintText: 'np. Klatka II',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final kind in BlockPushKind.values.take(3))
                FilterChip(
                  label: Text(kind.label),
                  selected: _kinds.contains(kind),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _kinds = [..._kinds, kind];
                    } else {
                      _kinds = _kinds.where((item) => item != kind).toList();
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _save,
            child: const Text('Zapisz filtr klatki'),
          ),
          const SizedBox(height: 16),
          Text(
            'Pasujące powiadomienia: ${_visible.length}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          for (final item in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: Text(item.title),
                subtitle: Text(
                  'Blok ${item.blockNumber} · ${item.staircase} · ${item.kind.label}\n${item.body}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
