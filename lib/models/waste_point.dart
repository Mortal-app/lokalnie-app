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
      name: 'PSZOK okolica – odpady komunalne',
      kind: 'PSZOK',
      address: 'Rejon okolica / okolica (punkt miasta Łodzi)',
      hours: 'Pn–Pt 10:00–18:00, Sb 8:00–14:00',
      details:
          'Elektrośmieci, farby, opony (limit), gruz w workach. Dowóz we własnym zakresie.',
    ),
    WastePoint(
      name: 'Kontener elektro – Galeria osiedlowa',
      kind: 'Elektrośmieci',
      address: 'Aleja Główna, rejon Wschód',
      hours: 'W godzinach otwarcia galerii',
      details: 'Mały RTV, żarówki, baterie, telefony. Nie zostawiaj AGD obok.',
    ),
    WastePoint(
      name: 'Zbiórka elektro – okolica',
      kind: 'Elektrośmieci',
      address: 'Osiedle okolica, przy pawilonach handlowych',
      hours: 'Soboty parzyste 9:00–13:00',
      details: 'Mobilny punkt na drobny sprzęt AGD i kable.',
    ),
    WastePoint(
      name: 'Gabaryty – osiedle wschodnie / okolica',
      kind: 'Wielkogabarytowe',
      address: 'Przy wiacie śmietnikowej Twojej klatki',
      hours: 'Ostatnia sobota miesiąca, wystawianie od 6:00',
      details:
          'Meble, materace, duże AGD. Nie wcześniej niż w przeddzień odbioru.',
    ),
    WastePoint(
      name: 'Gabaryty – okolica / stare osiedle',
      kind: 'Wielkogabarytowe',
      address: 'Punkty zbiórki oznaczone przez SM',
      hours: 'Pierwsza sobota miesiąca',
      details: 'Harmonogram MPO: sprawdź tablicę klatki i Przewodnik Mieszkańca.',
    ),
  ];
}
