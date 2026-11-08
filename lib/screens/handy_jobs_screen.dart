import 'dart:async';

import 'package:flutter/material.dart';

import '../models/handy_job.dart';
import '../services/form_draft_store.dart';

class HandyJobsScreen extends StatefulWidget {
  final List<HandyJob> items;
  final String userName;
  final ValueChanged<HandyJob> onAdd;
  final ValueChanged<String> onDone;

  const HandyJobsScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
    required this.onDone,
  });

  @override
  State<HandyJobsScreen> createState() => _HandyJobsScreenState();
}

class _HandyJobsScreenState extends State<HandyJobsScreen> {
  late List<HandyJob> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  @override
  void didUpdateWidget(covariant HandyJobsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _items = List.of(widget.items);
    }
  }

  Future<void> _add() async {
    final created = await showDialog<HandyJob>(
      context: context,
      builder: (_) => _HandyDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  void _done(HandyJob item) {
    if (item.done) return;
    setState(() {
      _items = _items
          .map(
            (entry) =>
                entry.id == item.id ? entry.copyWith(done: true) : entry,
          )
          .toList();
    });
    widget.onDone(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pogotowie domowe')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.handyman_outlined),
        label: const Text('Zgłoś / oferuję'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Szybkie interwencje sąsiadów: kran, zamek, karnisz — złota rączka z klatki.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.build_circle_outlined),
                title: Text(item.title),
                subtitle: Text(
                  [
                    if (item.description.trim().isNotEmpty) item.description,
                    item.staircase,
                    item.authorName,
                  ].join('\n'),
                ),
                isThreeLine: true,
                trailing: TextButton(
                  onPressed: item.done ? null : () => _done(item),
                  child: Text(item.done ? 'Zrobione' : 'Podejmuję'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HandyDialog extends StatefulWidget {
  final String userName;

  const _HandyDialog({required this.userName});

  @override
  State<_HandyDialog> createState() => _HandyDialogState();
}

class _HandyDialogState extends State<_HandyDialog> {
  final _topic = TextEditingController();
  final _description = TextEditingController();

  @override
  void initState() {
    super.initState();
    final peek = FormDraftStore.peek(FormDraftStore.handyJob);
    if (peek.isNotEmpty) {
      _topic.text = peek['title'] ?? '';
      _description.text = peek['description'] ?? '';
    }
    _topic.addListener(_persistDraft);
    _description.addListener(_persistDraft);
    unawaited(_restoreDraft());
  }

  Future<void> _restoreDraft() async {
    final draft = await FormDraftStore.load(FormDraftStore.handyJob);
    if (!mounted || draft.isEmpty) return;
    setState(() {
      _topic.text = draft['title'] ?? _topic.text;
      _description.text = draft['description'] ?? _description.text;
    });
  }

  void _persistDraft() {
    FormDraftStore.save(FormDraftStore.handyJob, {
      'title': _topic.text,
      'description': _description.text,
    });
  }

  @override
  void dispose() {
    _topic.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    final topic = _topic.text.trim();
    if (topic.isEmpty) return;
    FormDraftStore.clear(FormDraftStore.handyJob);
    Navigator.pop(
      context,
      HandyJob(
        id: 'hj-${DateTime.now().millisecondsSinceEpoch}',
        kind: HandyJobKind.other,
        title: topic,
        description: _description.text.trim(),
        staircase: 'Klatka I',
        authorName: widget.userName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fill = scheme.surfaceContainerHighest;
    final fieldStyle = theme.textTheme.bodyLarge?.copyWith(
      color: scheme.onSurface,
    );
    final decoration = InputDecoration(
      filled: true,
      fillColor: fill,
      labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      hintStyle: TextStyle(
        color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
      ),
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: scheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
    );

    return AlertDialog(
      title: const Text('Interwencja domowa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const ValueKey('handy-job-topic'),
              controller: _topic,
              style: fieldStyle,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              decoration: decoration.copyWith(
                labelText: 'Temat / Tytuł zgłoszenia',
                hintText: 'Np. cieknący kran, wymiana zamka…',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('handy-job-description'),
              controller: _description,
              style: fieldStyle,
              minLines: 3,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: decoration.copyWith(
                labelText: 'Opis zgłoszenia',
                hintText: 'Co trzeba zrobić, kiedy i na której klatce',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: _topic.text.trim().isEmpty ? null : _submit,
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
