import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/tradesperson_marketplace.dart';
import '../theme/widzew_ui.dart';

class PathPhotoGalleryScreen extends StatefulWidget {
  final List<PortfolioPhoto> photos;
  final int initialIndex;

  const PathPhotoGalleryScreen({
    super.key,
    required this.photos,
    this.initialIndex = 0,
  });

  factory PathPhotoGalleryScreen.single({required PortfolioPhoto photo}) {
    return PathPhotoGalleryScreen(photos: [photo]);
  }

  @override
  State<PathPhotoGalleryScreen> createState() => _PathPhotoGalleryScreenState();
}

class _PathPhotoGalleryScreenState extends State<PathPhotoGalleryScreen> {
  late final PageController _pages;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.photos.isEmpty
        ? 0
        : widget.initialIndex.clamp(0, widget.photos.length - 1);
    _pages = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(),
      );
    }
    final photo = widget.photos[_index];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '${photo.phaseLabel} · ${photo.caption}  (${_index + 1}/${widget.photos.length})',
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: PageView.builder(
        controller: _pages,
        itemCount: widget.photos.length,
        onPageChanged: (index) => setState(() => _index = index),
        itemBuilder: (context, index) {
          final item = widget.photos[index];
          return InteractiveViewer(
            minScale: 1,
            maxScale: 5,
            panEnabled: true,
            clipBehavior: Clip.none,
            child: Center(
              child: PortfolioImage(
                photo: item,
                fit: BoxFit.contain,
                memCacheWidth: MediaQuery.sizeOf(context).width,
                memCacheHeight: MediaQuery.sizeOf(context).height,
              ),
            ),
          );
        },
      ),
    );
  }
}

class PortfolioRealizationStrip extends StatelessWidget {
  final List<PortfolioPhoto> photos;
  final ValueChanged<int> onOpenAt;

  const PortfolioRealizationStrip({
    super.key,
    required this.photos,
    required this.onOpenAt,
  });

  List<(PortfolioPhoto?, PortfolioPhoto?)> get _pairs {
    final before = photos.where((item) => item.phase == 'przed').toList();
    final after = photos.where((item) => item.phase == 'po').toList();
    final count = before.length > after.length ? before.length : after.length;
    if (count == 0) {
      return [for (final photo in photos) (null, photo)];
    }
    return [
      for (var i = 0; i < count; i++)
        (
          i < before.length ? before[i] : null,
          i < after.length ? after[i] : null,
        ),
    ];
  }

  int _indexOf(PortfolioPhoto photo) =>
      photos.indexWhere((item) => item.id == photo.id);

  @override
  Widget build(BuildContext context) {
    final pairs = _pairs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Realizacje na osiedlu — przesuń, żeby obejrzeć prace Przed / Po',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 196,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.92),
            itemCount: pairs.length,
            itemBuilder: (context, index) {
              final pair = pairs[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pair.$2?.caption.isNotEmpty == true
                              ? pair.$2!.caption
                              : pair.$1?.caption ?? 'Realizacja ${index + 1}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _PhaseTile(
                                  photo: pair.$1,
                                  fallbackLabel: 'Przed',
                                  onTap: pair.$1 == null
                                      ? null
                                      : () => onOpenAt(_indexOf(pair.$1!)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _PhaseTile(
                                  photo: pair.$2,
                                  fallbackLabel: 'Po',
                                  onTap: pair.$2 == null
                                      ? null
                                      : () => onOpenAt(_indexOf(pair.$2!)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PhaseTile extends StatelessWidget {
  final PortfolioPhoto? photo;
  final String fallbackLabel;
  final VoidCallback? onTap;

  const _PhaseTile({
    required this.photo,
    required this.fallbackLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: WidzewUi.borderRadius,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: WidzewUi.borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (photo != null)
              PortfolioImage(
                photo: photo!,
                memCacheWidth: MediaQuery.sizeOf(context).width / 2,
                memCacheHeight: 160,
              )
            else
              ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Center(child: Text(fallbackLabel)),
              ),
            Positioned(
              left: 6,
              top: 6,
              child: Chip(
                visualDensity: VisualDensity.compact,
                label: Text(photo?.phaseLabel ?? fallbackLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioImage extends StatelessWidget {
  final PortfolioPhoto photo;
  final BoxFit fit;
  final double? memCacheWidth;
  final double? memCacheHeight;

  const PortfolioImage({
    super.key,
    required this.photo,
    this.fit = BoxFit.cover,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  @override
  Widget build(BuildContext context) => _PortfolioImage(
    photo: photo,
    fit: fit,
    memCacheWidth: memCacheWidth,
    memCacheHeight: memCacheHeight,
  );
}

class _PortfolioImage extends StatelessWidget {
  final PortfolioPhoto photo;
  final BoxFit fit;
  final double? memCacheWidth;
  final double? memCacheHeight;

  const _PortfolioImage({
    required this.photo,
    required this.fit,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && photo.path.isNotEmpty) {
      return Image.file(
        File(photo.path),
        fit: fit,
        cacheWidth: WidzewUi.imageCachePixels(
          context,
          memCacheWidth ?? MediaQuery.sizeOf(context).width,
        ),
        cacheHeight: memCacheHeight == null
            ? null
            : WidzewUi.imageCachePixels(context, memCacheHeight!),
        filterQuality: FilterQuality.low,
        errorBuilder: (_, _, _) => _fallback(photo),
      );
    }
    return _fallback(photo);
  }

  Widget _fallback(PortfolioPhoto photo) {
    return ColoredBox(
      color: photo.phase == 'przed'
          ? const Color(0xFF4E342E)
          : const Color(0xFF1B5E20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              photo.phase == 'przed'
                  ? Icons.broken_image_outlined
                  : Icons.photo_outlined,
              color: Colors.white70,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              photo.phaseLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (photo.caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                child: Text(
                  photo.caption,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
