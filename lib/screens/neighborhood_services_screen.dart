import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../models/neighbor_service.dart';
import '../utils/submit_guard.dart';
import '../utils/utf8_text_guard.dart';
import '../theme/widzew_ui.dart';

class NeighborhoodServicesScreen extends StatefulWidget {
  final List<NeighborService> services;
  final String userName;
  final String defaultSubDistrict;
  final ValueChanged<NeighborService> onAddService;
  final void Function(String serviceId, ServiceReview review) onRecommend;
  final bool canPublishOffers;
  final VoidCallback? onNeedSubscription;

  const NeighborhoodServicesScreen({
    super.key,
    required this.services,
    required this.userName,
    required this.defaultSubDistrict,
    required this.onAddService,
    required this.onRecommend,
    this.canPublishOffers = true,
    this.onNeedSubscription,
  });

  @override
  State<NeighborhoodServicesScreen> createState() =>
      _NeighborhoodServicesScreenState();
}

class _NeighborhoodServicesScreenState
    extends State<NeighborhoodServicesScreen> {
  final _certifiedOnly = false;
  String? _category;
  late List<NeighborService> _services;

  @override
  void initState() {
    super.initState();
    _services = List.of(widget.services);
  }

  List<NeighborService> get _visible {
    return _services.where((service) {
      final matchesCategory =
          _category == null || service.category == _category;
      final matchesTrust = !_certifiedOnly ||
          service.isCertified ||
          service.isRecommended;
      return matchesCategory && matchesTrust;
    }).toList();
  }

  Future<void> _addService() async {
    if (!widget.canPublishOffers) {
      widget.onNeedSubscription?.call();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Publikacja oferty wymaga aktywnego abonamentu PRO fachowca.',
          ),
        ),
      );
      return;
    }
    final created = await showDialog<NeighborService>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _AddServiceDialog(
        userName: widget.userName,
        defaultSubDistrict: widget.defaultSubDistrict,
      ),
    );
    if (created == null || !mounted) return;
    setState(() => _services = [created, ..._services]);
    widget.onAddService(created);
  }

  Future<void> _recommend(NeighborService service) async {
    final review = await showDialog<ServiceReview>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _RecommendDialog(
        userName: widget.userName,
        serviceTitle: service.title,
      ),
    );
    if (review == null || !mounted) return;
    setState(() {
      _services = _services.map((item) {
        if (item.id != service.id) return item;
        return item.copyWith(
          isRecommended: true,
          reviews: [review, ...item.reviews],
        );
      }).toList();
    });
    widget.onRecommend(service.id, review);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fachowiec z okolicy'),
        actions: [
          IconButton(
            tooltip: 'Dodaj usługę',
            onPressed: _addService,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _addService,
        icon: const Icon(Icons.handyman_outlined),
        label: const Text('Dodaj usługę'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilterChip(
                label: const Text('Wszystkie'),
                selected: _category == null,
                onSelected: (_) => setState(() => _category = null),
              ),
              for (final category in NeighborService.categories.take(2))
                FilterChip(
                  label: Text(category),
                  selected: _category == category,
                  onSelected: (_) => setState(
                    () => _category = _category == category ? null : category,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_visible.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Brak usług dla tego filtra.'),
            ),
          for (final service in _visible)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${service.category} · ${service.providerName} · ${service.subDistrict}',
                    ),
                    const SizedBox(height: 6),
                    Text(service.description),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (service.isCertified)
                          const Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text('Certyfikowany'),
                          ),
                        if (service.isRecommended)
                          const Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text('Polecany'),
                          ),
                        Text(
                          service.reviews.isEmpty
                              ? 'Brak opinii'
                              : '${service.rating.toStringAsFixed(1)} ★ (${service.reviews.length})',
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _recommend(service),
                        icon: const Icon(Icons.star_outline),
                        label: const Text('Poleć fachowca'),
                      ),
                    ),
                    if (service.reviews.isNotEmpty)
                      ...service.reviews.take(3).map(
                        (review) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text('${review.stars}/5 · ${review.authorName}'),
                          subtitle: Text(review.text),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddServiceDialog extends StatefulWidget {
  final String userName;
  final String defaultSubDistrict;

  const _AddServiceDialog({
    required this.userName,
    required this.defaultSubDistrict,
  });

  @override
  State<_AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<_AddServiceDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  String _category = NeighborService.categories.first;
  String _subDistrict = Announcement.subDistricts.first;
  var _certified = false;

  @override
  void initState() {
    super.initState();
    _subDistrict = widget.defaultSubDistrict;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dodaj własną usługę'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Nazwa oferty'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Kategoria'),
              items: NeighborService.categories
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _subDistrict,
              decoration: const InputDecoration(labelText: 'Osiedle'),
              items: Announcement.subDistricts
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _subDistrict = value);
              },
            ),
            TextField(
              controller: _description,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Opis'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Mam certyfikat / uprawnienia'),
              value: _certified,
              onChanged: (value) => setState(() => _certified = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: () {
            if (_title.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              NeighborService(
                id: 'svc-${DateTime.now().microsecondsSinceEpoch}',
                title: _title.text.trim(),
                category: _category,
                providerName: widget.userName,
                subDistrict: _subDistrict,
                description: _description.text.trim(),
                isCertified: _certified,
              ),
            );
          },
          child: const Text('Opublikuj'),
        ),
      ],
    );
  }
}

class _RecommendDialog extends StatefulWidget {
  final String userName;
  final String serviceTitle;

  const _RecommendDialog({
    required this.userName,
    required this.serviceTitle,
  });

  @override
  State<_RecommendDialog> createState() => _RecommendDialogState();
}

class _RecommendDialogState extends State<_RecommendDialog> with SubmitGuard {
  final _text = TextEditingController();
  var _stars = 5;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Poleć fachowca'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.serviceTitle),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _stars = i),
                  icon: Icon(
                    i <= _stars ? Icons.star : Icons.star_border,
                    color: const Color(0xFFF9A825),
                  ),
                ),
            ],
          ),
          TextField(
            controller: _text,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Krótka opinia',
              hintText: 'Np. punktualny, uczciwa cena',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        FilledButton(
          onPressed: submitLocked
              ? null
              : () {
                  setState(() => submitLocked = true);
                  Navigator.pop(
                    context,
                    ServiceReview(
                      authorName: widget.userName,
                      stars: _stars,
                      text: Utf8TextGuard.sanitize(_text.text).isEmpty
                          ? 'Polecam tego fachowca z okolicy.'
                          : Utf8TextGuard.sanitize(_text.text),
                      createdAt: DateTime.now(),
                    ),
                  );
                },
          child: const Text('Zapisz opinię'),
        ),
      ],
    );
  }
}
