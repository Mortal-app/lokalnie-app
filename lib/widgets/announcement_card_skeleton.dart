import 'package:flutter/material.dart';

class AnnouncementCardSkeleton extends StatelessWidget {
  const AnnouncementCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final placeholder = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundColor: placeholder, radius: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bone(color: placeholder, width: 220, height: 14),
                  const SizedBox(height: 8),
                  _Bone(color: placeholder, width: 140, height: 10),
                  const SizedBox(height: 8),
                  _Bone(color: placeholder, width: 90, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementListSkeleton extends StatelessWidget {
  const AnnouncementListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AnnouncementCardSkeleton(),
        AnnouncementCardSkeleton(),
        AnnouncementCardSkeleton(),
      ],
    );
  }
}

class _Bone extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const _Bone({
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
