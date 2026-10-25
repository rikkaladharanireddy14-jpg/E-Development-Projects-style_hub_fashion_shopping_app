import 'package:flutter_test/flutter_test.dart';
import 'package:style_hub/src/product.dart';
import 'package:style_hub/src/shop_state.dart';

void main() {
  late ShopState shop;
  late Product product;

  setUp(() {
    shop = ShopState();
    product = const Product(
      id: 'notification-shirt',
      name: 'Classic Shirt',
      description: 'A comfortable everyday shirt',
      category: 'tops',
      price: 25.0,
      imageUrl: '',
    );
  });

  tearDown(() {
    shop.dispose();
  });

  test('adding to cart notifies listeners', () {
    var notifications = 0;
    shop.addListener(() => notifications++);

    shop.addToCart(product);

    expect(notifications, 1);
    expect(shop.itemCount, 1);
  });

  test('wishlist changes notify listeners', () {
    var notifications = 0;
    shop.addListener(() => notifications++);

    shop.toggleWishlist(product);
    expect(notifications, 1);
    expect(shop.isWishlisted(product.id), isTrue);

    shop.toggleWishlist(product);
    expect(notifications, 2);
    expect(shop.isWishlisted(product.id), isFalse);
  });

  test('clearing the cart notifies listeners', () {
    shop.addToCart(product);

    var notifications = 0;
    shop.addListener(() => notifications++);

    shop.clearCart();

    expect(notifications, 1);
    expect(shop.items, isEmpty);
    expect(shop.total, 0.0);
  });
}