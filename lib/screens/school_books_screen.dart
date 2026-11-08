import 'package:flutter/material.dart';

import '../models/school_book.dart';

class SchoolBooksScreen extends StatefulWidget {
  final List<SchoolBookListing> items;
  final String userName;
  final ValueChanged<SchoolBookListing> onAdd;

  const SchoolBooksScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<SchoolBooksScreen> createState() => _SchoolBooksScreenState();
}

class _SchoolBooksScreenState extends State<SchoolBooksScreen> {
  late List<SchoolBookListing> _items;
  String? _school;

  static const _schools = ['SP 114', 'SP 34', 'SP 141'];

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  List<SchoolBookListing> get _visible => _school == null
      ? _items
      : _items.where((item) => item.school == _school).toList();

  Future<void> _add() async {
    final created = await showDialog<SchoolBookListing>(
      context: context,
      builder: (_) => _BookDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kiermasz podręczników')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.menu_book_outlined),
        label: const Text('Dodaj książkę'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          const Text(
            'Wymiana i odkup używanych książek szkolnych — według szkoły i klasy.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('Wszystkie szkoły'),
                selected: _school == null,
                onSelected: (_) => setState(() => _school = null),
              ),
              for (final school in _schools.take(2))
                FilterChip(
                  label: Text(school),
                  selected: _school == school,
                  onSelected: (_) => setState(() => _school = school),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.auto_stories_outlined),
                title: Text(item.title),
                subtitle: Text(
                  '${item.school} · ${item.grade} · ${item.terms}\n${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _BookDialog extends StatefulWidget {
  final String userName;

  const _BookDialog({required this.userName});

  @override
  State<_BookDialog> createState() => _BookDialogState();
}

class _BookDialogState extends State<_BookDialog> {
  final _title = TextEditingController();
  var _school = 'SP 114';
  var _grade = 'klasa 4';

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Podręcznik'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _school,
              items: const [
                DropdownMenuItem(value: 'SP 114', child: Text('SP 114')),
                DropdownMenuItem(value: 'SP 34', child: Text('SP 34')),
                DropdownMenuItem(value: 'SP 141', child: Text('SP 141')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _school = value);
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: _grade,
              items: [
                for (final grade in [
                  'klasa 4',
                  'klasa 5',
                  'klasa 6',
                  'klasa 7',
                  'klasa 8',
                ])
                  DropdownMenuItem(value: grade, child: Text(grade)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _grade = value);
              },
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
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
          onPressed: () {
            Navigator.pop(
              context,
              SchoolBookListing(
                id: 'sb-${DateTime.now().millisecondsSinceEpoch}',
                title: _title.text.trim().isEmpty
                    ? 'Podręcznik'
                    : _title.text.trim(),
                school: _school,
                grade: _grade,
                terms: 'Wymiana',
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
