import 'package:flutter_test/flutter_test.dart';
import 'package:style_hub/src/product.dart';

void main() {
  group('Product.fromJson', () {
    test('parses product fields from API JSON', () {
      final product = Product.fromJson({
        'id': 707,
        'title': 'Everyday Hoodie',
        'description': 'A comfortable hoodie for everyday wear.',
        'category': 'mens-shirts',
        'price': 49.5,
        'thumbnail': 'https://example.com/hoodie.png',
        'images': ['https://example.com/hoodie.png'],
      });

      expect(product.id, '707');
      expect(product.name, 'Everyday Hoodie');
      expect(
        product.description,
        'A comfortable hoodie for everyday wear.',
      );
      expect(product.category, 'mens-shirts');
      expect(product.price, 49.5);
    });

    test('converts a numeric API product ID to a string', () {
      final product = Product.fromJson({
        'id': 808,
        'title': 'Summer Top',
        'description': 'A lightweight summer top.',
        'category': 'tops',
        'price': 19.99,
        'thumbnail': '',
        'images': [],
      });

      expect(product.id, isA<String>());
      expect(product.id, '808');
    });
  });
}