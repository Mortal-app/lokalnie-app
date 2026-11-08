import 'package:flutter/material.dart';

import '../models/neighborhood_event.dart';

class AddEventScreen extends StatefulWidget {
  final String initialPlace;

  const AddEventScreen({super.key, this.initialPlace = 'Widzew Wschód'});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _placeController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _placeController.text = widget.initialPlace;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now().add(const Duration(days: 1));
    Navigator.of(context).pop(
      NeighborhoodEvent(
        id: 'event-${now.millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        place: _placeController.text.trim(),
        description: _descriptionController.text.trim(),
        startsAt: DateTime(now.year, now.month, now.day, 17),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj wydarzenie')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nazwa wydarzenia',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Wpisz nazwę wydarzenia'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _placeController,
              decoration: const InputDecoration(
                labelText: 'Miejsce',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Opis',
                border: OutlineInputBorder(),
              ),
              minLines: 3,
              maxLines: 5,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.event_available),
            label: const Text('Opublikuj wydarzenie'),
          ),
        ),
      ),
    );
  }
}
