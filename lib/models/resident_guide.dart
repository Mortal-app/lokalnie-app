class ResidentGuideArticle {
  final String title;
  final String summary;
  final String body;
  final List<String> keywords;

  const ResidentGuideArticle({
    required this.title,
    required this.summary,
    required this.body,
    this.keywords = const [],
  });

  bool matches(String query) {
    if (query.trim().isEmpty) return true;
    final haystack = '$title $summary $body ${keywords.join(' ')}'
        .toLowerCase();
    return query
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .every(haystack.contains);
  }
}

class ResidentGuide {
  static const articles = [
    ResidentGuideArticle(
      title: 'Harmonogram wywozu śmieci wg osiedli',
      summary: 'Terminy worków zmieszanych, segregacji i gabarytów.',
      keywords: ['śmieci', 'odpady', 'harmonogram', 'wywóz'],
      body:
          'Widzew Wschód i Stary Widzew: odpady zmieszane we wtorki i piątki, '
          'segregacja (papier, plastik, szkło) w środy.\n'
          'Olechów: zmieszane w poniedziałki i czwartki, bioodpady w środy.\n'
          'Janów i Księży Młyn: zmieszane we wtorki i piątki, gabaryty w ostatnią '
          'sobotę miesiąca przy punktach zbiórki osiedlowej.\n'
          'Dokładny kalendarz warto potwierdzić na tablicy spółdzielni i w '
          'aplikacji MPO Łódź.',
    ),
    ResidentGuideArticle(
      title: 'Jak zgłosić usterkę w spółdzielni',
      summary: 'Krok po kroku: awaria klatki, windy, c.o. i zalanie.',
      keywords: ['usterka', 'spółdzielnia', 'awaria', 'administracja'],
      body:
          '1. Zanotuj adres klatki, numer lokalu i godzinę zauważenia usterki.\n'
          '2. Zgłoś sprawę do administracji SM Widzew lub SM Chojny '
          '(numery są w Niezbędniku Widzewa).\n'
          '3. Przy zalaniu lub braku ogrzewania poproś o numer zgłoszenia.\n'
          '4. W nocy i w święta korzystaj z pogotowia technicznego spółdzielni.\n'
          '5. Jeśli usterka zagraża bezpieczeństwu, zgłoś ją też na tablicy osiedla.',
    ),
    ResidentGuideArticle(
      title: 'Gdzie wyrzucić elektrośmieci na Widzewie',
      summary: 'PSZOK, zbiórki osiedlowe i sklepy RTV.',
      keywords: ['elektrośmieci', 'pszok', 'elektro', 'odpady'],
      body:
          'Mały sprzęt (ładowarki, żarówki LED, telefony) oddasz w sklepie RTV '
          'przy zakupie nowego urządzenia oraz podczas zbiórek w galeriach.\n'
          'Większy AGD (pralki, lodówki) – Punkt Selektywnego Zbierania Odpadów '
          'Komunalnych (PSZOK) obsługujący Widzew; dowóz we własnym zakresie '
          'albo zgłoszenie odbioru gabarytów w spółdzielni.\n'
          'Nie zostawiaj elektroodpadów przy śmietnikach – to częsty mandat '
          'i zagrożenie dla zwierząt.',
    ),
    ResidentGuideArticle(
      title: 'Parking, strefa i zgłoszenia na osiedlu',
      summary: 'Miejsca dla mieszkańców, nielegalne parkowanie, Straż Miejska.',
      keywords: ['parking', 'straż', 'ulica'],
      body:
          'Nieprawidłowe parkowanie na chodniku lub trawniku zgłoś Straży '
          'Miejskiej – rejon Widzew (986).\n'
          'Miejsca przypisane do spółdzielni reguluje regulamin SM; wniosek o '
          'miejsce postojowe składasz w administracji osiedla.\n'
          'Utrudnienia drogowe warto też opisać na tablicy Lokalnie Widzew, '
          'żeby sąsiedzi znali objazd.',
    ),
  ];
}
