void main() {
  const productName = 'Everyday overshirt';
  const price = 32.90;
  const quantity = 2;
  final cart = <String, int>{productName: quantity};

  String formatPrice(double amount) => amount.toStringAsFixed(2);
  double lineTotal(double unitPrice, int count) => unitPrice * count;

  final subtotal = cart.entries.fold<double>(
    0,
    (sum, entry) => sum + lineTotal(price, entry.value),
  );
  final categories = <String>['tops', 'accessories', 'footwear'];
  final isClothing = categories.first == 'tops';
  final visibleItems = <String>[];

  if (quantity > 0 && isClothing) {
    for (var index = 0; index < quantity; index++) {
      visibleItems.add('${index + 1}. $productName');
    }
  }

  print('Product: $productName');
  print('Unit price: ${formatPrice(price)}');
  print('Quantity: $quantity');
  print('Subtotal: ${formatPrice(subtotal)}');
  print('Visible cart rows: ${visibleItems.length}');
}
