import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../services/announcement_storage.dart';
import '../services/app_image_picker.dart';
import '../services/board_safety.dart';
import '../services/form_draft_store.dart';
import '../services/widzew_location.dart';
import '../utils/flutter_runtime.dart';
import '../theme/widzew_ui.dart';
import '../widgets/route_pop_scope.dart';

class SnapPostScreen extends StatefulWidget {
  final String initialSubDistrict;
  final String authorName;
  final AppImagePicker imagePicker;

  const SnapPostScreen({
    super.key,
    required this.initialSubDistrict,
    required this.authorName,
    this.imagePicker = const AppImagePicker(),
  });

  @override
  State<SnapPostScreen> createState() => _SnapPostScreenState();
}

class _SnapPostScreenState extends State<SnapPostScreen> {
  final _descriptionController = TextEditingController();
  final _placeController = TextEditingController();
  String? _imagePath;
  WidzewFix? _fix;
  var _locating = false;

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

  @override
  void initState() {
    super.initState();
    final peek = FormDraftStore.peek(FormDraftStore.snapPost);
    if (peek.isNotEmpty) {
      _descriptionController.text = peek['description'] ?? '';
      _placeController.text = peek['place'] ?? '';
    }
    void persist() {
      FormDraftStore.save(FormDraftStore.snapPost, {
        'description': _descriptionController.text,
        'place': _placeController.text,
      });
    }

    _descriptionController.addListener(persist);
    _placeController.addListener(persist);
    unawaited(_restoreDraft());
    _locate();
  }

  Future<void> _restoreDraft() async {
    final draft = await FormDraftStore.load(FormDraftStore.snapPost);
    if (!mounted || draft.isEmpty) return;
    _descriptionController.text =
        draft['description'] ?? _descriptionController.text;
    _placeController.text = draft['place'] ?? _placeController.text;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  Future<void> _locate() async {
    setState(() => _locating = true);
    final fix = await WidzewLocation.current();
    if (!mounted) return;
    setState(() {
      _fix = fix;
      _locating = false;
    });
  }

  Future<void> _capture() async {
    try {
      final path = await widget.imagePicker.pickFromCamera();
      if (path == null || !mounted) return;
      setState(() => _imagePath = path);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nie udało się zrobić zdjęcia. Spróbuj ponownie.'),
        ),
      );
    }
  }

  String get _resolvedPlace {
    final typed = _placeController.text.trim();
    if (typed.isNotEmpty) return typed;
    final gps = _fix;
    if (gps != null && gps.success && gps.subDistrict.isNotEmpty) {
      return gps.subDistrict;
    }
    return '';
  }

  var _submitting = false;

  Future<void> _submit() async {
    if (_submitting) return;
    final description = _descriptionController.text.trim();
    if (description.isEmpty && (_imagePath == null || _imagePath!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dodaj zdjęcie albo krótki opis.')),
      );
      return;
    }
    final filter = ContentFilter.inspect(description);
    if (filter.blocked) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(filter.message)));
      return;
    }
    final path = _imagePath;
    String? imageBase64;
    if (path != null && path.isNotEmpty && !isFlutterWidgetTest) {
      setState(() => _submitting = true);
      final encoded = await AnnouncementStorage.uploadResult(localPath: path);
      if (!mounted) return;
      setState(() => _submitting = false);
      imageBase64 = encoded.imageBase64;
      if (!encoded.isOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              encoded.errorMessage ??
                  'Nie udało się przygotować miniaturki. Zgłoszenie zapisze się bez zdjęcia.',
            ),
          ),
        );
      }
    }
    final place = _resolvedPlace;
    final fix = _fix;
    final district = place.isEmpty ? 'Twoja okolica' : place;
    FormDraftStore.clear(FormDraftStore.snapPost);
    if (!mounted) return;
    Navigator.of(context).pop(
      Announcement(
        title: description.isEmpty ? 'Usterka: $district' : description,
        category: Announcement.alertCategory,
        subDistrict: district,
        time: 'Teraz',
        icon: Icons.warning_amber_rounded,
        publishedAt: DateTime.now(),
        description: [
          if (description.isNotEmpty) description,
          if (fix != null && fix.success) 'GPS: ${fix.addressLabel}',
          if (place.isNotEmpty) 'Miejsce: $place',
          if (description.isEmpty)
            'Szybkie zgłoszenie usterki (ławka, dziura, awaria).',
        ].join('\n'),
        isMine: true,
        authorName: widget.authorName,
        imagePath: _imagePath,
        imageBase64: imageBase64,
        latitude: fix != null && fix.success ? fix.latitude : null,
        longitude: fix != null && fix.success ? fix.longitude : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final previewFill = scheme.surfaceContainerHighest;
    final gpsOk = _fix?.success == true;

    return RoutePopScope(
      child: Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        title: const Text('Szybkie zgłoszenie'),
      ),
      body: ListView(
        key: const ValueKey('snap-post-list'),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          Text(
            'Szybkie zgłoszenie usterki na tablicę Lokalnie. Zdjęcie i opis są opcjonalne — wystarczy jedno z nich. GPS nie jest wymagany.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: _locating
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      gpsOk ? Icons.my_location : Icons.location_off_outlined,
                      color: gpsOk
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
              title: Text(
                _locating
                    ? 'Szukam GPS…'
                    : gpsOk
                    ? 'Lokalizacja GPS'
                    : 'GPS niedostępny (opcjonalnie)',
              ),
              subtitle: Text(
                _locating
                    ? 'Pobieram współrzędne…'
                    : gpsOk
                    ? (_fix?.addressLabel ?? 'Współrzędne zapisane')
                    : 'Możesz wpisać adres poniżej albo zostawić „Twoja okolica”.',
              ),
              trailing: IconButton(
                tooltip: 'Odśwież GPS',
                onPressed: _locating ? null : _locate,
                icon: const Icon(Icons.refresh),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _placeController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Adres lub okolica (opcjonalnie)',
              hintText: 'Np. ulica, osiedle albo Twoja okolica',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit_location_alt_outlined),
            ),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: previewFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _imagePath == null
                  ? Center(
                      child: Icon(
                        Icons.photo_camera_outlined,
                        size: 48,
                        color: scheme.onSurface,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _showFilePreview
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
                            )
                          : ColoredBox(
                              color: previewFill,
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: _capture,
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text(_imagePath == null ? 'Zrób zdjęcie' : 'Zmień zdjęcie'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Krótki opis (opcjonalnie)',
              hintText: 'Np. dziura w jezdni przy Twojej ulicy',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 64,
            child: FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: const Icon(Icons.report, size: 28),
              label: const Text(
                'Zgłoś usterkę teraz',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
