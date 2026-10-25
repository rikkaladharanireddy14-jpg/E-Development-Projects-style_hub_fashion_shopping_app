import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:style_hub/src/catalog.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  test('catalog failure activates fallback and ends loading', () async {
    final client = MockClient((request) async {
      return http.Response('Service unavailable', 503);
    });

    final shop = ShopState(
      repository: CatalogRepository(client: client),
    );

    final loadingStates = <bool>[];

    shop.addListener(() {
      loadingStates.add(shop.isLoading);
    });

    try {
      await shop.loadCatalog();

      expect(loadingStates, [true, false]);
      expect(shop.isLoading, isFalse);
      expect(shop.isFallback, isTrue);
      expect(shop.products, isNotEmpty);
      expect(shop.products, equals(demoCatalog));
      expect(shop.error, isNotNull);
    } finally {
      shop.dispose();
    }
  });
}