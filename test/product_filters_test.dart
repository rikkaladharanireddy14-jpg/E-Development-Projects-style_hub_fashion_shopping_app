import 'package:flutter_test/flutter_test.dart';
import 'package:style_hub/src/checkout_validation.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/product_filters.dart';

void main() {
  const products = [
    Product(id: '1', name: 'Soft jacket', description: '', category: 'tops', price: 80, imageUrl: ''),
    Product(id: '2', name: 'Linen shirt', description: '', category: 'tops', price: 45, imageUrl: ''),
    Product(id: '3', name: 'Leather tote', description: '', category: 'womens-bags', price: 110, imageUrl: ''),
  ];

  test('search and category filters narrow the catalog together', () {
    expect(filterProducts(products, query: 'linen', category: 'tops').single.id, '2');
    expect(filterProducts(products, category: 'womens-bags').single.name, 'Leather tote');
    expect(filterProducts(products, query: 'coat'), isEmpty);
  });

  test('Style Picks sorts by listed price without inventing attributes', () {
    expect(stylePicks(products).map((product) => product.id), ['2', '1', '3']);
  });

  test('checkout fields reject missing and malformed values', () {
    expect(validateName(''), isNotNull);
    expect(validateName('Mira'), isNull);
    expect(validateEmail('mira-at-example'), isNotNull);
    expect(validateEmail('mira@example.com'), isNull);
    expect(validateAddress('Main'), isNotNull);
    expect(validateAddress('12 Main Street'), isNull);
    expect(validatePostalCode('12A456'), isNotNull);
    expect(validatePostalCode('500001'), isNull);
  });
}
