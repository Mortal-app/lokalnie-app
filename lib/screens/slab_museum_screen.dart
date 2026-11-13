import 'package:flutter/material.dart';

import '../models/slab_museum.dart';

class SlabMuseumScreen extends StatefulWidget {
  final List<SlabMemory> items;
  final void Function(String id, String memory) onMemory;

  const SlabMuseumScreen({
    super.key,
    required this.items,
    required this.onMemory,
  });

  @override
  State<SlabMuseumScreen> createState() => _SlabMuseumScreenState();
}

class _SlabMuseumScreenState extends State<SlabMuseumScreen> {
  late List<SlabMemory> _items;
  String? _openId;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _addMemory(SlabMemory item) async {
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('Wspomnienie'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Jak było na budowie?'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Dodaj'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (text == null || text.isEmpty) return;
    setState(() {
      _items = _items
          .map(
            (entry) => entry.id == item.id
                ? entry.copyWith(memories: [...entry.memories, text])
                : entry,
          )
          .toList();
    });
    widget.onMemory(item.id, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Muzeum wielkiej płyty')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Galeria etapów Widzewa Wschodu i Olechowa. Seniorzy — dodajcie wspomnienie.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 88,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: item.id.contains('olech')
                            ? const Color(0xFF90CAF9)
                            : const Color(0xFFBCAAA4),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.photo_library_outlined, size: 36),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(item.title),
                    subtitle: Text(
                      _openId == item.id
                          ? '${item.era}\n${item.body}\n${item.memories.isEmpty ? '' : item.memories.join('\n')}'
                          : item.era,
                    ),
                    isThreeLine: _openId == item.id,
                    onTap: () => setState(
                      () => _openId = _openId == item.id ? null : item.id,
                    ),
                    trailing: TextButton(
                      onPressed: () => _addMemory(item),
                      child: const Text('Wspomnienie'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
