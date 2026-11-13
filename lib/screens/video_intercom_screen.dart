import 'package:flutter/material.dart';

import '../models/video_intercom.dart';
import '../theme/widzew_ui.dart';

class VideoIntercomScreen extends StatefulWidget {
  final List<VideoIntercomTip> items;
  final String userName;
  final ValueChanged<VideoIntercomTip> onAdd;

  const VideoIntercomScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<VideoIntercomScreen> createState() => _VideoIntercomScreenState();
}

class _VideoIntercomScreenState extends State<VideoIntercomScreen> {
  late List<VideoIntercomTip> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<VideoIntercomTip>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _IntercomDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wideodomofony i unifony')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.videocam_outlined),
        label: const Text('Porada'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Konfiguracja paneli wideo, słuchawek unifonów i ustawień dostępu do klatki schodowej.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: Text(item.title),
                subtitle: Text('${item.body}\n${item.authorName}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _IntercomDialog extends StatefulWidget {
  final String userName;

  const _IntercomDialog({required this.userName});

  @override
  State<_IntercomDialog> createState() => _IntercomDialogState();
}

class _IntercomDialogState extends State<_IntercomDialog> {
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Porada majstra'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Temat'),
          ),
          TextField(
            controller: _body,
            decoration: const InputDecoration(labelText: 'Opis'),
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
              VideoIntercomTip(
                id: 'vi-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Wideodomofon'
                    : _title.text.trim(),
                body: _body.text.trim(),
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
