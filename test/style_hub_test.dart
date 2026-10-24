import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:style_hub/src/catalog.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  group('Product model', () {
    test('parses the product API shape and uses image fallback', () {
      final product = Product.fromJson({
        'id': 7,
        'title': 'Soft jacket',
        'description': 'A light layer',
        'category': 'mens-shirts',
        'price': 48.5,
        'images': ['https://example.test/jacket.jpg'],
      });
      expect(product.id, '7');
      expect(product.name, 'Soft jacket');
      expect(product.price, 48.5);
      expect(product.imageUrl, 'https://example.test/jacket.jpg');
    });
  });

  group('CatalogRepository', () {
    test('parses a fashion category response', () async {
      final client = MockClient((request) async => http.Response(
            jsonEncode({
              'products': [
                {
                  'id': 1,
                  'title': 'Cotton shirt',
                  'description': 'Relaxed fit',
                  'category': 'mens-shirts',
                  'price': 30,
                  'thumbnail': 'https://example.test/shirt.jpg',
                }
              ],
              'total': 1,
            }),
            200,
          ));
      final products = await CatalogRepository(client: client).fetchProducts();
      expect(products, hasLength(1));
      expect(products.single.category, 'mens-shirts');
    });

    test('reports an HTTP failure for fallback handling', () async {
      final client = MockClient((request) async => http.Response('unavailable', 503));
      expect(CatalogRepository(client: client).fetchProducts(), throwsA(isA<CatalogException>()));
    });
  });

  group('ShopState', () {
    late ShopState shop;
    const product = Product(
      id: 'jacket',
      name: 'Soft jacket',
      description: 'A jacket',
      category: 'tops',
      price: 12.50,
      imageUrl: '',
    );

    setUp(() => shop = ShopState(repository: _FakeCatalog([product])));

    test('updates shared cart quantities and totals', () {
      shop.addToCart(product);
      shop.addToCart(product);
      expect(shop.itemCount, 2);
      expect(shop.total, 25);
      shop.updateQuantity(product.id, 3);
      expect(shop.total, 37.5);
      shop.updateQuantity(product.id, 0);
      expect(shop.items, isEmpty);
    });

    test('keeps wishlist add and remove in sync', () {
      shop.toggleWishlist(product);
      expect(shop.isWishlisted(product.id), isTrue);
      expect(shop.wishlist, [product]);
      shop.toggleWishlist(product);
      expect(shop.wishlist, isEmpty);
    });

    test('uses clearly identified demo data after an API failure', () async {
      final offline = ShopState(repository: _FailingCatalog());
      await offline.loadCatalog();
      expect(offline.isFallback, isTrue);
      expect(offline.error, isNotNull);
      expect(offline.products, isNotEmpty);
      expect(offline.products.every((item) => item.isDemo), isTrue);
    });
  });
}

class _FakeCatalog extends CatalogRepository {
  _FakeCatalog(this.fixture);
  final List<Product> fixture;
  @override
  Future<List<Product>> fetchProducts() async => fixture;
}

class _FailingCatalog extends CatalogRepository {
  @override
  Future<List<Product>> fetchProducts() async => throw const CatalogException('offline');
}
