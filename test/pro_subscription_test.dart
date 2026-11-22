import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalnie_widzew/models/pro_subscription.dart';
import 'package:lokalnie_widzew/models/tradesperson_marketplace.dart';
import 'package:lokalnie_widzew/screens/tradesperson_subscription_screen.dart';
import 'package:lokalnie_widzew/services/pro_subscription_service.dart';

void main() {
  test('Play product id and fallback price stay stable', () {
    expect(ProProduct.id, 'lokalnie_pro_monthly');
    expect(ProOffer.fallback.productId, ProProduct.id);
    expect(ProOffer.fallback.priceLabel, contains('19,99'));
    expect(ProOffer.fallback.fromStore, isFalse);
    expect(ProOffer.fallback.usesFallbackPrice, isTrue);
  });

  test('user document maps isPro entitlement both ways', () {
    final granted = ProEntitlement(
      isPro: true,
      expiryAt: DateTime(2026, 12, 22),
      productId: ProProduct.id,
    );
    final fields = granted.toUserFields();
    expect(fields['isPro'], isTrue);
    expect(fields['proProductId'], ProProduct.id);
    expect(fields['proExpiryAt'], '2026-12-22T00:00:00.000');

    final restored = ProEntitlement.fromUserDoc({
      'isPro': true,
      'proProductId': ProProduct.id,
      'proExpiryAt': '2026-12-22T00:00:00.000',
    });
    expect(restored.isPro, isTrue);
    expect(restored.productId, ProProduct.id);
    expect(restored.expiryAt, DateTime(2026, 12, 22));
    expect(ProEntitlement.fromUserDoc(null).isPro, isFalse);
    expect(ProEntitlement.fromUserDoc({'isPro': false}).isPro, isFalse);
  });

  test('account copyWith toggles Pro without dropping the card', () {
    var account = const TradespersonAccount(
      isTradesperson: true,
      card: TradespersonCard(displayName: 'Jan', trade: 'Hydraulika'),
    );
    expect(account.isProActive, isFalse);
    account = account.copyWith(
      isPro: true,
      subscriptionExpiryDate: DateTime.now().add(const Duration(days: 20)),
    );
    expect(account.isProActive, isTrue);
    expect(account.subscriptionStatusLabel, 'Aktywny');
    account = account.copyWith(clearSubscription: true);
    expect(account.isPro, isFalse);
    expect(account.isProActive, isFalse);
    expect(account.card.displayName, 'Jan');
  });

  testWidgets('loadOffer never talks to Play during widget tests', (
    tester,
  ) async {
    final offer = await ProSubscriptionService.instance.loadOffer();
    expect(offer.productId, ProProduct.id);
    expect(offer.fromStore, isFalse);
    expect(offer.priceLabel, ProProduct.fallbackPriceLabel);

    final buy = await ProSubscriptionService.instance.buy();
    expect(buy.started, isFalse);
    expect(buy.granted, isFalse);
    expect(buy.message, contains('Google Play'));

    final restore = await ProSubscriptionService.instance.restore();
    expect(restore.granted, isFalse);
    expect(restore.message, contains('Google Play'));
  });

  testWidgets('purchase screen renders benefits, price, buy and restore', (
    tester,
  ) async {
    var restored = false;
    var buying = false;
    await tester.pumpWidget(
      MaterialApp(
        home: TradespersonSubscriptionScreen(
          account: const TradespersonAccount(isTradesperson: true),
          jobRequests: const [],
          onRenew: () => buying = true,
          onRestore: () => restored = true,
          onListingPublishedChanged: (_) {},
          offer: ProOffer.fallback,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Abonament Fachowca'), findsOneWidget);
    expect(find.text('Status: nieaktywne'), findsOneWidget);
    expect(find.byKey(const ValueKey('pro-price-label')), findsOneWidget);
    expect(find.text(ProProduct.fallbackPriceLabel), findsOneWidget);
    expect(find.textContaining('lokalnie_pro_monthly'), findsOneWidget);
    expect(find.text('Aktywuj abonament PRO'), findsOneWidget);
    expect(find.text('Przywróć zakupy'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('activate-pro-subscription')));
    await tester.pump();
    expect(buying, isTrue);

    await tester.tap(find.byKey(const ValueKey('restore-pro-purchases')));
    await tester.pump();
    expect(restored, isTrue);

    await tester.scrollUntilVisible(
      find.text('Wizytówka w katalogu fachowców okolicy'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Wizytówka w katalogu fachowców okolicy'), findsOneWidget);
  });

  testWidgets('active account shows status and extend action', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TradespersonSubscriptionScreen(
          account: TradespersonAccount(
            isTradesperson: true,
            isPro: true,
            subscriptionExpiryDate: DateTime.now().add(const Duration(days: 12)),
          ),
          jobRequests: const [],
          onRenew: () {},
          onListingPublishedChanged: (_) {},
          offer: ProOffer.fallback,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Status: aktywne'), findsOneWidget);
    expect(find.text('Aktywny'), findsWidgets);
    expect(find.text('Przedłuż subskrypcję'), findsOneWidget);
    expect(find.text('Przywróć zakupy'), findsOneWidget);
  });
}
