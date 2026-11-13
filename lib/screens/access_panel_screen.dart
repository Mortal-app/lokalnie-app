import 'package:flutter/material.dart';

class AccessPanelScreen extends StatefulWidget {
  final double textScale;
  final bool highContrast;
  final bool readability;
  final void Function({
    required double textScale,
    required bool highContrast,
    required bool readability,
  })
  onChanged;

  const AccessPanelScreen({
    super.key,
    required this.textScale,
    required this.highContrast,
    required this.readability,
    required this.onChanged,
  });

  @override
  State<AccessPanelScreen> createState() => _AccessPanelScreenState();
}

class _AccessPanelScreenState extends State<AccessPanelScreen> {
  late double _textScale;
  late bool _highContrast;
  late bool _readability;

  @override
  void initState() {
    super.initState();
    _textScale = widget.textScale;
    _highContrast = widget.highContrast;
    _readability = widget.readability;
  }

  void _persist() {
    widget.onChanged(
      textScale: _textScale,
      highContrast: _highContrast,
      readability: _readability,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Czcionki i dostępność')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Powiększenie tekstu, wyższy kontrast i czytelność dla osób starszych. Osobno od przełącznika „Ciemny motyw” i trybu seniora.',
          ),
          const SizedBox(height: 16),
          Text('Skala tekstu: ${_textScale.toStringAsFixed(2)}×'),
          Slider(
            value: _textScale,
            min: 1.0,
            max: 1.45,
            divisions: 9,
            label: '${_textScale.toStringAsFixed(2)}×',
            onChanged: (value) {
              setState(() => _textScale = value);
              _persist();
            },
          ),
          SwitchListTile(
            title: const Text('Wyższy kontrast'),
            subtitle: const Text('Czytelniejsze tło i tekst w interfejsie'),
            value: _highContrast,
            onChanged: (value) {
              setState(() => _highContrast = value);
              _persist();
            },
          ),
          SwitchListTile(
            title: const Text('Większa czytelność'),
            subtitle: const Text('Większe odstępy i wyraźniejsza typografia'),
            value: _readability,
            onChanged: (value) {
              setState(() => _readability = value);
              _persist();
            },
          ),
        ],
      ),
    );
  }
}
