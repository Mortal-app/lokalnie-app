import 'package:flutter/material.dart';

import '../models/school_photo.dart';

class SchoolPhotoScreen extends StatelessWidget {
  final List<SchoolPhotoClip> items;

  const SchoolPhotoScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dawne szkoły Widzewa')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Galeria opisów historycznych zdjęć budynków szkół podstawowych i liceów wschodniej Łodzi — bez plików graficznych.',
          ),
          const SizedBox(height: 12),
          for (final item in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(item.title),
                subtitle: Text('${item.era}\n${item.caption}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
