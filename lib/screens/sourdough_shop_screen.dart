import 'package:flutter/material.dart';

import '../models/bike_station.dart';
import '../models/sourdough_shop.dart';

class SourdoughShopScreen extends StatelessWidget {
  final List<SourdoughShop> items;

  const SourdoughShopScreen({super.key, required this.items});

  Alignment _align(StationAlign pos) => switch (pos) {
    StationAlign.topLeft => Alignment.topLeft,
    StationAlign.center => Alignment.center,
    StationAlign.bottomRight => Alignment.bottomRight,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pieczywo na zakwasie')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Piekarnie i sklepiki rzemieślnicze z chlebem na zakwasie, bez sztucznych ulepszaczy — osobno od domowych przepisów.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: Text(
                      'Mapa piekarni',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  for (final shop in items)
                    Align(
                      alignment: _align(shop.pos),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.bakery_dining_outlined,
                          color: Color(0xFFEF6C00),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final shop in items)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.bakery_dining_outlined),
                title: Text(shop.name),
                subtitle: Text('${shop.place}\n${shop.note}'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
