import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:style_hub/src/catalog.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  test('failed API requests activate the local demo catalog', () async {
    final client = MockClient((request) async {
      return http.Response('Server unavailable', 500);
    });

    final shop = ShopState(
      repository: CatalogRepository(client: client),
    );

    try {
      await shop.loadCatalog();

      expect(shop.isFallback, isTrue);
      expect(shop.products, isNotEmpty);
      expect(shop.products, equals(demoCatalog));
      expect(shop.error, isNotNull);
      expect(shop.isLoading, isFalse);
    } finally {
      shop.dispose();
    }
  });

  test(
    'successful API requests load remote products without fallback',
    () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'products': [
              {
                'id': 303,
                'title': 'Remote Shirt',
                'description': 'A shirt loaded from the sample API.',
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

      final shop = ShopState(
        repository: CatalogRepository(client: client),
      );

      try {
        await shop.loadCatalog();

        expect(shop.isFallback, isFalse);
        expect(shop.products, hasLength(1));
        expect(shop.products.single.name, 'Remote Shirt');
        expect(shop.error, isNull);
        expect(shop.isLoading, isFalse);
      } finally {
        shop.dispose();
      }
    },
  );
}