import 'package:flutter/material.dart';

import '../theme/widzew_colors.dart';

enum WidzewSkin {
  classic,
  redBrick,
  parkGreen,
  cityNavy,
  amberGold,
  graphiteOlechow,
}

extension WidzewSkinX on WidzewSkin {
  static const palette = [
    WidzewSkin.classic,
    WidzewSkin.redBrick,
    WidzewSkin.parkGreen,
    WidzewSkin.cityNavy,
    WidzewSkin.amberGold,
  ];

  String get label => switch (this) {
    WidzewSkin.classic => 'Domyślna paleta',
    WidzewSkin.redBrick => 'Czerwona Cegła',
    WidzewSkin.parkGreen => 'Zieleń Parkowa',
    WidzewSkin.cityNavy => 'Granat Miejski',
    WidzewSkin.amberGold => 'Złoty Bursztyn',
    WidzewSkin.graphiteOlechow => 'Grafit',
  };

  Color get seed => switch (this) {
    WidzewSkin.classic => WidzewColors.red,
    WidzewSkin.redBrick => const Color(0xFF8D2B1A),
    WidzewSkin.parkGreen => const Color(0xFF2E7D32),
    WidzewSkin.cityNavy => const Color(0xFF1A365D),
    WidzewSkin.amberGold => const Color(0xFFB7791F),
    WidzewSkin.graphiteOlechow => const Color(0xFF455A64),
  };

  Color get soft => switch (this) {
    WidzewSkin.classic => WidzewColors.redSoft,
    WidzewSkin.redBrick => const Color(0xFFF3E0DA),
    WidzewSkin.parkGreen => const Color(0xFFE8F5E9),
    WidzewSkin.cityNavy => const Color(0xFFE8EEF6),
    WidzewSkin.amberGold => const Color(0xFFF8F0DC),
    WidzewSkin.graphiteOlechow => const Color(0xFFECEFF1),
  };

  static WidzewSkin fromStorage(String? value) {
    return WidzewSkin.values.firstWhere(
      (item) => item.name == value,
      orElse: () => WidzewSkin.classic,
    );
  }
}
