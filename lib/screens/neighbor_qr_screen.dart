import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/neighbor_qr.dart';
import '../utils/neighbor_share.dart';
import '../widgets/simple_qr_view.dart';

class NeighborQrScreen extends StatelessWidget {
  final String userName;
  final String subDistrict;

  const NeighborQrScreen({
    super.key,
    required this.userName,
    required this.subDistrict,
  });

  @override
  Widget build(BuildContext context) {
    final payload = NeighborQr.profilePayload(
      userName: userName,
      subDistrict: subDistrict,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Mój Sąsiedzki Kod QR')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Pokaż ten kod sąsiadowi, aby szybko udostępnić wizytówkę: $userName · $subDistrict',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Center(child: SimpleQrView(data: payload)),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: payload));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Skopiowano kod wizytówki')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Kopiuj kod'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => unawaited(
              NeighborShare.shareText(
                context,
                text: 'Moja wizytówka Lokalnie:\n$payload',
                subject: 'Wizytówka sąsiada',
                copiedMessage: 'Skopiowano wizytówkę QR',
              ),
            ),
            icon: const Icon(Icons.share_outlined),
            label: const Text('Udostępnij wizytówkę'),
          ),
        ],
      ),
    );
  }
}
