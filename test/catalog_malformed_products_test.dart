import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:style_hub/src/catalog.dart';

void main() {
  test('catalog ignores malformed entries and keeps valid products',
      () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'products': [
            'invalid product entry',
            null,
            {
              'id': 909,
              'title': 'Everyday Hoodie',
              'description': 'A comfortable everyday hoodie.',
              'category': 'tops',
              'price': 39.99,
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

      expect(products, hasLength(1));
      expect(products.single.id, '909');
      expect(products.single.name, 'Everyday Hoodie');
    } finally {
      repository.close();
    }
  });
}