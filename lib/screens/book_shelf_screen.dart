import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/book_offer.dart';
import '../theme/widzew_ui.dart';

class BookShelfScreen extends StatefulWidget {
  final List<BookOffer> books;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<BookOffer> onAdd;

  const BookShelfScreen({
    super.key,
    required this.books,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAdd,
  });

  @override
  State<BookShelfScreen> createState() => _BookShelfScreenState();
}

class _BookShelfScreenState extends State<BookShelfScreen> {
  late List<BookOffer> _books;
  BookGenre? _genre;

  @override
  void initState() {
    super.initState();
    _books = List.of(widget.books);
  }

  List<BookOffer> get _visible => _genre == null
      ? _books
      : _books.where((item) => item.genre == _genre).toList();

  Future<void> _add() async {
    final created = await showDialog<BookOffer>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _AddBookDialog(
        userName: widget.userName,
        subDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null) return;
    setState(() => _books = [created, ..._books]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Książki z okolicy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.menu_book_outlined),
        label: const Text('Wystaw książkę'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Półka sąsiedzka: literatura, kryminały, dla dzieci i podręczniki.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilterChip(
                label: const Text('Wszystkie'),
                selected: _genre == null,
                onSelected: (_) => setState(() => _genre = null),
              ),
              for (final genre in BookGenre.values.take(2))
                FilterChip(
                  label: Text(genre.label),
                  selected: _genre == genre,
                  onSelected: (_) => setState(
                    () => _genre = _genre == genre ? null : genre,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final book in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.auto_stories_outlined),
                title: Text(book.title),
                subtitle: Text(
                  '${book.author} · ${book.genre.label}\n'
                  '${book.terms.label} · ${book.ownerName}, ${book.subDistrict}'
                  '${book.note.isEmpty ? '' : '\n${book.note}'}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _AddBookDialog extends StatefulWidget {
  final String userName;
  final String subDistrict;

  const _AddBookDialog({required this.userName, required this.subDistrict});

  @override
  State<_AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<_AddBookDialog> {
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _note = TextEditingController();
  BookGenre _genre = BookGenre.literature;
  BookOfferTerms _terms = BookOfferTerms.exchange;
  String _subDistrict = Announcement.subDistricts.first;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.subDistrict;
  }

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wystaw przeczytaną książkę'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _author,
              decoration: const InputDecoration(labelText: 'Autor'),
            ),
            DropdownButtonFormField<BookGenre>(
              initialValue: _genre,
              decoration: const InputDecoration(labelText: 'Dział'),
              items: BookGenre.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _genre = value);
              },
            ),
            DropdownButtonFormField<BookOfferTerms>(
              initialValue: _terms,
              decoration: const InputDecoration(labelText: 'Warunki'),
              items: BookOfferTerms.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _terms = value);
              },
            ),
            TextField(
              controller: _note,
              decoration: const InputDecoration(labelText: 'Notatka (opcjonalnie)'),
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
            if (_title.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              BookOffer(
                id: 'book-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                author: _author.text.trim().isEmpty
                    ? 'Autor nieznany'
                    : _author.text.trim(),
                genre: _genre,
                terms: _terms,
                ownerName: widget.userName,
                subDistrict: _subDistrict,
                note: _note.text.trim(),
              ),
            );
          },
          child: const Text('Wystaw'),
        ),
      ],
    );
  }
}
