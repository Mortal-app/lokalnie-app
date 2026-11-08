class StaircasePayment {
  final String payer;
  final int amount;

  const StaircasePayment({required this.payer, required this.amount});

  Map<String, Object?> toJson() => {'payer': payer, 'amount': amount};

  factory StaircasePayment.fromJson(Map<String, dynamic> json) {
    return StaircasePayment(
      payer: json['payer'] as String? ?? 'Sąsiad',
      amount: json['amount'] as int? ?? 0,
    );
  }
}

class StaircaseFund {
  final String id;
  final String title;
  final int goal;
  final List<StaircasePayment> payments;

  const StaircaseFund({
    required this.id,
    required this.title,
    required this.goal,
    this.payments = const [],
  });

  int get collected =>
      payments.fold<int>(0, (sum, item) => sum + item.amount);

  StaircaseFund copyWith({List<StaircasePayment>? payments}) {
    return StaircaseFund(
      id: id,
      title: title,
      goal: goal,
      payments: payments ?? this.payments,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'goal': goal,
    'payments': payments.map((item) => item.toJson()).toList(),
  };

  factory StaircaseFund.fromJson(Map<String, dynamic> json) {
    return StaircaseFund(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      goal: json['goal'] as int? ?? 0,
      payments: (json['payments'] as List<dynamic>?)
              ?.map(
                (item) => StaircasePayment.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }

  static List<StaircaseFund> seeded() => const [
    StaircaseFund(
      id: 'fund-flowers',
      title: 'Kwiaty do ogródka klatkowego',
      goal: 120,
      payments: [
        StaircasePayment(payer: 'Pani Maria', amount: 40),
        StaircasePayment(payer: 'Sąsiad z 3', amount: 30),
      ],
    ),
    StaircaseFund(
      id: 'fund-bulbs',
      title: 'Wymiana żarówek na klatce',
      goal: 80,
      payments: [
        StaircasePayment(payer: 'Gospodarz', amount: 80),
      ],
    ),
    StaircaseFund(
      id: 'fund-clean',
      title: 'Dodatkowe sprzątanie klatki',
      goal: 200,
      payments: [
        StaircasePayment(payer: 'Klatka II', amount: 50),
      ],
    ),
  ];
}
