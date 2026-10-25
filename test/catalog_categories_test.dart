import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:style_hub/src/catalog.dart';

void main() {
  test('catalog requests every configured fashion category', () async {
    final requestedCategories = <String>[];

    final client = MockClient((request) async {
      final category = request.url.pathSegments.last;
      requestedCategories.add(category);

      return http.Response(
        jsonEncode({
          'products': [
            {
              'id': 100,
              'title': 'Sample Fashion Product',
              'description': 'A product for catalog testing.',
              'category': category,
              'price': 25.0,
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
      await repository.fetchProducts();

      expect(
        requestedCategories.toSet(),
        equals(CatalogRepository.fashionCategories.toSet()),
      );
      expect(
        requestedCategories,
        hasLength(CatalogRepository.fashionCategories.length),
      );
    } finally {
      repository.close();
    }
  });
}