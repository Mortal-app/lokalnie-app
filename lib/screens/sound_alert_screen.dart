import 'package:flutter/material.dart';

import '../models/sound_alert.dart';

class SoundAlertScreen extends StatefulWidget {
  final SoundAlertPrefs prefs;
  final ValueChanged<SoundAlertPrefs> onSave;

  const SoundAlertScreen({
    super.key,
    required this.prefs,
    required this.onSave,
  });

  @override
  State<SoundAlertScreen> createState() => _SoundAlertScreenState();
}

class _SoundAlertScreenState extends State<SoundAlertScreen> {
  late SoundAlertPrefs _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = widget.prefs;
  }

  void _commit(SoundAlertPrefs next) {
    setState(() => _prefs = next);
    widget.onSave(next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Powiadomienia dźwiękowe')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Wybierz systemowy sygnał alertów osiedlowych i ustaw Ciche Godziny. To nie zmienia mocka powiadomień systemowych.',
          ),
          const SizedBox(height: 12),
          const Text(
            'Sygnał',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          RadioGroup<String>(
            groupValue: _prefs.soundId,
            onChanged: (value) {
              if (value == null) return;
              _commit(_prefs.copyWith(soundId: value));
            },
            child: Column(
              children: [
                for (final item in SoundAlertPrefs.catalog)
                  RadioListTile<String>(
                    value: item.$1,
                    title: Text(item.$2),
                  ),
              ],
            ),
          ),
          SwitchListTile(
            title: const Text('Ciche godziny'),
            subtitle: Text(
              _prefs.quietHoursEnabled
                  ? 'Wycisz alerty osiedlowe: ${_prefs.quietHoursLabel}'
                  : 'Alerty dźwiękowe bez ograniczeń godzinowych',
            ),
            value: _prefs.quietHoursEnabled,
            onChanged: (value) =>
                _commit(_prefs.copyWith(quietHoursEnabled: value)),
          ),
          if (_prefs.quietHoursEnabled) ...[
            DropdownButtonFormField<int>(
              initialValue: _prefs.quietStartHour,
              decoration: const InputDecoration(labelText: 'Początek ciszy'),
              items: [
                for (final hour in [20, 21, 22, 23])
                  DropdownMenuItem(
                    value: hour,
                    child: Text('${hour.toString().padLeft(2, '0')}:00'),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _commit(_prefs.copyWith(quietStartHour: value));
                }
              },
            ),
            DropdownButtonFormField<int>(
              initialValue: _prefs.quietEndHour,
              decoration: const InputDecoration(labelText: 'Koniec ciszy'),
              items: [
                for (final hour in [5, 6, 7, 8])
                  DropdownMenuItem(
                    value: hour,
                    child: Text('${hour.toString().padLeft(2, '0')}:00'),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _commit(_prefs.copyWith(quietEndHour: value));
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
