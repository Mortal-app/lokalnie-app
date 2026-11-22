import 'package:flutter/material.dart';

import '../models/pavilion_photo.dart';

class PavilionPhotoScreen extends StatelessWidget {
  final List<PavilionPhotoClip> items;

  const PavilionPhotoScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dawne pawilony handlowe')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Opisy zdjęć kultowych pawilonów i blaszaków z lat 80. i 90. w Twojej okolicy — bez plików graficznych.',
          ),
          const SizedBox(height: 12),
          for (final clip in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                leading: const Icon(Icons.store_outlined),
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
