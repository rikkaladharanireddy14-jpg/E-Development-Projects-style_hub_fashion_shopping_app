import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:style_hub/src/catalog.dart';

void main() {
  test('catalog loads products from a successful category response', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'products': [
            {
              'id': 101,
              'title': 'Classic Shirt',
              'description': 'A comfortable everyday shirt.',
              'category': 'mens-shirts',
              'price': 29.99,
              'thumbnail': '',
              'images': [],
            },
          ],
        }),
        200,
      );
    });

    final repository = CatalogRepository(client: client);

    try {
      final products = await repository.fetchProducts();

      expect(products, isNotEmpty);
      expect(products.any((product) => product.name == 'Classic Shirt'), isTrue);
    } finally {
      repository.close();
    }
  });

  test('catalog reports an error when all category requests fail', () async {
    final client = MockClient((request) async {
      return http.Response('Server error', 500);
    });

    final repository = CatalogRepository(client: client);

    try {
      await expectLater(
        repository.fetchProducts(),
        throwsA(isA<CatalogException>()),
      );
    } finally {
      repository.close();
    }
  });
}