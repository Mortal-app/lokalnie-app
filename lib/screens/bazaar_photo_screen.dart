import 'package:flutter/material.dart';

import '../models/bazaar_photo.dart';

class BazaarPhotoScreen extends StatelessWidget {
  final List<BazaarPhotoClip> items;

  const BazaarPhotoScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dawne bazary w Twojej okolicy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Opisy zdjęć ryneczków i handlu osiedlowego wschodniej części miasta z lat 90. — bez plików graficznych.',
          ),
          const SizedBox(height: 12),
          for (final clip in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                leading: const Icon(Icons.storefront_outlined),
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
