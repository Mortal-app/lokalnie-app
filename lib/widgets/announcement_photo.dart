import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/announcement.dart';

class AnnouncementPhoto extends StatelessWidget {
  final Announcement announcement;
  final BoxFit fit;

  const AnnouncementPhoto({
    super.key,
    required this.announcement,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final url = announcement.imageUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: fit,
        gaplessPlayback: true,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => const _PhotoFallback(),
      );
    }

    final path = announcement.imagePath;
    if (!kIsWeb && path != null && path.isNotEmpty) {
      return Image.file(
        File(path),
        fit: fit,
        gaplessPlayback: true,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => const _PhotoFallback(),
      );
    }

    return const _PhotoFallback();
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.red.shade50,
      child: const Center(
        child: Icon(Icons.broken_image_outlined, color: Color(0xFFD32F2F)),
      ),
    );
  }
}
