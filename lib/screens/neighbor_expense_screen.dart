import 'package:flutter/material.dart';

class NeighborExpenseScreen extends StatefulWidget {
  const NeighborExpenseScreen({super.key});

  @override
  State<NeighborExpenseScreen> createState() => _NeighborExpenseScreenState();
}

class _NeighborExpenseScreenState extends State<NeighborExpenseScreen> {
  final _totalController = TextEditingController();
  final _peopleController = TextEditingController(text: '2');
  final _noteController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _totalController.dispose();
    _peopleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _split() {
    final total = double.tryParse(
      _totalController.text.trim().replaceAll(',', '.'),
    );
    final people = int.tryParse(_peopleController.text.trim());
    if (total == null || total <= 0 || people == null || people < 1) {
      setState(() => _result = 'Podaj kwotę i liczbę sąsiadów.');
      return;
    }
    final share = total / people;
    final note = _noteController.text.trim();
    setState(() {
      _result =
          'Po ${share.toStringAsFixed(2)} zł na osobę '
          '($people osób, ${total.toStringAsFixed(2)} zł'
          '${note.isEmpty ? '' : ', $note'}).';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator Sąsiedzki')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          const Text(
            'Rozlicz wspólne zakupy: koszenie trawnika, wyjazd do marketu budowlanego, zrzutka na klatkę.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _totalController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Kwota razem (zł)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _peopleController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Liczba sąsiadów',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Za co? (opcjonalnie)',
              hintText: 'Np. kosiarka / Castorama',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _split,
            icon: const Icon(Icons.calculate_outlined),
            label: const Text('Podziel koszty'),
          ),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _result,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
