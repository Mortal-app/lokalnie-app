import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../theme/widzew_ui.dart';

class AnnouncementPhoto extends StatelessWidget {
  final Announcement announcement;
  final BoxFit fit;
  final double? memCacheWidth;
  final double? memCacheHeight;

  const AnnouncementPhoto({
    super.key,
    required this.announcement,
    this.fit = BoxFit.cover,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    final cacheWidth = WidzewUi.imageCachePixels(
      context,
      memCacheWidth ?? MediaQuery.sizeOf(context).width,
    );
    final cacheHeight = memCacheHeight == null
        ? null
        : WidzewUi.imageCachePixels(context, memCacheHeight!);
    final url = announcement.imageUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        gaplessPlayback: true,
        filterQuality: FilterQuality.low,
        errorBuilder: (_, _, _) => const _PhotoFallback(),
      );
    }

    final path = announcement.imagePath;
    if (!kIsWeb && path != null && path.isNotEmpty) {
      return Image.file(
        File(path),
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        gaplessPlayback: true,
        filterQuality: FilterQuality.low,
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
