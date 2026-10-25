import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:style_hub/src/catalog.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  test('catalog recovers when a later API request succeeds', () async {
    var requestCount = 0;

    final client = MockClient((request) async {
      requestCount++;

      if (requestCount <= CatalogRepository.fashionCategories.length) {
        return http.Response('Service unavailable', 503);
      }

      return http.Response(
        jsonEncode({
          'products': [
            {
              'id': 1001,
              'title': 'Recovery Shirt',
              'description': 'A shirt loaded after a failed request.',
              'category': 'tops',
              'price': 29.0,
              'thumbnail': '',
              'images': [],
            },
          ],
        }),
        200,
      );
    });

    final shop = ShopState(
      repository: CatalogRepository(client: client),
    );

    try {
      // First load: every category request fails.
      await shop.loadCatalog();

      expect(shop.isFallback, isTrue);
      expect(shop.products, isNotEmpty);
      expect(shop.error, isNotNull);
      expect(shop.isLoading, isFalse);

      // Second load: requests succeed.
      await shop.loadCatalog();

      expect(shop.isFallback, isFalse);
      expect(shop.error, isNull);
      expect(shop.isLoading, isFalse);
      expect(shop.products, hasLength(1));
      expect(shop.products.single.name, 'Recovery Shirt');
    } finally {
      shop.dispose();
    }
  });
}