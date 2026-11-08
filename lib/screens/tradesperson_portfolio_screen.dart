import 'package:flutter/material.dart';

import '../models/tradesperson_marketplace.dart';
import '../services/app_image_picker.dart';
import '../utils/utf8_text_guard.dart';
import '../theme/widzew_ui.dart';
import '../widgets/app_page_route.dart';
import 'path_photo_gallery_screen.dart';

class TradespersonPortfolioScreen extends StatelessWidget {
  final List<PortfolioPhoto> photos;
  final bool canEdit;
  final ValueChanged<PortfolioPhoto>? onAdd;
  final ValueChanged<String>? onRemove;

  const TradespersonPortfolioScreen({
    super.key,
    required this.photos,
    this.canEdit = false,
    this.onAdd,
    this.onRemove,
  });

  Future<void> _add(BuildContext context) async {
    final path = await const AppImagePicker().pickFromGallery();
    if (path == null || !context.mounted) return;
    var phase = 'po';
    final caption = TextEditingController();
    final photo = await showDialog<PortfolioPhoto>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Zdjęcie realizacji'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: caption,
                    decoration: const InputDecoration(
                      labelText: 'Opis (np. wymiana spłuczki)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'przed', label: Text('Przed')),
                      ButtonSegment(value: 'po', label: Text('Po')),
                    ],
                    selected: {phase},
                    onSelectionChanged: (value) {
                      setDialogState(() => phase = value.first);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Anuluj'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      PortfolioPhoto(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        path: path,
                        caption: Utf8TextGuard.sanitize(caption.text).isEmpty
                            ? 'Realizacja'
                            : Utf8TextGuard.sanitize(caption.text),
                        phase: phase,
                      ),
                    );
                  },
                  child: const Text('Dodaj'),
                ),
              ],
            );
          },
        );
      },
    );
    caption.dispose();
    if (photo == null || !context.mounted) return;
    onAdd?.call(photo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zdjęcia moich prac')),
      floatingActionButton: canEdit
          ? FloatingActionButton.extended(
              onPressed: () => _add(context),
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text('Dodaj zdjęcie'),
            )
          : null,
      body: photos.isEmpty
          ? const Center(
              child: Text('Brak zdjęć realizacji. Dodaj pary Przed / Po.'),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.92,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return InkWell(
                  borderRadius: WidzewUi.borderRadius,
                  onTap: () {
                    Navigator.of(context).push(
                      AppPageRoute<void>(
                        builder: (_) => PathPhotoGalleryScreen(
                          photos: photos,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: WidzewUi.borderRadius,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PortfolioImage(photo: photo),
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text(photo.phaseLabel),
                          ),
                        ),
                        if (canEdit)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: IconButton.filled(
                              tooltip: 'Usuń zdjęcie',
                              onPressed: () => onRemove?.call(photo.id),
                              icon: const Icon(Icons.delete_outline, size: 18),
                            ),
                          ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: ColoredBox(
                            color: Colors.black54,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                photo.caption,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
