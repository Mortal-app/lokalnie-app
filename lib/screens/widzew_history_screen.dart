import 'package:flutter/material.dart';

import '../models/widzew_history.dart';

class WidzewHistoryScreen extends StatefulWidget {
  final List<HistoryStory> stories;
  final bool patriotBadgeUnlocked;
  final VoidCallback onUnlockPatriot;

  const WidzewHistoryScreen({
    super.key,
    required this.stories,
    required this.patriotBadgeUnlocked,
    required this.onUnlockPatriot,
  });

  @override
  State<WidzewHistoryScreen> createState() => _WidzewHistoryScreenState();
}

class _WidzewHistoryScreenState extends State<WidzewHistoryScreen> {
  final _answers = <int, int>{};
  late bool _unlocked;

  @override
  void initState() {
    super.initState();
    _unlocked = widget.patriotBadgeUnlocked;
  }

  List<HistoryQuizQuestion> get _questions => HistoryQuizQuestion.questions();

  void _submitQuiz() {
    final questions = _questions;
    var correct = 0;
    for (var index = 0; index < questions.length; index++) {
      if (_answers[index] == questions[index].correctIndex) correct++;
    }
    final passed = correct == questions.length;
    if (passed && !_unlocked) {
      setState(() => _unlocked = true);
      widget.onUnlockPatriot();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          passed
              ? 'Odznaka „Lokalny Patriota” odblokowana!'
              : 'Wynik: $correct / ${questions.length}. Spróbuj jeszcze raz.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = _questions;
    return Scaffold(
      appBar: AppBar(title: const Text('Śladami historii okolicy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          if (_unlocked)
            const Card(
              child: ListTile(
                leading: Icon(Icons.military_tech_outlined),
                title: Text('Lokalny Patriota'),
                subtitle: Text('Odznaka za quiz o historii okolicy'),
              ),
            ),
          const Text(
            'Ciekawostki i stare kadry: lokalna manufaktura, osada fabryczna, architektura osiedla.',
          ),
          const SizedBox(height: 12),
          for (final story in widget.stories)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 88,
                      width: double.infinity,
                      alignment: Alignment.center,
                      color: Colors.brown.shade100,
                      child: Text(
                        story.photoCaption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      story.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(story.body),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          const Text(
            'Quiz z wiedzy o okolicy',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < questions.length; index++)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(questions[index].prompt),
                    RadioGroup<int>(
                      groupValue: _answers[index],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _answers[index] = value);
                      },
                      child: Column(
                        children: [
                          for (var option = 0;
                              option < questions[index].options.length;
                              option++)
                            RadioListTile<int>(
                              dense: true,
                              title: Text(questions[index].options[option]),
                              value: option,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          FilledButton(
            onPressed: _submitQuiz,
            child: const Text('Sprawdź quiz'),
          ),
        ],
      ),
    );
  }
}
