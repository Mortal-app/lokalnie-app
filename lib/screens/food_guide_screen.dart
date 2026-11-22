import 'package:flutter/material.dart';

import '../models/food_spot.dart';

class FoodGuideScreen extends StatefulWidget {
  final List<FoodSpot> spots;
  final String userName;
  final void Function(String spotId, FoodReview review) onAddReview;

  const FoodGuideScreen({
    super.key,
    required this.spots,
    required this.userName,
    required this.onAddReview,
  });

  @override
  State<FoodGuideScreen> createState() => _FoodGuideScreenState();
}

class _FoodGuideScreenState extends State<FoodGuideScreen> {
  late List<FoodSpot> _spots;

  @override
  void initState() {
    super.initState();
    _spots = List.of(widget.spots);
  }

  Future<void> _review(FoodSpot spot) async {
    final review = await showDialog<FoodReview>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _TasteDialog(userName: widget.userName, place: spot.name),
    );
    if (review == null) return;
    setState(() {
      _spots = _spots
          .map(
            (item) => item.id == spot.id
                ? item.copyWith(reviews: [review, ...item.reviews])
                : item,
          )
          .toList();
    });
    widget.onAddReview(spot.id, review);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smaki okolicy')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: _spots.length,
        itemBuilder: (context, index) {
          final spot = _spots[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spot.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text('${spot.kind} · ${spot.subDistrict}'),
                  const SizedBox(height: 6),
                  Text(spot.description),
                  const SizedBox(height: 8),
                  Text(
                    spot.reviews.isEmpty
                        ? 'Brak ocen Sąsiedzki Smak'
                        : 'Sąsiedzki Smak: ${spot.neighborTaste.toStringAsFixed(1)} ★',
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _review(spot),
                      icon: const Icon(Icons.rate_review_outlined),
                      label: const Text('Dodaj recenzję'),
                    ),
                  ),
                  for (final review in spot.reviews.take(3))
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text('${review.stars}/5 · ${review.authorName}'),
                      subtitle: Text(review.text),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TasteDialog extends StatefulWidget {
  final String userName;
  final String place;

  const _TasteDialog({required this.userName, required this.place});

  @override
  State<_TasteDialog> createState() => _TasteDialogState();
}

class _TasteDialogState extends State<_TasteDialog> {
  final _text = TextEditingController();
  var _stars = 5;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sąsiedzki Smak'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.place),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _stars = i),
                  icon: Icon(
                    i <= _stars ? Icons.star : Icons.star_border,
                    color: const Color(0xFFF9A825),
                  ),
                ),
            ],
          ),
          TextField(
            controller: _text,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Recenzja'),
          ),
        ],
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
              FoodReview(
                authorName: widget.userName,
                stars: _stars,
                text: _text.text.trim().isEmpty
                    ? 'Polecam to miejsce sąsiadom.'
                    : _text.text.trim(),
                createdAt: DateTime.now(),
              ),
            );
          },
          child: const Text('Zapisz ocenę'),
        ),
      ],
    );
  }
}
