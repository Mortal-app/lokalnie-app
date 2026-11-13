import 'package:flutter/material.dart';

import '../models/widzew_film.dart';

class WidzewFilmScreen extends StatelessWidget {
  final List<WidzewFilmClip> items;

  const WidzewFilmScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widzew w starym knie')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Opisy historycznych materiałów wideo i kronik z budowy blokowisk wschodniej Łodzi. To archiwum opisowe — bez odtwarzania plików.',
          ),
          const SizedBox(height: 12),
          for (final clip in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                leading: const Icon(Icons.movie_outlined),
                title: Text(clip.title),
                subtitle: Text('${clip.era} · ${clip.source}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(clip.body),
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
