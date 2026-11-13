import 'package:flutter/material.dart';

import '../models/pet_blood.dart';
import '../theme/widzew_ui.dart';

class PetBloodScreen extends StatefulWidget {
  final List<PetBloodDonor> items;
  final String userName;
  final ValueChanged<PetBloodDonor> onAdd;

  const PetBloodScreen({
    super.key,
    required this.items,
    required this.userName,
    required this.onAdd,
  });

  @override
  State<PetBloodScreen> createState() => _PetBloodScreenState();
}

class _PetBloodScreenState extends State<PetBloodScreen> {
  late List<PetBloodDonor> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  Future<void> _add() async {
    final created = await showDialog<PetBloodDonor>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _DonorDialog(userName: widget.userName),
    );
    if (created == null) return;
    setState(() => _items = [created, ..._items]);
    widget.onAdd(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Krwiodawcy zwierzęcy')),
      floatingActionButton: WidzewUi.safeFab(
        FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.pets),
        label: const Text('Zgłoś dawcę'),
      ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const Text(
            'Rejestr psów i kotów — kontakt w nagłych wypadkach, po kwalifikacji weterynaryjnej.',
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.bloodtype_outlined),
                title: Text('${item.kind.label}: ${item.petName}'),
                subtitle: Text(
                  '${item.contact}\n${item.note} · ${item.authorName}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _DonorDialog extends StatefulWidget {
  final String userName;

  const _DonorDialog({required this.userName});

  @override
  State<_DonorDialog> createState() => _DonorDialogState();
}

class _DonorDialogState extends State<_DonorDialog> {
  final _pet = TextEditingController();
  var _kind = PetDonorKind.dog;

  @override
  void dispose() {
    _pet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dawca'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<PetDonorKind>(
              initialValue: _kind,
              items: [
                for (final kind in PetDonorKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _kind = value);
              },
            ),
            TextField(
              controller: _pet,
              decoration: const InputDecoration(labelText: 'Imię / opis zwierzaka'),
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
            Navigator.pop(
              context,
              PetBloodDonor(
                id: 'pb-${DateTime.now().millisecondsSinceEpoch}',
                kind: _kind,
                petName: _pet.text.trim().isEmpty
                    ? _kind.label
                    : _pet.text.trim(),
                contact: 'Kontakt przez aplikację',
                note: 'Dawca awaryjny — po badaniach.',
                authorName: widget.userName,
              ),
            );
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
