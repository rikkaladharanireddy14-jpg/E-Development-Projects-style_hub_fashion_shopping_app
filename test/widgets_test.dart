
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:style_hub/main.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  testWidgets('empty state presents a clear title and next step', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            title: 'Your bag is taking a breather',
            message: 'Explore the edit to find a piece you love.',
          ),
        ),
      ),
    );

    expect(find.text('Your bag is taking a breather'), findsOneWidget);
    expect(
      find.text('Explore the edit to find a piece you love.'),
      findsOneWidget,
    );
  });

  testWidgets('home opens a product through its named route', (
    tester,
  ) async {
    const product = Product(
      id: 'linen-1',
      name: 'Linen jacket',
      description: 'A relaxed summer layer.',
      category: 'tops',
      price: 59.0,
      imageUrl: '',
    );

    final shop = ShopState()..products = [product];

    await tester.pumpWidget(
      ChangeNotifierProvider<ShopState>.value(
        value: shop,
        child: const StyleHubApp(),
      ),
    );

    await tester.pump();

    // Confirm that the home screen starts successfully.
    expect(find.byType(StyleHubApp), findsOneWidget);

    // The product grid may be lazy-built, so scroll to the product.
    final productFinder = find.text('Linen jacket');

    if (productFinder.evaluate().isEmpty) {
      final scrollableFinder = find.descendant(
        of: find.byType(Scrollable),
        matching: find.byType(Scrollable),
      );

      // Do not attempt to scroll if no scrollable is available.
      if (scrollableFinder.evaluate().isNotEmpty) {
        await tester.drag(
          find.byType(Scrollable).first,
          const Offset(0, -500),
        );
        await tester.pumpAndSettle();
      }
    }

    expect(productFinder, findsWidgets);

    await tester.ensureVisible(productFinder.first);
    await tester.tap(productFinder.first);
    await tester.pumpAndSettle();

    expect(find.text('THE DETAILS'), findsOneWidget);
    expect(find.text('ADD TO BAG'), findsOneWidget);
  });
}
