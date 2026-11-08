class BieszczadyTrip {
  final String id;
  final String title;
  final String whenText;
  final String meetingPoint;
  final String seats;
  final String luggage;
  final String authorName;

  const BieszczadyTrip({
    required this.id,
    required this.title,
    required this.whenText,
    required this.meetingPoint,
    required this.seats,
    required this.luggage,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'whenText': whenText,
    'meetingPoint': meetingPoint,
    'seats': seats,
    'luggage': luggage,
    'authorName': authorName,
  };

  factory BieszczadyTrip.fromJson(Map<String, dynamic> json) {
    return BieszczadyTrip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      meetingPoint: json['meetingPoint'] as String? ?? '',
      seats: json['seats'] as String? ?? '',
      luggage: json['luggage'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<BieszczadyTrip> seeded() => const [
    BieszczadyTrip(
      id: 'bz-sol',
      title: 'Bieszczady i Solina — weekend',
      whenText: 'Piątek 16:00',
      meetingPoint: 'Pętla Widzew Wschód',
      seats: '3 miejsca',
      luggage: 'Bagażnik na 4 plecaki, namiot na dachu',
      authorName: 'Tomek',
    ),
    BieszczadyTrip(
      id: 'bz-pol',
      title: 'Połoniny — daleka wyprawa',
      whenText: 'Sobota 4:30',
      meetingPoint: 'Olechów, pawilon',
      seats: '2 miejsca',
      luggage: 'Koordynacja załadunku — jeden duży bagażnik',
      authorName: 'Basia',
    ),
  ];
}
