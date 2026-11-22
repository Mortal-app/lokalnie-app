import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../models/pro_subscription.dart';
import '../utils/flutter_runtime.dart';
import '../utils/privacy_log.dart';

/// Google Play Billing dla `lokalnie_pro_monthly` — bez płatnego backendu.
class ProSubscriptionService {
  ProSubscriptionService({this._store});

  static final instance = ProSubscriptionService();

  final InAppPurchase? _store;
  final _entitlements = StreamController<ProEntitlement>.broadcast();
  StreamSubscription<List<PurchaseDetails>>? _purchasesSub;
  ProductDetails? _cachedProduct;
  var _listening = false;

  Stream<ProEntitlement> get entitlements => _entitlements.stream;

  bool get _skipStore {
    if (kIsWeb) return true;
    try {
      return isFlutterWidgetTest;
    } catch (_) {
      return true;
    }
  }

  InAppPurchase get _iap => _store ?? InAppPurchase.instance;

  void attach() {
    if (_skipStore || _listening) return;
    _listening = true;
    try {
      _purchasesSub = _iap.purchaseStream.listen(
        _onPurchases,
        onError: (Object error) {
          PrivacyLog.debug('IAP purchaseStream FAILED', error);
        },
      );
    } catch (error) {
      PrivacyLog.debug('IAP listen FAILED', error);
      _listening = false;
    }
  }

  Future<void> detach() async {
    _listening = false;
    await _purchasesSub?.cancel();
    _purchasesSub = null;
  }

  Future<ProOffer> loadOffer() async {
    if (_skipStore) return ProOffer.fallback;
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        return ProOffer.fallback;
      }
      final response = await _iap.queryProductDetails({ProProduct.id});
      if (response.productDetails.isEmpty) {
        PrivacyLog.debug(
          'IAP brak oferty ${ProProduct.id} notFound=${response.notFoundIDs}',
        );
        return ProOffer.fallback;
      }
      final product = response.productDetails.first;
      _cachedProduct = product;
      final price = product.price.trim().isEmpty
          ? ProProduct.fallbackPriceLabel
          : product.price;
      return ProOffer(
        productId: product.id,
        title: product.title.trim().isEmpty
            ? ProProduct.fallbackTitle
            : product.title,
        priceLabel: price.contains('/') ? price : '$price / miesiąc',
        description: product.description.trim().isEmpty
            ? ProProduct.fallbackDescription
            : product.description,
        fromStore: true,
        storeAvailable: true,
      );
    } catch (error) {
      PrivacyLog.debug('IAP query FAILED', error);
      return ProOffer.fallback;
    }
  }

  Future<ProPurchaseResult> buy() async {
    if (_skipStore) {
      return const ProPurchaseResult.unavailable(
        'Sklep Google Play jest niedostępny w tym środowisku.',
      );
    }
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        return const ProPurchaseResult.unavailable(
          'Google Play Billing jest niedostępny na tym urządzeniu.',
        );
      }
      var product = _cachedProduct;
      if (product == null) {
        await loadOffer();
        product = _cachedProduct;
      }
      if (product == null) {
        return const ProPurchaseResult.unavailable(
          'Oferta lokalnie_pro_monthly nie jest jeszcze w Google Play Console. '
          'Cena na ekranie jest orientacyjna — zakup zadziała po publikacji subskrypcji.',
        );
      }
      final started = await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      if (!started) {
        return const ProPurchaseResult.unavailable(
          'Nie udało się otworzyć okna zakupu. Spróbuj ponownie.',
        );
      }
      return const ProPurchaseResult.started();
    } catch (error) {
      PrivacyLog.debug('IAP buy FAILED', error);
      return const ProPurchaseResult.unavailable(
        'Nie udało się rozpocząć zakupu w Google Play. Spróbuj później.',
      );
    }
  }

  Future<ProPurchaseResult> restore() async {
    if (_skipStore) {
      return const ProPurchaseResult.unavailable(
        'Przywracanie zakupów wymaga Google Play na urządzeniu z kontem sklepu.',
      );
    }
    try {
      final available = await _iap.isAvailable();
      if (!available) {
        return const ProPurchaseResult.unavailable(
          'Google Play Billing jest niedostępny — nie można przywrócić zakupów.',
        );
      }
      await _iap.restorePurchases();
      return const ProPurchaseResult(
        started: true,
        message: 'Szukam wcześniejszych zakupów Lokalnie PRO…',
      );
    } catch (error) {
      PrivacyLog.debug('IAP restore FAILED', error);
      return const ProPurchaseResult.unavailable(
        'Nie udało się przywrócić zakupów. Sprawdź konto Google Play.',
      );
    }
  }

  void _onPurchases(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      unawaited(_deliver(purchase));
    }
  }

  Future<void> _deliver(PurchaseDetails purchase) async {
    final owned =
        purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored;
    if (purchase.status == PurchaseStatus.error) {
      PrivacyLog.debug(
        'IAP error ${purchase.error?.code} ${purchase.error?.message}',
      );
    }
    if (owned &&
        (purchase.productID == ProProduct.id || purchase.productID.isNotEmpty)) {
      final entitlement = ProEntitlement(
        isPro: true,
        expiryAt: DateTime.now().add(const Duration(days: ProProduct.periodDays)),
        productId: purchase.productID.isEmpty ? ProProduct.id : purchase.productID,
        source: purchase.status == PurchaseStatus.restored ? 'restore' : 'purchase',
      );
      if (!_entitlements.isClosed) {
        _entitlements.add(entitlement);
      }
    }
    if (purchase.pendingCompletePurchase) {
      try {
        await _iap.completePurchase(purchase);
      } catch (error) {
        PrivacyLog.debug('IAP completePurchase FAILED', error);
      }
    }
  }

  @visibleForTesting
  void emitEntitlement(ProEntitlement entitlement) {
    if (!_entitlements.isClosed) {
      _entitlements.add(entitlement);
    }
  }
}
