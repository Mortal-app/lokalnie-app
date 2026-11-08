import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../widgets/announcement_photo.dart';

class PhotoGalleryScreen extends StatelessWidget {
  final Announcement announcement;

  const PhotoGalleryScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Galeria zdjęć'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 5,
        panEnabled: true,
        clipBehavior: Clip.none,
        child: SizedBox.expand(
          child: Center(
            child: AnnouncementPhoto(
              announcement: announcement,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
