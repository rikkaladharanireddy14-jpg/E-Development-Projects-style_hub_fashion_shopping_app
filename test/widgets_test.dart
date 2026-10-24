import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:style_hub/main.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  testWidgets('empty state presents a clear title and next step', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: EmptyState(
          title: 'Your bag is taking a breather',
          message: 'Explore the edit to find a piece you love.',
        ),
      ),
    ));
    expect(find.text('Your bag is taking a breather'), findsOneWidget);
    expect(find.text('Explore the edit to find a piece you love.'), findsOneWidget);
  });

  testWidgets('home opens a product through its named route', (tester) async {
    const product = Product(
      id: 'linen-1',
      name: 'Linen jacket',
      description: 'A relaxed summer layer.',
      category: 'tops',
      price: 59.0,
      imageUrl: '',
    );
    final shop = ShopState()..products = [product];
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: shop,
      child: const StyleHubApp(),
    ));
    await tester.pump();
    await tester.tap(find.text('Linen jacket').first);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('THE DETAILS'), findsOneWidget);
    expect(find.text('ADD TO BAG'), findsOneWidget);
  });
}
