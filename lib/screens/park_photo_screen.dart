import 'package:flutter/material.dart';

import '../models/park_photo.dart';

class ParkPhotoScreen extends StatelessWidget {
  final List<ParkPhotoClip> items;

  const ParkPhotoScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dawne parki i tereny zielone')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Opisy historycznych zdjęć z budowy Parku Podolskiego, Górki Widzewskiej i osiedlowych skwerów — bez plików graficznych.',
          ),
          const SizedBox(height: 12),
          for (final item in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.park_outlined),
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
