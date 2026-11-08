class WastePoint {
  final String name;
  final String kind;
  final String address;
  final String hours;
  final String details;

  const WastePoint({
    required this.name,
    required this.kind,
    required this.address,
    required this.hours,
    required this.details,
  });

  static const points = [
    WastePoint(
      name: 'PSZOK Widzew – odpady komunalne',
      kind: 'PSZOK',
      address: 'Rejon Widzew / Olechów (punkt miasta Łodzi)',
      hours: 'Pn–Pt 10:00–18:00, Sb 8:00–14:00',
      details:
          'Elektrośmieci, farby, opony (limit), gruz w workach. Dowóz we własnym zakresie.',
    ),
    WastePoint(
      name: 'Kontener elektro – Galeria Widzewska',
      kind: 'Elektrośmieci',
      address: 'Aleja Piłsudskiego, rejon Widzew Wschód',
      hours: 'W godzinach otwarcia galerii',
      details: 'Mały RTV, żarówki, baterie, telefony. Nie zostawiaj AGD obok.',
    ),
    WastePoint(
      name: 'Zbiórka elektro – Olechów',
      kind: 'Elektrośmieci',
      address: 'Osiedle Olechów, przy pawilonach handlowych',
      hours: 'Soboty parzyste 9:00–13:00',
      details: 'Mobilny punkt na drobny sprzęt AGD i kable.',
    ),
    WastePoint(
      name: 'Gabaryty – Widzew Wschód / Janów',
      kind: 'Wielkogabarytowe',
      address: 'Przy wiacie śmietnikowej Twojej klatki',
      hours: 'Ostatnia sobota miesiąca, wystawianie od 6:00',
      details:
          'Meble, materace, duże AGD. Nie wcześniej niż w przeddzień odbioru.',
    ),
    WastePoint(
      name: 'Gabaryty – Olechów / Stary Widzew',
      kind: 'Wielkogabarytowe',
      address: 'Punkty zbiórki oznaczone przez SM',
      hours: 'Pierwsza sobota miesiąca',
      details: 'Harmonogram MPO: sprawdź tablicę klatki i Przewodnik Mieszkańca.',
    ),
  ];
}
