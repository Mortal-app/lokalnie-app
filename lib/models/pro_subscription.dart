/// Miesięczna subskrypcja Lokalnie PRO (Google Play product ID).
class ProProduct {
  static const id = 'lokalnie_pro_monthly';
  static const fallbackPriceLabel = '19,99 zł / miesiąc';
  static const fallbackTitle = 'Lokalnie PRO — fachowiec';
  static const fallbackDescription =
      'Miesięczny abonament katalogu fachowców: wizytówka, numer telefonu, giełda zleceń i odznaka zaufania.';
  static const periodDays = 31;
}

class ProOffer {
  final String productId;
  final String title;
  final String priceLabel;
  final String description;
  final bool fromStore;
  final bool storeAvailable;

  const ProOffer({
    required this.productId,
    required this.title,
    required this.priceLabel,
    required this.description,
    this.fromStore = false,
    this.storeAvailable = false,
  });

  static const fallback = ProOffer(
    productId: ProProduct.id,
    title: ProProduct.fallbackTitle,
    priceLabel: ProProduct.fallbackPriceLabel,
    description: ProProduct.fallbackDescription,
  );

  bool get usesFallbackPrice => !fromStore;
}

class ProEntitlement {
  final bool isPro;
  final DateTime? expiryAt;
  final String productId;
  final String source;

  const ProEntitlement({
    required this.isPro,
    this.expiryAt,
    this.productId = ProProduct.id,
    this.source = 'local',
  });

  static const inactive = ProEntitlement(isPro: false);

  factory ProEntitlement.fromUserDoc(Map<String, dynamic>? json) {
    if (json == null) return inactive;
    final expiry = DateTime.tryParse(json['proExpiryAt'] as String? ?? '');
    return ProEntitlement(
      isPro: json['isPro'] == true,
      expiryAt: expiry,
      productId: (json['proProductId'] as String?)?.trim().isNotEmpty == true
          ? json['proProductId'] as String
          : ProProduct.id,
      source: 'firestore',
    );
  }

  Map<String, Object?> toUserFields() => {
    'isPro': isPro,
    'proProductId': productId,
    'proExpiryAt': expiryAt?.toIso8601String(),
  };
}

class ProPurchaseResult {
  final bool started;
  final bool granted;
  final String message;
  final ProEntitlement? entitlement;

  const ProPurchaseResult({
    this.started = false,
    this.granted = false,
    required this.message,
    this.entitlement,
  });

  const ProPurchaseResult.started([
    String message = 'Otwieram Google Play…',
  ]) : this(started: true, message: message);

  const ProPurchaseResult.unavailable(String message)
    : this(message: message);

  const ProPurchaseResult.ok(String message, {ProEntitlement? entitlement})
    : this(granted: true, message: message, entitlement: entitlement);
}
