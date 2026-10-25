import 'package:flutter_test/flutter_test.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  late ShopState shop;
  late Product product;

  setUp(() {
    shop = ShopState();
    product = const Product(
      id: 'test-shirt',
      name: 'Classic Shirt',
      description: 'A comfortable shirt',
      category: 'tops',
      price: 25.0,
      imageUrl: '',
    );
  });

  tearDown(() {
    shop.dispose();
  });

  test('adding a product updates cart quantity and total', () {
    shop.addToCart(product);

    expect(shop.itemCount, 1);
    expect(shop.items, hasLength(1));
    expect(shop.total, 25.0);
  });

  test('adding the same product twice increases quantity', () {
    shop.addToCart(product);
    shop.addToCart(product);

    expect(shop.itemCount, 2);
    expect(shop.items.single.quantity, 2);
    expect(shop.total, 50.0);
  });

  test('updating quantity recalculates the cart total', () {
    shop.addToCart(product);
    shop.updateQuantity(product.id, 3);

    expect(shop.itemCount, 3);
    expect(shop.total, 75.0);
  });

  test('setting quantity to zero removes the item', () {
    shop.addToCart(product);
    shop.updateQuantity(product.id, 0);

    expect(shop.items, isEmpty);
    expect(shop.itemCount, 0);
    expect(shop.total, 0.0);
  });

  test('removing a product clears it from the cart', () {
    shop.addToCart(product);
    shop.removeFromCart(product.id);

    expect(shop.items, isEmpty);
    expect(shop.total, 0.0);
  });

  test('clearing the cart removes all items and resets totals', () {
    shop.addToCart(product);
    shop.addToCart(product);

    shop.clearCart();

    expect(shop.items, isEmpty);
    expect(shop.itemCount, 0);
    expect(shop.total, 0.0);
  });
}