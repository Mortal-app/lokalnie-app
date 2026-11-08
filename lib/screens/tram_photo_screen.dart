import 'package:flutter/material.dart';

import '../models/tram_photo.dart';

class TramPhotoScreen extends StatelessWidget {
  final List<TramPhotoClip> items;

  const TramPhotoScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dawny tramwaj na Widzewie')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Archiwum opisów zdjęć dawnych linii, rozjazdów i pętli na Widzewie Wschodzie i Olechowie — bez plików graficznych.',
          ),
          const SizedBox(height: 12),
          for (final clip in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                leading: const Icon(Icons.tram_outlined),
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
