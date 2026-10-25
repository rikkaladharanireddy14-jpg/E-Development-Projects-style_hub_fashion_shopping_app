import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:style_hub/src/catalog.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  late ShopState shop;
  late Product product;

  setUp(() {
    shop = ShopState();
    product = const Product(
      id: 'notification-shirt',
      name: 'Classic Shirt',
      description: 'A comfortable everyday shirt',
      category: 'tops',
      price: 25.0,
      imageUrl: '',
    );
  });

  tearDown(() {
    shop.dispose();
  });

  test('adding to cart notifies listeners', () {
    var notifications = 0;
    shop.addListener(() => notifications++);

    shop.addToCart(product);

    expect(notifications, 1);
    expect(shop.itemCount, 1);
  });

  test('wishlist changes notify listeners', () {
    var notifications = 0;
    shop.addListener(() => notifications++);

    shop.toggleWishlist(product);
    expect(notifications, 1);
    expect(shop.isWishlisted(product.id), isTrue);

    shop.toggleWishlist(product);
    expect(notifications, 2);
    expect(shop.isWishlisted(product.id), isFalse);
  });

  test('clearing the cart notifies listeners', () {
    shop.addToCart(product);

    var notifications = 0;
    shop.addListener(() => notifications++);

    shop.clearCart();

    expect(notifications, 1);
    expect(shop.items, isEmpty);
    expect(shop.total, 0.0);
  });

  test('catalog loading notifies listeners when loading starts and ends',
      () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'products': [
            {
              'id': 505,
              'title': 'Remote Shirt',
              'description': 'A shirt from the sample catalog',
              'category': 'tops',
              'price': 35.0,
              'thumbnail': '',
              'images': [],
            },
          ],
        }),
        200,
      );
    });

    final testShop = ShopState(
      repository: CatalogRepository(client: client),
    );
    final loadingStates = <bool>[];

    testShop.addListener(() {
      loadingStates.add(testShop.isLoading);
    });

    try {
      await testShop.loadCatalog();

      expect(loadingStates, [true, false]);
      expect(testShop.isLoading, isFalse);
      expect(testShop.products, hasLength(1));
      expect(testShop.products.single.name, 'Remote Shirt');
      expect(testShop.isFallback, isFalse);
    } finally {
      testShop.dispose();
    }
  });
}