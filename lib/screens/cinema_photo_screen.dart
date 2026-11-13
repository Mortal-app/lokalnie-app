import 'package:flutter/material.dart';

import '../models/cinema_photo.dart';

class CinemaPhotoScreen extends StatelessWidget {
  final List<CinemaPhotoClip> items;

  const CinemaPhotoScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dawne kino na Widzewie')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Archiwum opisów zdjęć dawnych kin osiedlowych i miejsc spotkań kulturalnych wschodniej Łodzi — bez plików graficznych.',
          ),
          const SizedBox(height: 12),
          for (final clip in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                leading: const Icon(Icons.theaters_outlined),
                title: Text(clip.title),
                subtitle: Text(clip.era),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(clip.caption),
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
