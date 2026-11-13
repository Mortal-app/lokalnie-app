import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalVaultScreen extends StatefulWidget {
  final bool pinEnabled;
  final String pinCode;
  final bool biometricEnabled;
  final void Function({
    required bool pinEnabled,
    required String pinCode,
    required bool biometricEnabled,
  })
  onChanged;

  const LocalVaultScreen({
    super.key,
    required this.pinEnabled,
    required this.pinCode,
    required this.biometricEnabled,
    required this.onChanged,
  });

  @override
  State<LocalVaultScreen> createState() => _LocalVaultScreenState();
}

class _LocalVaultScreenState extends State<LocalVaultScreen> {
  late bool _pinEnabled;
  late bool _biometricEnabled;
  final _pin = TextEditingController();
  final _confirm = TextEditingController();
  final _unlock = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pinEnabled = widget.pinEnabled;
    _biometricEnabled = widget.biometricEnabled;
  }

  @override
  void dispose() {
    _pin.dispose();
    _confirm.dispose();
    _unlock.dispose();
    super.dispose();
  }

  void _persist({String? pinCode}) {
    widget.onChanged(
      pinEnabled: _pinEnabled,
      pinCode: pinCode ?? widget.pinCode,
      biometricEnabled: _biometricEnabled,
    );
  }

  void _savePin() {
    final pin = _pin.text.trim();
    if (pin.length < 4 || pin != _confirm.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN musi mieć min. 4 cyfry i zgadzać się z potwierdzeniem.'),
        ),
      );
      return;
    }
    setState(() => _pinEnabled = true);
    _persist(pinCode: pin);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PIN lokalnej bazy został zapisany.')),
    );
  }

  void _checkPin() {
    final ok = _unlock.text.trim() == widget.pinCode && widget.pinCode.isNotEmpty;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'PIN poprawny — dane lokalne odblokowane.'
              : 'Niepoprawny PIN.',
        ),
      ),
    );
  }

  void _simulateBiometric() {
    if (!_biometricEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Włącz najpierw odblokowanie biometryczne.'),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Face ID / odcisk palca (symulacja) — lokalna baza odblokowana.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PIN i biometria')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          const Text(
            'Zabezpieczenie lokalnych danych w aplikacji kodem PIN albo uwierzytelnianiem biometrycznym (Face ID / odcisk palca).',
          ),
          SwitchListTile(
            title: const Text('Wymagaj PIN-u'),
            subtitle: const Text('Blokada odczytu kopii lokalnej bazy'),
            value: _pinEnabled,
            onChanged: (value) {
              setState(() => _pinEnabled = value);
              _persist();
            },
          ),
          TextField(
            controller: _pin,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Nowy PIN'),
          ),
          TextField(
            controller: _confirm,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Potwierdź PIN'),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: _savePin, child: const Text('Zapisz PIN')),
          const SizedBox(height: 16),
          TextField(
            controller: _unlock,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Odblokuj PIN-em'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _checkPin,
            child: const Text('Sprawdź PIN'),
          ),
          SwitchListTile(
            title: const Text('Face ID / odcisk palca'),
            subtitle: const Text('Odblokowanie biometryczne (lokalna symulacja)'),
            value: _biometricEnabled,
            onChanged: (value) {
              setState(() => _biometricEnabled = value);
              _persist();
            },
          ),
          FilledButton.tonal(
            onPressed: _simulateBiometric,
            child: const Text('Odblokuj biometrią'),
          ),
        ],
      ),
    );
  }
}
