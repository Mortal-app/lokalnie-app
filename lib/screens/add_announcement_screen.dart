import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/borrow_terms.dart';
import '../services/announcement_storage.dart';
import '../services/cloud_error_messages.dart';
import '../services/app_image_picker.dart';
import '../services/board_safety.dart';
import '../services/form_draft_store.dart';
import '../utils/flutter_runtime.dart';
import '../theme/widzew_ui.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/route_pop_scope.dart';

class AddAnnouncementScreen extends StatefulWidget {
  final String initialSubDistrict;
  final String authorName;
  final AppImagePicker imagePicker;
  final Announcement? existing;
  final String? initialCategory;

  const AddAnnouncementScreen({
    super.key,
    this.initialSubDistrict = 'Twoja okolica',
    this.authorName = 'Sąsiad',
    this.imagePicker = const AppImagePicker(),
    this.existing,
    this.initialCategory,
  });

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _placeController = TextEditingController();
  String _category = 'Sąsiedzi';
  String _subDistrict = Announcement.subDistricts.first;
  String? _imagePath;
  String? _imageUrl;
  String? _imageBase64;
  var _uploading = false;
  BorrowTerms _borrowTerms = BorrowTerms.free;

  static const _categories = Announcement.formCategories;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _titleController.text = existing.title;
      _descriptionController.text = existing.description;
      _priceController.text = existing.price ?? '';
      _category = Announcement.canonicalizeCategory(existing.category);
      _subDistrict = existing.subDistrict;
      _placeController.text = existing.subDistrict;
      _imagePath = existing.imagePath;
      _imageUrl = existing.imageUrl;
      _imageBase64 = existing.imageBase64;
      _borrowTerms = existing.borrowTerms ?? BorrowTerms.free;
    } else {
      _subDistrict = widget.initialSubDistrict;
      _placeController.text = widget.initialSubDistrict;
      final initialCategory = widget.initialCategory;
      if (initialCategory != null) {
        _category = Announcement.canonicalizeCategory(initialCategory);
      }
      final peek = FormDraftStore.peek(FormDraftStore.addAnnouncement);
      if (peek.isNotEmpty) {
        _titleController.text = peek['title'] ?? '';
        _descriptionController.text = peek['description'] ?? '';
        _priceController.text = peek['price'] ?? '';
        final category = peek['category'];
        if (category != null) {
          _category = Announcement.canonicalizeCategory(category);
        }
        final subDistrict = peek['subDistrict'];
        if (subDistrict != null && subDistrict.trim().isNotEmpty) {
          _subDistrict = subDistrict;
          _placeController.text = subDistrict;
        }
      }
      _titleController.addListener(_persistDraft);
      _descriptionController.addListener(_persistDraft);
      _priceController.addListener(_persistDraft);
      unawaited(_restoreDraft());
    }
  }

  Future<void> _restoreDraft() async {
    final draft = await FormDraftStore.load(FormDraftStore.addAnnouncement);
    if (!mounted || draft.isEmpty) return;
    setState(() {
      _titleController.text = draft['title'] ?? _titleController.text;
      _descriptionController.text =
          draft['description'] ?? _descriptionController.text;
      _priceController.text = draft['price'] ?? _priceController.text;
      final category = draft['category'];
      if (category != null) {
        _category = Announcement.canonicalizeCategory(category);
      }
      final subDistrict = draft['subDistrict'];
      if (subDistrict != null && subDistrict.trim().isNotEmpty) {
        _subDistrict = subDistrict;
        _placeController.text = subDistrict;
      }
    });
  }

  void _persistDraft() {
    if (_isEditing) return;
    FormDraftStore.save(FormDraftStore.addAnnouncement, {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'category': _category,
      'subDistrict': _subDistrict,
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  IconData get _categoryIcon {
    if (_category == Announcement.alertCategory ||
        _category == Announcement.wildlifeCategory) {
      return Icons.warning_amber_rounded;
    }
    if (_category == Announcement.petCategory) {
      return Icons.pets_outlined;
    }
    if (_category == Announcement.lendingCategory) {
      return Icons.handyman_outlined;
    }
    if (_category == Announcement.otherCategory) {
      return Icons.more_horiz;
    }
    return Icons.campaign;
  }

  bool get _isLending => _category == Announcement.lendingCategory;

  Future<void> _submit() async {
    if (_uploading) return;
    if (!_formKey.currentState!.validate()) return;
    final filter = ContentFilter.inspect(
      '${_titleController.text} ${_descriptionController.text} ${_priceController.text}',
    );
    if (filter.blocked) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(filter.message)));
      return;
    }
    FormDraftStore.clear(FormDraftStore.addAnnouncement);
    final place = _placeController.text.trim();
    _subDistrict = place.isEmpty ? Announcement.subDistricts.first : place;
    final price = _priceController.text.trim();
    var imageUrl = _imageUrl;
    var imageBase64 = _imageBase64;
    final path = _imagePath;
    final needsEncode =
        path != null &&
        path.isNotEmpty &&
        (imageBase64 == null || imageBase64.isEmpty) &&
        !isFlutterWidgetTest;
    if (needsEncode) {
      setState(() => _uploading = true);
      final upload = await AnnouncementStorage.uploadResult(localPath: path);
      if (!mounted) return;
      setState(() => _uploading = false);
      imageBase64 = upload.imageBase64;
      _imageBase64 = imageBase64;
      if (!upload.isOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(upload.errorMessage ?? CloudErrorMessages.photoFailed),
          ),
        );
      }
    }
    final existing = widget.existing;
    if (existing != null) {
      Navigator.of(context).pop(
        existing.copyWith(
          title: _titleController.text.trim(),
          category: _category,
          subDistrict: _subDistrict,
          description: _descriptionController.text.trim(),
          icon: _categoryIcon,
          imagePath: _imagePath,
          imageUrl: imageUrl,
          imageBase64: imageBase64,
          clearImageMedia: _imagePath == null &&
              (imageBase64 == null || imageBase64.isEmpty) &&
              (imageUrl == null || imageUrl.isEmpty),
          price: price,
          borrowTerms: _isLending ? _borrowTerms : existing.borrowTerms,
        ),
      );
      return;
    }
    Navigator.of(context).pop(
      Announcement(
        title: _titleController.text.trim(),
        category: _category,
        subDistrict: _subDistrict,
        time: 'Teraz',
        icon: _categoryIcon,
        publishedAt: DateTime.now(),
        description: _descriptionController.text.trim(),
        isMine: true,
        authorName: widget.authorName,
        imagePath: _imagePath,
        imageUrl: imageUrl,
        imageBase64: imageBase64,
        price: price.isEmpty ? null : price,
        borrowTerms: _isLending ? _borrowTerms : null,
      ),
    );
  }

  bool get _hasPhoto {
    final path = _imagePath;
    final encoded = _imageBase64;
    return (path != null && path.isNotEmpty) ||
        (encoded != null && encoded.isNotEmpty);
  }

  Uint8List? get _previewBytes {
    final encoded = _imageBase64;
    if (encoded == null || encoded.isEmpty) return null;
    try {
      final payload = encoded.contains(',') ? encoded.split(',').last : encoded;
      if (payload.isEmpty) return null;
      final bytes = base64Decode(payload);
      return bytes.isEmpty ? null : bytes;
    } catch (_) {
      return null;
    }
  }

  bool get _showFilePreview {
    final path = _imagePath;
    if (kIsWeb || path == null || path.isEmpty) return false;
    if (WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgets',
    )) {
      return false;
    }
    return true;
  }

  Future<void> _pickImage() async {
    try {
      final path = await widget.imagePicker.pickFromGallery();
      if (path == null || !mounted) return;
      setState(() {
        _imagePath = path;
        _imageUrl = null;
        _imageBase64 = null;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nie udało się wybrać zdjęcia. Spróbuj ponownie.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoutePopScope(
      child: Scaffold(
      appBar: AppBar(
        leading: ModalRoute.of(context)?.impliesAppBarDismissal == true
            ? const AppBarBackButton()
            : null,
        title: Text(_isEditing ? 'Edytuj ogłoszenie' : 'Dodaj ogłoszenie'),
      ),
      body: FadeSlideIn(
        child: Stack(
          children: [
            Form(
          key: _formKey,
          child: ListView(
            key: const ValueKey('add-announcement-list'),
            padding: WidzewUi.insetsWide.copyWith(
              bottom: WidzewUi.scrollBottom,
            ),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tytuł ogłoszenia',
                  border: OutlineInputBorder(
                    borderRadius: WidzewUi.borderRadius,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Wpisz tytuł ogłoszenia'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _placeController,
                decoration: const InputDecoration(
                  labelText: 'Lokalizacja (opcjonalnie)',
                  hintText: 'Adres, osiedle lub Twoja okolica',
                  border: OutlineInputBorder(
                    borderRadius: WidzewUi.borderRadius,
                  ),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  _subDistrict = value.trim().isEmpty
                      ? Announcement.subDistricts.first
                      : value.trim();
                  _persistDraft();
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Kategoria',
                  border: OutlineInputBorder(
                    borderRadius: WidzewUi.borderRadius,
                  ),
                ),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (category == Announcement.alertCategory) ...[
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFFE65100),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(category),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _category = value!);
                  _persistDraft();
                },
              ),
              if (_isLending) ...[
                const SizedBox(height: 8),
                Text(
                  'Np. wiertarka, drabina, bagażnik dachowy, kosiarka, gry planszowe.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<BorrowTerms>(
                  initialValue: _borrowTerms,
                  decoration: const InputDecoration(
                    labelText: 'Warunki wypożyczenia',
                    border: OutlineInputBorder(
                      borderRadius: WidzewUi.borderRadius,
                    ),
                  ),
                  items: BorrowTerms.values
                      .map(
                        (terms) => DropdownMenuItem(
                          value: terms,
                          child: Text(terms.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _borrowTerms = value);
                  },
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Cena / warunki (opcjonalnie)',
                  border: OutlineInputBorder(
                    borderRadius: WidzewUi.borderRadius,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Opis (opcjonalnie)',
                  hintText: 'Szczegóły ogłoszenia — możesz zostawić puste',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: WidzewUi.borderRadius,
                  ),
                ),
                minLines: 4,
                maxLines: 7,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              Text(
                'Zdjęcie (opcjonalnie)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (_hasPhoto) ...[
                const Text('Podgląd zdjęcia'),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: WidzewUi.borderRadius,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _showFilePreview
                            ? Image.file(
                                File(_imagePath!),
                                fit: BoxFit.cover,
                                cacheWidth: WidzewUi.imageCachePixels(
                                  context,
                                  MediaQuery.sizeOf(context).width,
                                ),
                                cacheHeight: WidzewUi.imageCachePixels(
                                  context,
                                  MediaQuery.sizeOf(context).width * 9 / 16,
                                ),
                                errorBuilder: (_, _, _) => const ColoredBox(
                                  color: Color(0xFFFFEBEE),
                                  child: Center(
                                    child: Icon(Icons.image_outlined),
                                  ),
                                ),
                              )
                            : (_previewBytes != null
                                  ? Image.memory(
                                      _previewBytes!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) =>
                                          const ColoredBox(
                                            color: Color(0xFFFFEBEE),
                                            child: Center(
                                              child: Icon(Icons.image_outlined),
                                            ),
                                          ),
                                    )
                                  : const ColoredBox(
                                      color: Color(0xFFFFEBEE),
                                      child: Center(
                                        child: Icon(Icons.image_outlined),
                                      ),
                                    )),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton.filled(
                            tooltip: 'Usuń wybrane zdjęcie',
                            onPressed: () => setState(() {
                              _imagePath = null;
                              _imageUrl = null;
                              _imageBase64 = null;
                            }),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(
                  _hasPhoto ? 'Zmień zdjęcie' : 'Dodaj zdjęcie',
                ),
              ),
              if (_hasPhoto)
                TextButton.icon(
                  onPressed: () => setState(() {
                    _imagePath = null;
                    _imageUrl = null;
                    _imageBase64 = null;
                  }),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Usuń zdjęcie'),
                ),
            ],
          ),
        ),
            if (_uploading)
              const ColoredBox(
                color: Color(0x66000000),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Przygotowujemy zdjęcie…',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: _uploading ? null : _submit,
            icon: Icon(_uploading ? Icons.cloud_upload : Icons.publish),
            label: Text(
              _uploading
                  ? 'Przygotowujemy zdjęcie…'
                  : (_isEditing ? 'Zapisz zmiany' : 'Opublikuj ogłoszenie'),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
