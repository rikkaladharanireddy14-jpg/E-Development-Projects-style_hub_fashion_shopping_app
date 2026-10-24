import 'product.dart';

List<Product> filterProducts(
  List<Product> products, {
  String query = '',
  String category = 'All',
}) {
  final normalized = query.trim().toLowerCase();
  return products.where((product) {
    final matchesQuery =
        '${product.name} ${product.category}'.toLowerCase().contains(normalized);
    return matchesQuery && (category == 'All' || product.category == category);
  }).toList();
}

List<Product> stylePicks(List<Product> products, {int limit = 3}) {
  final sorted = [...products]..sort((a, b) => a.price.compareTo(b.price));
  return sorted.take(limit).toList();
}
