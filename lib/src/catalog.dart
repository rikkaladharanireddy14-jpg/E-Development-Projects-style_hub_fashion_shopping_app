
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'product.dart';

class CatalogException implements Exception {
  const CatalogException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CatalogRepository {
  CatalogRepository({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  void close() => _client.close();

  static final _base = Uri.parse('https://dummyjson.com/products/category/');

  static const fashionCategories = [
    'tops',
    'mens-shirts',
    'mens-shoes',
    'womens-dresses',
    'womens-shoes',
    'womens-bags',
    'womens-jewellery',
    'sunglasses',
  ];

  Future<List<Product>> fetchProducts() async {
    // Fetch categories independently so a failed category does not
    // prevent products from the remaining categories from being returned.
    final results = await Future.wait(
      fashionCategories.map((category) async {
        try {
          return await _fetchCategory(category);
        } on Exception {
          return <Product>[];
        }
      }),
    );

    final byId = <String, Product>{};

    for (final categoryProducts in results) {
      for (final product in categoryProducts) {
        byId[product.id] = product;
      }
    }

    final products = byId.values.toList();

    if (products.isEmpty) {
      throw const CatalogException(
        'Unable to load fashion products. Please try again later.',
      );
    }

    return products;
  }

  Future<List<Product>> _fetchCategory(String category) async {
    final response = await _client
        .get(_base.resolve(category))
        .timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw CatalogException(
        'Catalog request for $category failed '
        '(${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic> ||
        decoded['products'] is! List) {
      throw FormatException(
        'Catalog response for $category did not include a products list.',
      );
    }

    return (decoded['products'] as List)
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList();
  }
}
