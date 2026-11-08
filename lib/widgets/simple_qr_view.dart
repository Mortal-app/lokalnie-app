import 'dart:convert';

import 'package:flutter/material.dart';

/// Wizytówka QR bez dodatkowego pakietu: macierz z ładunku (czytelna
/// w aplikacji po skanie/wklejeniu tego samego URI).
class SimpleQrView extends StatelessWidget {
  final String data;
  final double size;

  const SimpleQrView({super.key, required this.data, this.size = 220});

  @override
  Widget build(BuildContext context) {
    final cells = _matrix(data);
    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _QrPainter(cells)),
        ),
        const SizedBox(height: 8),
        SelectableText(
          data,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  static List<List<bool>> _matrix(String data) {
    const dim = 21;
    final bytes = utf8.encode(data);
    final cells = List.generate(dim, (_) => List<bool>.filled(dim, false));
    for (var y = 0; y < dim; y++) {
      for (var x = 0; x < dim; x++) {
        final finder = (x < 7 && y < 7) ||
            (x >= dim - 7 && y < 7) ||
            (x < 7 && y >= dim - 7);
        if (finder) {
          final onFinder = x == 0 ||
              y == 0 ||
              x == 6 ||
              y == 6 ||
              x == dim - 1 ||
              y == dim - 1 ||
              x == dim - 7 ||
              y == dim - 7 ||
              (x >= 2 && x <= 4 && y >= 2 && y <= 4) ||
              (x >= dim - 5 && x <= dim - 3 && y >= 2 && y <= 4) ||
              (x >= 2 && x <= 4 && y >= dim - 5 && y <= dim - 3);
          cells[y][x] = onFinder;
          continue;
        }
        final i = (y * dim + x) % bytes.length;
        cells[y][x] = ((bytes[i] + x * 3 + y * 5) & 1) == 1;
      }
    }
    return cells;
  }
}

class _QrPainter extends CustomPainter {
  final List<List<bool>> cells;

  _QrPainter(this.cells);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF111111);
    final dim = cells.length;
    final cell = size.width / dim;
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFFFFFFF));
    for (var y = 0; y < dim; y++) {
      for (var x = 0; x < dim; x++) {
        if (!cells[y][x]) continue;
        canvas.drawRect(
          Rect.fromLTWH(x * cell, y * cell, cell, cell),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) => false;
}
