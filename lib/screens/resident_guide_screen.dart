import 'package:flutter/material.dart';

import '../models/resident_guide.dart';

class ResidentGuideScreen extends StatefulWidget {
  const ResidentGuideScreen({super.key});

  @override
  State<ResidentGuideScreen> createState() => _ResidentGuideScreenState();
}

class _ResidentGuideScreenState extends State<ResidentGuideScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final articles = ResidentGuide.articles
        .where((article) => article.matches(_query))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Przewodnik Mieszkańca')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'Szukaj w bazie wiedzy',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: articles.isEmpty
                ? const Center(child: Text('Brak porad dla tej frazy.'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: articles.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Card(
                        child: ExpansionTile(
                          leading: const Icon(Icons.menu_book_outlined),
                          title: Text(article.title),
                          subtitle: Text(article.summary),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(article.body),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
