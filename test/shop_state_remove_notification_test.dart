import 'package:flutter_test/flutter_test.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  test('removing a cart item notifies listeners', () {
    final shop = ShopState();

    const product = Product(
      id: 'remove-notification-shirt',
      name: 'Classic Shirt',
      description: 'A comfortable shirt',
      category: 'tops',
      price: 25.0,
      imageUrl: '',
    );

    try {
      shop.addToCart(product);

      var notifications = 0;
      shop.addListener(() {
        notifications++;
      });

      shop.removeFromCart(product.id);

      expect(notifications, 1);
      expect(shop.items, isEmpty);
      expect(shop.itemCount, 0);
      expect(shop.total, 0.0);
    } finally {
      shop.dispose();
    }
  });
}